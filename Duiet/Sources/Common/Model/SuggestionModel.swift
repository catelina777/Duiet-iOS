//
//  SuggestionModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol SuggestionModelInput {
    var inputKeyword: AnyObserver<String> { get }
}

protocol SuggestionModelOutput {
    var suggestedContentResults: Observable<[Food]> { get }
}

protocol SuggestionModelState {
    var suggestedContents: [Food] { get }
}

protocol SuggestionModelProtocol {
    var input: SuggestionModelInput { get }
    var output: SuggestionModelOutput { get }
    var state: SuggestionModelState { get }
}

final class SuggestionModel: SuggestionModelProtocol, SuggestionModelState {
    static let shared = SuggestionModel()
    let input: SuggestionModelInput
    let output: SuggestionModelOutput
    var state: SuggestionModelState { self }

    var suggestedContents: [Food] {
        suggestedContentResults.value
    }

    private let suggestedContentResults = BehaviorRelay<[Food]>(value: [])
    private let disposeBag = DisposeBag()

    init(service: FoodServiceProtocol = FoodService.shared) {
        let inputKeyword = PublishRelay<String>()
        input = Input(inputKeyword: inputKeyword.asObserver())

        inputKeyword
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap { $0.isEmpty ? service.findAll() : service.find(by: $0) }
            .map { $0.map { Food(entity: $0) } }
            .bind(to: suggestedContentResults)
            .disposed(by: disposeBag)

        output = Output(suggestedContentResults: suggestedContentResults.asObservable())
    }
}

extension SuggestionModel {
    struct Input: SuggestionModelInput {
        let inputKeyword: AnyObserver<String>
    }

    struct Output: SuggestionModelOutput {
        let suggestedContentResults: Observable<[Food]>
    }
}
