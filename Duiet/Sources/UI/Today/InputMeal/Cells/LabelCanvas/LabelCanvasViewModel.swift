//
//  LabelCanvasViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol LabelCanvasViewModelInput {
    var inputKeyword: AnyObserver<String> { get }
    var suggestionDidSelect: AnyObserver<FoodEntity> { get }
}

protocol LabelCanvasViewModelOutput {
    var suggestedContentResults: Observable<[FoodEntity]> { get }
    var suggestionDidSelect: Observable<FoodEntity> { get }
}

protocol LabelCanvasViewModelState {
    var suggestedContents: [FoodEntity] { get }
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

    var suggestedContents: [FoodEntity] {
        suggestedContentResults.value
    }

    private let suggestedContentResults = BehaviorRelay<[FoodEntity]>(value: [])

    private let disposeBag = DisposeBag()

    init(suggestionModel: SuggestionModelProtocol = SuggestionModel.shared) {
        let inputKeyword = PublishRelay<String>()
        let suggestionDidSelect = PublishRelay<FoodEntity>()
        input = Input(inputKeyword: inputKeyword.asObserver(),
                      suggestionDidSelect: suggestionDidSelect.asObserver())

        output = Output(suggestedContentResults: suggestedContentResults.asObservable(),
                        suggestionDidSelect: suggestionDidSelect.asObservable())

        inputKeyword
            .bind(to: suggestionModel.input.inputKeyword)
            .disposed(by: disposeBag)

        suggestionModel.output.suggestedContentResults
            .compactMap { $0 }
            .distinctUntilChanged()
            .bind(to: suggestedContentResults)
            .disposed(by: disposeBag)
    }
}

extension LabelCanvasViewModel {
    struct Input: LabelCanvasViewModelInput {
        let inputKeyword: AnyObserver<String>
        var suggestionDidSelect: AnyObserver<FoodEntity>
    }

    struct Output: LabelCanvasViewModelOutput {
        let suggestedContentResults: Observable<[FoodEntity]>
        let suggestionDidSelect: Observable<FoodEntity>
    }
}
