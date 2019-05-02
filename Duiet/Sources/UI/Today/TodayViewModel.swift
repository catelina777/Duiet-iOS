//
//  TodayViewModel.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
                return UIImagePickerController.rx.create(vc) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = false
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { $0[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage }
            .share(replay: 1, scope: .whileConnected)

        let showDetail = _viewDidAppear
            .map { true }
            .withLatestFrom(pickedImage)

        output = Output(pickedImage: pickedImage,
                        showDetail: showDetail)
    }
}

extension TodayViewModel {
    struct Input {
        let viewDidAppear: AnyObserver<Void>
        let viewDidDisappear: AnyObserver<Void>
        let addButtonTap: AnyObserver<TodayViewController>
    }
    struct Output {
        let pickedImage: Observable<UIImage?>
        let showDetail: Observable<UIImage?>
    }
}
