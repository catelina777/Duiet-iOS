//
//  TodayViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

final class TodayViewModel {

    let title = "Today"

    let input: Input
    let output: Output

    private let disposeBag = DisposeBag()

    init() {
        let _viewDidAppear = PublishRelay<Void>()
        let _viewDidDisappear = PublishRelay<Void>()
        let _addButtonTap = PublishRelay<TodayViewController>()

        input = Input(viewDidAppear: _viewDidAppear.asObserver(),
                      viewDidDisappear: _viewDidDisappear.asObserver(),
                      addButtonTap: _addButtonTap.asObserver())

        let pickedImage = _addButtonTap
            .flatMapLatest { vc in
                return RxYPImagePicker.rx
                    .create(vc)
                    .flatMap { $0.pickedImage }
                    .take(1)
            }
            .share()

        let showDetail = _viewDidAppear
            .map { true }
            .withLatestFrom(pickedImage)

        output = Output(showDetail: showDetail)
    }
}

extension TodayViewModel {
    struct Input {
        let viewDidAppear: AnyObserver<Void>
        let viewDidDisappear: AnyObserver<Void>
        let addButtonTap: AnyObserver<TodayViewController>
    }
    struct Output {
        let showDetail: Observable<UIImage?>
    }
}
