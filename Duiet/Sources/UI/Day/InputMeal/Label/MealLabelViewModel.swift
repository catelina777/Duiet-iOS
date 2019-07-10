//
//  MealLabelViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/10.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

final class MealLabelViewModel {

    let input: Input
    let output: Output

    var content: Content {
        return _content.value
    }

    private let _content: BehaviorRelay<Content>
    private let disposeBag = DisposeBag()

    init(content: Content) {
        _content = BehaviorRelay<Content>(value: content)

        let _didContentUpdate = PublishRelay<Content>()
        let _didDeleteContent = PublishRelay<Void>()
        input = Input(didContentUpdate: _didContentUpdate.asObserver(),
                      didDeleteContent: _didDeleteContent.asObserver())

        let hideView = _didDeleteContent.asObservable()
        output = Output(hideView: hideView)

        _didContentUpdate
            .subscribe(onNext: { [weak self] content in
                guard let self = self else { return }
                self._content.accept(content)
            })
            .disposed(by: disposeBag)
    }
}

extension MealLabelViewModel {

    struct Input {
        let didContentUpdate: AnyObserver<Content>
        let didDeleteContent: AnyObserver<Void>
    }
    struct Output {
        let hideView: Observable<Void>
    }
}
