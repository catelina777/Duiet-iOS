//
//  FillInformationViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RealmSwift
import RxRealm

final class FillInformationViewModel {

    let title = "Calculate"
    let rowCounts = 7

    let input: Input
    let output: Output

    private let coordinator: WalkthrouthCoordinator
    private let disposeBag = DisposeBag()

    private(set) lazy var ageList: [Int] = {
        return [Int].init(repeating: 0, count: 120).enumerated().map { $0.offset }
    }()

    private(set) lazy var heightList: [Double] = {
        let list = [Double].init(repeating: 0, count: 215)
        return list.enumerated().map { Double($0.offset) * 0.5 + 100 }
    }()

    private(set) lazy var weightList: [Double] = {
        let list = [Double].init(repeating: 0, count: 150)
        return list.enumerated().map { Double($0.offset) * 0.5 + 20 }
    }()

    let activityTypes: [ActivityLevel] = [.none, .sedentary, .lightly, .moderately, .veryActive]


    init(coordinator: WalkthrouthCoordinator) {
        self.coordinator = coordinator

        let _gender = BehaviorRelay<Bool?>(value: nil)
        let _age = BehaviorRelay<Int?>(value: nil)
        let _height = BehaviorRelay<Double?>(value: nil)
        let _weight = BehaviorRelay<Double?>(value: nil)
        let _activityLevel = BehaviorRelay<ActivityLevel>(value: .none)
        let _didTapComplete = PublishRelay<Void>()

        self.input = Input(gender: _gender.asObserver(),
                           age: _age.asObserver(),
                           height: _height.asObserver(),
                           weight: _weight.asObserver(),
                           activityLevel: _activityLevel.asObserver(),
                           didTapComplete: _didTapComplete.asObserver())

        let gender = _gender.asObservable()

        let combinedInfo = Observable
            .combineLatest(_gender, _age, _height, _weight, _activityLevel)
            .share()

        let isValidateComplete = combinedInfo
            .map { v0, v1, v2, v3, v4 -> Bool in
                return (v0 != nil) && (v1 != nil) && (v2 != nil) && (v3 != nil) && (v4 != .none)
            }
            .distinctUntilChanged()

        let userInfo = PublishRelay<UserInfo>()
        let didTapComplete = _didTapComplete

        let BMRWithActivityLevel = combinedInfo
            .map { v0, v1, v2, v3, v4 -> (Double, ActivityLevel) in
                guard
                    let v0 = v0,
                    let v1 = v1,
                    let v2 = v2,
                    let v3 = v3,
                    v4 != .none
                else {
                    return (0, v4)
                }
                let _userInfo = UserInfo(gender: v0,
                                        age: v1,
                                        height: v2,
                                        weight: v3,
                                        activityLevel: v4)
                userInfo.accept(_userInfo)
                return (_userInfo.BMR, v4)
            }
            .share()

        let BMR = BMRWithActivityLevel
            .map { bmr, activityLevel -> String in
                guard
                    bmr != 0,
                    activityLevel != .none
                else {
                    return "calc..."
                }
                return "\(Int(bmr)) kcal"
            }

        let TDEE = BMRWithActivityLevel
            .map { bmr, activityLevel -> String in
                guard
                    bmr != 0,
                    activityLevel != .none
                else {
                    return "calc..."
                }
                return "\(Int(bmr * activityLevel.magnification)) kcal"
            }

        self.output = Output(gender: gender,
                             isValidateComplete: isValidateComplete,
                             didTapComplete: didTapComplete.asObservable(),
                             BMR: BMR,
                             TDEE: TDEE)

        didTapComplete.withLatestFrom(userInfo)
            .map { $0 }
            .bind(to: Realm.rx.add(update: true))
            .disposed(by: disposeBag)

        // MARK: - Processing to transition
        didTapComplete
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                coordinator.showTop()
            })
            .disposed(by: disposeBag)
    }
}

extension FillInformationViewModel {

    struct Input {
        let gender: AnyObserver<Bool?>
        let age: AnyObserver<Int?>
        let height: AnyObserver<Double?>
        let weight: AnyObserver<Double?>
        let activityLevel: AnyObserver<ActivityLevel>
        let didTapComplete: AnyObserver<Void>
    }

    struct Output {
        let gender: Observable<Bool?>
        let isValidateComplete: Observable<Bool>
        let didTapComplete: Observable<Void>
        let BMR: Observable<String>
        let TDEE: Observable<String>
    }
}
