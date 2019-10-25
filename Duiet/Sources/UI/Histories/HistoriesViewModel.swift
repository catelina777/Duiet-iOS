//
//  HistoriesViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/22.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol HistoriesViewModelInput {
    var selectedIndex: AnyObserver<Int> { get }
}

protocol HistoriesViewModelOutput {}

protocol HistoriesViewModelState {}

protocol HistoriesViewModelProtocol {
    var input: HistoriesViewModelInput { get }
    var output: HistoriesViewModelOutput { get }
    var state: HistoriesViewModelState { get }
}

final class HistoriesViewModel: HistoriesViewModelProtocol, HistoriesViewModelState {
    let input: HistoriesViewModelInput
    let output: HistoriesViewModelOutput
    var state: HistoriesViewModelState { self }

    private let disposeBag = DisposeBag()

    init() {
        let selectedIndex = PublishRelay<Int>()
        input = Input(selectedIndex: selectedIndex.asObserver())

        selectedIndex
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
        output = Output()
    }
}

extension HistoriesViewModel {
    struct Input: HistoriesViewModelInput {
        let selectedIndex: AnyObserver<Int>
    }
    struct Output: HistoriesViewModelOutput {}
}
