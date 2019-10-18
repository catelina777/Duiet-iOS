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
    var heightUnitRow: AnyObserver<Int?> { get }
    var weightUnitRow: AnyObserver<Int?> { get }
    var energyUnitRow: AnyObserver<Int?> { get }
    var didTapNextButton: AnyObserver<Void> { get }
}

protocol SelectUnitViewModelOutput {
    var isValidateComplete: Observable<Bool> { get }
}

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

    init(coordinator: OnboardingCoordinator,
         repository: UnitCollectionRepositoryProtocol = UnitCollectionRepository.shared) {
        let heightUnitRow = PublishRelay<Int?>()
        let weightUnitRow = PublishRelay<Int?>()
        let energyUnitRow = PublishRelay<Int?>()
        let didTapNextButton = PublishRelay<Void>()
        input = Input(heightUnitRow: heightUnitRow.asObserver(),
                      weightUnitRow: weightUnitRow.asObserver(),
                      energyUnitRow: energyUnitRow.asObserver(),
                      didTapNextButton: didTapNextButton.asObserver())

        let isValidateComplete = Observable.combineLatest(heightUnitRow, weightUnitRow, energyUnitRow)
            .map { $0 != nil && $1 != nil && $2 != nil }
        output = Output(isValidateComplete: isValidateComplete)

        let unitCollection = Observable.combineLatest(heightUnitRow.compactMap { $0 },
                                                      weightUnitRow.compactMap { $0 },
                                                      energyUnitRow.compactMap { $0 })
            .map { UnitCollection(heightUnitRow: $0, weightUnitRow: $1, energyUnitRow: $2) }

        didTapNextButton.withLatestFrom(unitCollection)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                repository.add(unitCollection: $0)
                coordinator.showFillInformation()
            })
            .disposed(by: disposeBag)
    }
}

extension SelectUnitViewModel {
    struct Input: SelectUnitViewModelInput {
        let heightUnitRow: AnyObserver<Int?>
        let weightUnitRow: AnyObserver<Int?>
        let energyUnitRow: AnyObserver<Int?>
        let didTapNextButton: AnyObserver<Void>
    }

    struct Output: SelectUnitViewModelOutput {
        let isValidateComplete: Observable<Bool>
    }
}
