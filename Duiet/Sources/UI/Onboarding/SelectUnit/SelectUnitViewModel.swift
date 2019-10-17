//
//  SelectUnitViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/14.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol SelectUnitViewModelInput {
    var heightUnitRow: AnyObserver<Int> { get }
    var weightUnitRow: AnyObserver<Int> { get }
    var energyUnitRow: AnyObserver<Int> { get }
    var didTapNextButton: AnyObserver<Void> { get }
}

protocol SelectUnitViewModelOutput {}

protocol SelectUnitViewModelState {}

protocol SelectUnitViewModelProtocol {
    var input: SelectUnitViewModelInput { get }
    var output: SelectUnitViewModelOutput { get }
    var state: SelectUnitViewModelState { get }
}

class SelectUnitViewModel: SelectUnitViewModelProtocol, SelectUnitViewModelState {
    let input: SelectUnitViewModelInput
    let output: SelectUnitViewModelOutput
    var state: SelectUnitViewModelState { self }

    private let disposeBag = DisposeBag()

    init(coordinator: OnboardingCoordinator) {
        let heightUnitRow = PublishRelay<Int>()
        let weightUnitRow = PublishRelay<Int>()
        let energyUnitRow = PublishRelay<Int>()
        let didTapNextButton = PublishRelay<Void>()
        input = Input(heightUnitRow: heightUnitRow.asObserver(),
                      weightUnitRow: weightUnitRow.asObserver(),
                      energyUnitRow: energyUnitRow.asObserver(),
                      didTapNextButton: didTapNextButton.asObserver())
        output = Output()

        didTapNextButton
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                coordinator.showFillInformation()
            })
            .disposed(by: disposeBag)
    }
}

extension SelectUnitViewModel {
    struct Input: SelectUnitViewModelInput {
        let heightUnitRow: AnyObserver<Int>
        let weightUnitRow: AnyObserver<Int>
        let energyUnitRow: AnyObserver<Int>
        let didTapNextButton: AnyObserver<Void>
    }

    struct Output: SelectUnitViewModelOutput {}
}
