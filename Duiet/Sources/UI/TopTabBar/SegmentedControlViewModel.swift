//
//  SegmentedControlViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/30.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol SegmentedControlViewModelInput {
    var didSelectMonthItem: AnyObserver<MonthEntity> { get }
    var didSelectDayItem: AnyObserver<Day> { get }
}

protocol SegmentedControlViewModelOutput {
    var showDetailDay: Observable<Day> { get }
    var showDays: Observable<MonthEntity> { get }
    var showIndex: Observable<Int> { get }
}

protocol SegmentedControlViewModelState {}

protocol SegmentedControlViewModelProtocol {
    var input: SegmentedControlViewModelInput { get }
    var output: SegmentedControlViewModelOutput { get }
    var state: SegmentedControlViewModelState { get }
}

final class SegmentedControlViewModel: SegmentedControlViewModelProtocol, SegmentedControlViewModelState {
    let input: SegmentedControlViewModelInput
    let output: SegmentedControlViewModelOutput
    var state: SegmentedControlViewModelState { self }

    private let disposeBag = DisposeBag()

    init() {
        let didSelectDayItem = PublishRelay<Day>()
        let didSelectMonthItem = PublishRelay<MonthEntity>()
        input = Input(didSelectMonthItem: didSelectMonthItem.asObserver(),
                      didSelectDayItem: didSelectDayItem.asObserver())

        let showIndex = PublishRelay<Int>()
        didSelectDayItem
            .map { _ in 0 }
            .bind(to: showIndex)
            .disposed(by: disposeBag)

        didSelectMonthItem
            .map { _ in 1 }
            .bind(to: showIndex)
            .disposed(by: disposeBag)

        output = Output(showDetailDay: didSelectDayItem.asObservable(),
                        showDays: didSelectMonthItem.asObservable(),
                        showIndex: showIndex.asObservable())
    }
}

extension SegmentedControlViewModel {
    struct Input: SegmentedControlViewModelInput {
        let didSelectMonthItem: AnyObserver<MonthEntity>
        let didSelectDayItem: AnyObserver<Day>
    }

    struct Output: SegmentedControlViewModelOutput {
        let showDetailDay: Observable<Day>
        let showDays: Observable<MonthEntity>
        let showIndex: Observable<Int>
    }
}
