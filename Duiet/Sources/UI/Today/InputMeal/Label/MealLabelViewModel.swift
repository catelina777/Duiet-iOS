//
//  MealLabelViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/10.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol MealLabelViewModelInput {
    var contentDidUpdate: AnyObserver<Content> { get }
    var contentDidDelete: AnyObserver<Void> { get }
}

protocol MealLabelViewModelOutput {
    var contentDidUpdate: Observable<Content> { get }
    var hideView: Observable<Void> { get }
}

protocol MealLabelViewModelData {
    var content: Content { get }
}

protocol MealLabelViewModelProtocol {
    var input: MealLabelViewModelInput { get }
    var output: MealLabelViewModelOutput { get }
    var data: MealLabelViewModelData { get }
}

final class MealLabelViewModel: MealLabelViewModelProtocol, MealLabelViewModelData {
    let input: MealLabelViewModelInput
    let output: MealLabelViewModelOutput
    var data: MealLabelViewModelData { return self }

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
                guard let me = self else { return }
                me._content.accept(content)
            })
            .disposed(by: disposeBag)
    }
}

extension MealLabelViewModel {
    struct Input: MealLabelViewModelInput {
        let contentDidUpdate: AnyObserver<Content>
        let contentDidDelete: AnyObserver<Void>
    }

    struct Output: MealLabelViewModelOutput {
        let contentDidUpdate: Observable<Content>
        let hideView: Observable<Void>
    }

    var content: Content {
        _content.value
    }
}
