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

        let _contentDidUpdate = PublishRelay<Content>()
        let _contentDidDelete = PublishRelay<Void>()
        input = Input(contentDidUpdate: _contentDidUpdate.asObserver(),
                      contentDidDelete: _contentDidDelete.asObserver())

        let hideView = _contentDidDelete
        output = Output(contentDidUpdate: _contentDidUpdate.asObservable(),
                        hideView: hideView.asObservable())

        _contentDidUpdate
            .subscribe(onNext: { [weak self] content in
                guard let self = self else { return }
                self._content.accept(content)
            })
            .disposed(by: disposeBag)
    }
}

extension MealLabelViewModel {

    struct Input {
        let contentDidUpdate: AnyObserver<Content>
        let contentDidDelete: AnyObserver<Void>
    }
    struct Output {
        let contentDidUpdate: Observable<Content>
        let hideView: Observable<Void>
    }
}
