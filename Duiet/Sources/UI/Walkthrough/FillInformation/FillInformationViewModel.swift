//
//  FillInformationViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxRelay
import RxSwift

protocol FillInformationViewModelInput {
    var gender: AnyObserver<Bool?> { get }
    var age: AnyObserver<Int?> { get }
    var height: AnyObserver<Double?> { get }
    var weight: AnyObserver<Double?> { get }
    var activityLevel: AnyObserver<ActivityLevelType> { get }
    var didTapCompleteButton: AnyObserver<Void> { get }
}

protocol FillInformationViewModelOutput {
    var gender: Observable<Bool?> { get }
    var isValidateComplete: Observable<Bool> { get }
    var didTapComplete: Observable<Void> { get }
    var BMR: Observable<String> { get }
    var TDEE: Observable<String> { get }
}

protocol FillInformationViewModelProtocol {
    var input: FillInformationViewModelInput { get }
    var output: FillInformationViewModelOutput { get }
}

// TODO: Separate domain logic into model
final class FillInformationViewModel: FillInformationViewModelProtocol {
    let input: FillInformationViewModelInput
    let output: FillInformationViewModelOutput

    private let disposeBag = DisposeBag()

    init(userInfoModel: UserInfoModelProtocol = UserInfoModel.shared) {
        let _gender = BehaviorRelay<Bool?>(value: nil)
        let _age = BehaviorRelay<Int?>(value: nil)
        let _height = BehaviorRelay<Double?>(value: nil)
        let _weight = BehaviorRelay<Double?>(value: nil)
        let _activityLevel = BehaviorRelay<ActivityLevelType>(value: .none)
        let _didTapCompleteButton = PublishRelay<Void>()

        input = Input(gender: _gender.asObserver(),
                      age: _age.asObserver(),
                      height: _height.asObserver(),
                      weight: _weight.asObserver(),
                      activityLevel: _activityLevel.asObserver(),
                      didTapCompleteButton: _didTapCompleteButton.asObserver())

        let gender = _gender.asObservable()

        let combinedInfo = Observable
            .combineLatest(_gender, _age, _height, _weight, _activityLevel)
            .share()

        let isValidateComplete = combinedInfo
            .map { gender, age, height, weight, level -> Bool in
                let isCompleteForm = (gender != nil) && (age != nil) && (height != nil) && (weight != nil)
                let isCompleteSelect = level != .none
                return isCompleteForm && isCompleteSelect
            }
            .distinctUntilChanged()

        let userInfo = PublishRelay<UserInfo>()
        let didTapComplete = _didTapCompleteButton

        let BMRWithActivityLevel = combinedInfo
            .map { v0, v1, v2, v3, v4 -> (Double, ActivityLevelType) in
                guard
                    let v0 = v0,
                    let v1 = v1,
                    let v2 = v2,
                    let v3 = v3,
                    v4 != .none
                else { return (0, v4) }
                let _userInfo = UserInfo(gender: v0,
                                         age: v1,
                                         height: v2,
                                         weight: v3,
                                         activityLevel: v4)
                userInfo.accept(_userInfo)
                return (_userInfo.BMR, v4)
            }
            .share()

        /// If initialize everything finish in init, cant't refer to self and cant's use UnitLocalizable
        /// Therefore, generates a useless formatter
        let unitFormatter = MeasurementFormatter()
        let BMR = BMRWithActivityLevel
            .map { bmr, activityLevel -> String in
                guard
                    bmr != 0,
                    activityLevel != .none
                else { return R.string.localizable.calc() }
                return "\(Int(bmr)) \(unitFormatter.string(from: UnitEnergy.kilocalories))"
            }

        let TDEE = BMRWithActivityLevel
            .map { bmr, activityLevel -> String in
                guard
                    bmr != 0,
                    activityLevel != .none
                else { return R.string.localizable.calc() }
                return "\(Int(bmr * activityLevel.magnification)) \(unitFormatter.string(from: UnitEnergy.kilocalories))"
            }

        output = Output(gender: gender,
                        isValidateComplete: isValidateComplete,
                        didTapComplete: didTapComplete.asObservable(),
                        BMR: BMR,
                        TDEE: TDEE)

        didTapComplete.withLatestFrom(userInfo)
            .subscribe(onNext: {
                userInfoModel.state.add(userInfo: $0)
            })
            .disposed(by: disposeBag)
    }

    convenience init(coordinator: WalkthrouthCoordinator) {
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
        let gender: AnyObserver<Bool?>
        let age: AnyObserver<Int?>
        let height: AnyObserver<Double?>
        let weight: AnyObserver<Double?>
        let activityLevel: AnyObserver<ActivityLevelType>
        let didTapCompleteButton: AnyObserver<Void>
    }

    struct Output: FillInformationViewModelOutput {
        let gender: Observable<Bool?>
        let isValidateComplete: Observable<Bool>
        let didTapComplete: Observable<Void>
        let BMR: Observable<String>
        let TDEE: Observable<String>
    }
}
