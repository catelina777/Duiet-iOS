//
//  SelectActivityLevelViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/18.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class SelectActivityLevelViewModel {
    var activityLevel = PublishRelay<ActivityLevel?>()

    let input: Input
    let output: Output

    init(fillInformationInput: AnyObserver<ActivityLevel?>,
         fillInformationOutput: Observable<ActivityLevel?>) {

        let _selectedIndexPath = PublishRelay<IndexPath>()
        self.input = Input(activityLevel: fillInformationInput,
                           selectedIndexPath: _selectedIndexPath.asObserver())

        let activityLevel = _selectedIndexPath
            .map { ActivityLevel.getType(with: $0) }
        self.output = Output(activityLevel: activityLevel)
    }
}

extension SelectActivityLevelViewModel {

    struct Input {
        let activityLevel: AnyObserver<ActivityLevel?>
        let selectedIndexPath: AnyObserver<IndexPath>
    }

    struct Output {
        let activityLevel: Observable<ActivityLevel>
    }
}
