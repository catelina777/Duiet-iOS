//
//  FillInformationViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol FillInformationViewModelInput {
    var biologicalSex: AnyObserver<BiologicalSexType?> { get }
    var age: AnyObserver<Int?> { get }
    var height: AnyObserver<Double?> { get }
    var weight: AnyObserver<Double?> { get }
    var activityLevel: AnyObserver<ActivityLevelType> { get }
    var didTapCompleteButton: AnyObserver<Void> { get }
}

protocol FillInformationViewModelOutput {
    var biologicalSex: Observable<BiologicalSexType?> { get }
    var isValidateComplete: Observable<Bool> { get }
    var didTapComplete: Observable<Void> { get }
    var BMR: Observable<String> { get }
    var TDEE: Observable<String> { get }
}

protocol FillInformationViewModelState {
    var unitCollectionValue: UnitCollection { get }
}

protocol FillInformationViewModelProtocol {
    var input: FillInformationViewModelInput { get }
    var output: FillInformationViewModelOutput { get }
    var state: FillInformationViewModelState { get }
}

// TODO: Separate domain logic into model
final class FillInformationViewModel: FillInformationViewModelProtocol, FillInformationViewModelState {
    let input: FillInformationViewModelInput
    let output: FillInformationViewModelOutput
    var state: FillInformationViewModelState { self }

    var unitCollectionValue: UnitCollection {
        unitCollectionModel.state.unitCollectionValue
    }

    private let unitCollectionModel: UnitCollectionModelProtocol
    private let disposeBag = DisposeBag()

    init(userProfileModel: UserProfileModelProtocol = UserProfileModel.shared,
         unitCollectionModel: UnitCollectionModelProtocol = UnitCollectionModel.shared) {
        self.unitCollectionModel = unitCollectionModel

        let biologicalSex = PublishRelay<BiologicalSexType?>()
        let age = PublishRelay<Int?>()
        let height = PublishRelay<Double?>()
        let weight = PublishRelay<Double?>()
        let activityLevel = PublishRelay<ActivityLevelType>()
        let didTapCompleteButton = PublishRelay<Void>()

        input = Input(biologicalSex: biologicalSex.asObserver(),
                      age: age.asObserver(),
                      height: height.asObserver(),
                      weight: weight.asObserver(),
                      activityLevel: activityLevel.asObserver(),
                      didTapCompleteButton: didTapCompleteButton.asObserver())

        let combinedInfo = Observable
            .combineLatest(biologicalSex, age, height, weight, activityLevel)
            .share()

        let isValidateComplete = combinedInfo
            .map { gender, age, height, weight, level -> Bool in
                let isCompleteForm = (gender != nil) && (age != nil) && (height != nil) && (weight != nil)
                let isCompleteSelect = level != .none
                return isCompleteForm && isCompleteSelect
            }
            .distinctUntilChanged()

        let userProfile = PublishRelay<UserProfile>()
        let didTapComplete = didTapCompleteButton

        let BMRWithActivityLevel = combinedInfo
            .map { v0, v1, v2, v3, v4 -> (Double, ActivityLevelType) in
                guard
                    let v0 = v0,
                    let v1 = v1,
                    let v2 = v2,
                    let v3 = v3,
                    v4 != .none
                else { return (0, v4) }
                let userProfileEntity = UserProfile(id: UUID(),
                                                    age: Int16(v1),
                                                    biologicalSex: "\(v0.rawValue)",
                                                    height: v2,
                                                    weight: v3,
                                                    activityLevel: "\(v4)",
                                                    createdAt: Date(),
                                                    updatedAt: Date())
                userProfile.accept(userProfileEntity)
                return (userProfileEntity.BMR, v4)
            }
            .share()

        /// If initialize everything finish in init, cant't refer to self and cant's use UnitLocalizable
        /// Therefore, generates a useless formatter
        let BMR = BMRWithActivityLevel
            .map { bmr, activityLevel -> String in
                guard
                    bmr != 0,
                    activityLevel != .none
                else { return R.string.localizable.calc() }
                return UnitBabel.shared.convertWithSymbol(value: bmr,
                                                          from: .kilocalories,
                                                          to: unitCollectionModel.state.unitCollectionValue.energyUnit)
            }

        let TDEE = BMRWithActivityLevel
            .map { bmr, activityLevel -> String in
                guard
                    bmr != 0,
                    activityLevel != .none
                else { return R.string.localizable.calc() }
                return UnitBabel.shared.convertWithSymbol(value: bmr * activityLevel.magnification,
                                                          from: .kilocalories,
                                                          to: unitCollectionModel.state.unitCollectionValue.energyUnit)
            }

        output = Output(biologicalSex: biologicalSex.asObservable(),
                        isValidateComplete: isValidateComplete,
                        didTapComplete: didTapComplete.asObservable(),
                        BMR: BMR,
                        TDEE: TDEE)

        didTapComplete.withLatestFrom(userProfile)
            .subscribe(onNext: {
                userProfileModel.state.add(userProfile: $0)
            })
            .disposed(by: disposeBag)
    }

    convenience init(coordinator: OnboardingCoordinator) {
        self.init()

        // MARK: - Processing to transition
        output.didTapComplete
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                coordinator.showTop()
            })
            .disposed(by: disposeBag)
    }

    convenience init(coordinator: SettingCoordinator) {
        self.init()

        // MARK: - Processing to transition
        output.didTapComplete
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                coordinator.pop()
            })
            .disposed(by: disposeBag)
    }
}

extension FillInformationViewModel {
    struct Input: FillInformationViewModelInput {
        let biologicalSex: AnyObserver<BiologicalSexType?>
        let age: AnyObserver<Int?>
        let height: AnyObserver<Double?>
        let weight: AnyObserver<Double?>
        let activityLevel: AnyObserver<ActivityLevelType>
        let didTapCompleteButton: AnyObserver<Void>
    }

    struct Output: FillInformationViewModelOutput {
        let biologicalSex: Observable<BiologicalSexType?>
        let isValidateComplete: Observable<Bool>
        let didTapComplete: Observable<Void>
        let BMR: Observable<String>
        let TDEE: Observable<String>
    }
}
