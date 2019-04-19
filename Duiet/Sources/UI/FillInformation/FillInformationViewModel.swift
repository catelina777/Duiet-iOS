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

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    init() {
        let _gender = BehaviorRelay<Bool?>(value: nil)
        let _height = BehaviorRelay<Double?>(value: nil)
        let _weight = BehaviorRelay<Double?>(value: nil)
        let _activityInputLevel = BehaviorRelay<ActivityLevel?>(value: nil)
        let _selectedIndexPath = PublishRelay<IndexPath>()

        self.input = Input(gender: _gender.asObserver(),
                           height: _height.asObserver(),
                           weight: _weight.asObserver(),
                           activityLevel: _activityInputLevel.asObserver(),
                           selectedIndexPath: _selectedIndexPath.asObserver())

        let activityOutputLevel = BehaviorRelay<ActivityLevel?>(value: nil)
        let showActivityLevel = _selectedIndexPath
            .filter { $0.row == 3 }
            .map { _ in () }
        self.output = Output(showActivityLevel: showActivityLevel,
                             activityLevel: activityOutputLevel.asObservable())
    }
}

extension FillInformationViewModel {

    struct Input {
        let gender: AnyObserver<Bool?>
        let height: AnyObserver<Double?>
        let weight: AnyObserver<Double?>
        let activityLevel: AnyObserver<ActivityLevel?>
        let selectedIndexPath: AnyObserver<IndexPath>
    }

    struct Output {
        let showActivityLevel: Observable<Void>
        let activityLevel: Observable<ActivityLevel?>
    }
}
