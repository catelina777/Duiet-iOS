//
//  LabelCanvasViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxRelay
import RxSwift

protocol LabelCanvasViewModelInput {
    var inputKeyword: AnyObserver<String> { get }
    var suggestionDidSelect: AnyObserver<Content> { get }
}

protocol LabelCanvasViewModelOutput {
    var suggestedContentResults: Observable<Results<Content>?> { get }
    var suggestionDidSelect: Observable<Content> { get }
}

protocol LabelCanvasViewModelState {
    var suggestedContents: Results<Content>? { get }
}

protocol LabelCanvasViewModelProtocol {
    var input: LabelCanvasViewModelInput { get }
    var output: LabelCanvasViewModelOutput { get }
    var state: LabelCanvasViewModelState { get }
}

final class LabelCanvasViewModel: LabelCanvasViewModelProtocol, LabelCanvasViewModelState {
    let input: LabelCanvasViewModelInput
    let output: LabelCanvasViewModelOutput
    var state: LabelCanvasViewModelState { self }

    var suggestedContents: Results<Content>? {
        suggestedContentResults.value
    }

    private let suggestedContentResults = BehaviorRelay<Results<Content>?>(value: nil)

    private let disposeBag = DisposeBag()

    init(suggestionModel: SuggestionModelProtocol = SuggestionModel.shared) {
        let inputKeyword = PublishRelay<String>()
        let suggestionDidSelect = PublishRelay<Content>()
        input = Input(inputKeyword: inputKeyword.asObserver(),
                      suggestionDidSelect: suggestionDidSelect.asObserver())

        output = Output(suggestedContentResults: suggestedContentResults.asObservable(),
                        suggestionDidSelect: suggestionDidSelect.asObservable())

        inputKeyword
            .bind(to: suggestionModel.input.inputKeyword)
            .disposed(by: disposeBag)

        suggestionModel.output.suggestedContentResults
            .compactMap { $0 }
            .flatMap { Observable.collection(from: $0) }
            .distinctUntilChanged()
            .bind(to: suggestedContentResults)
            .disposed(by: disposeBag)
    }
}

extension LabelCanvasViewModel {
    struct Input: LabelCanvasViewModelInput {
        let inputKeyword: AnyObserver<String>
        var suggestionDidSelect: AnyObserver<Content>
    }

    struct Output: LabelCanvasViewModelOutput {
        let suggestedContentResults: Observable<Results<Content>?>
        let suggestionDidSelect: Observable<Content>
    }
}
