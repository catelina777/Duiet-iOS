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
    var heightUnitRow: AnyObserver<Int16?> { get }
    var weightUnitRow: AnyObserver<Int16?> { get }
    var energyUnitRow: AnyObserver<Int16?> { get }
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

    private let didTapNextButton = PublishRelay<Void>()
    private let unitCollection = PublishRelay<UnitCollection>()
    private let disposeBag = DisposeBag()

    init() {
        let heightUnitRow = PublishRelay<Int16?>()
        let weightUnitRow = PublishRelay<Int16?>()
        let energyUnitRow = PublishRelay<Int16?>()
        input = Input(heightUnitRow: heightUnitRow.asObserver(),
                      weightUnitRow: weightUnitRow.asObserver(),
                      energyUnitRow: energyUnitRow.asObserver(),
                      didTapNextButton: didTapNextButton.asObserver())

        let isValidateComplete = Observable.combineLatest(heightUnitRow, weightUnitRow, energyUnitRow)
            .map { $0 != nil && $1 != nil && $2 != nil }
        output = Output(isValidateComplete: isValidateComplete)

        Observable.combineLatest(heightUnitRow.compactMap { $0 },
                                 weightUnitRow.compactMap { $0 },
                                 energyUnitRow.compactMap { $0 })
            .map { UnitCollection(id: UUID(), heightUnitRow: $0, weightUnitRow: $1, energyUnitRow: $2, createdAt: Date(), updatedAt: Date()) }
            .bind(to: unitCollection)
            .disposed(by: disposeBag)
    }

    convenience init(coordinator: OnboardingCoordinator,
                     unitCollectionModel: UnitCollectionModelProtocol = UnitCollectionModel.shared) {
        self.init()

        didTapNextButton.withLatestFrom(unitCollection)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                unitCollectionModel.state.add(unitCollection: $0)
                coordinator.showFillInformation()
            })
            .disposed(by: disposeBag)
    }

    convenience init(coordinator: SettingCoordinator,
                     unitCollectionModel: UnitCollectionModelProtocol = UnitCollectionModel.shared) {
        self.init()

        didTapNextButton.withLatestFrom(unitCollection)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                unitCollectionModel.state.add(unitCollection: $0)
                coordinator.pop()
            })
            .disposed(by: disposeBag)
    }
}

extension SelectUnitViewModel {
    struct Input: SelectUnitViewModelInput {
        let heightUnitRow: AnyObserver<Int16?>
        let weightUnitRow: AnyObserver<Int16?>
        let energyUnitRow: AnyObserver<Int16?>
        let didTapNextButton: AnyObserver<Void>
    }

    struct Output: SelectUnitViewModelOutput {
        let isValidateComplete: Observable<Bool>
    }
}
