//
//  FillInformationViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class FillInformationViewModel {

    let title = "Fill Information"
    let rowCounts = 5

    let input: Input
    let output: Output

    private(set) lazy var heightList: [Double] = {
        let list = [Double].init(repeating: 0, count: 215)
        return list.enumerated().map { Double($0.offset) * 0.5 + 100 }
    }()

    private(set) lazy var weightList: [Double] = {
        let list = [Double].init(repeating: 0, count: 150)
        return list.enumerated().map { Double($0.offset) * 0.5 + 20 }
    }()

    let activityTypes: [ActivityLevel] = [.none, .sedentary, .lightly, .moderately, .veryActive]

    private let disposeBag = DisposeBag()

    init() {
        let _gender = BehaviorRelay<Bool?>(value: nil)
        let _height = BehaviorRelay<Double?>(value: nil)
        let _weight = BehaviorRelay<Double?>(value: nil)
        let _activityLevel = BehaviorRelay<ActivityLevel>(value: .none)
        let _completeButtonTap = PublishRelay<Void>()

        self.input = Input(gender: _gender.asObserver(),
                           height: _height.asObserver(),
                           weight: _weight.asObserver(),
                           activityLevel: _activityLevel.asObserver(),
                           completeButtonTap: _completeButtonTap.asObserver())

        let isValidateComplete = Observable
            .combineLatest(_gender, _height, _weight, _activityLevel) { v1, v2, v3, v4 -> Bool in
                return (v1 != nil) && (v2 != nil) && (v3 != nil) && (v4 != .none)
            }
            .distinctUntilChanged()

        let completeButtonTap = _completeButtonTap

        self.output = Output(isValidateComplete: isValidateComplete,
                             didTapComplete: completeButtonTap.asObservable())
    }
}

extension FillInformationViewModel {

    struct Input {
        let gender: AnyObserver<Bool?>
        let height: AnyObserver<Double?>
        let weight: AnyObserver<Double?>
        let activityLevel: AnyObserver<ActivityLevel>
        let completeButtonTap: AnyObserver<Void>
    }

    struct Output {
        let isValidateComplete: Observable<Bool>
        let didTapComplete: Observable<Void>
    }
}
