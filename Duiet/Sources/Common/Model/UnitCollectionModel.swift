//
//  UnitCollectionModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/14.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol UnitCollectionModelInput {}

protocol UnitCollectionModelOutput {
    var unitCollection: Observable<UnitCollection> { get }
}

protocol UnitCollectionModelState {
    var unitCollectionValue: UnitCollection { get }

    func add(unitCollection: UnitCollection)
}

protocol UnitCollectionModelProtocol {
    var input: UnitCollectionModelInput { get }
    var output: UnitCollectionModelOutput { get }
    var state: UnitCollectionModelState { get }
}

final class UnitCollectionModel: UnitCollectionModelProtocol, UnitCollectionModelState {
    // MARK: - Singleton
    static let shared = UnitCollectionModel(repository: CoreDataRepository.shared)

    let input: UnitCollectionModelInput
    let output: UnitCollectionModelOutput
    var state: UnitCollectionModelState { return self }

    // MARK: - State
    var unitCollectionValue: UnitCollection {
        unitCollection.value ?? UnitCollection(id: UUID(),
                                         heightUnitRow: 0,
                                         weightUnitRow: 0,
                                         energyUnitRow: 0,
                                         createdAt: Date(),
                                         updatedAt: Date())
    }

    private let unitCollection = BehaviorRelay<UnitCollection?>(value: nil)
    private let repository: CoreDataRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: CoreDataRepositoryProtocol) {
        self.repository = repository

        input = Input()
        output = Output(unitCollection: unitCollection.compactMap { $0 })

        repository.find(UnitCollection.self, predicate: nil, sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)])
            .compactMap { $0.first }
            .bind(to: unitCollection)
            .disposed(by: disposeBag)
    }

    func add(unitCollection: UnitCollection) {
        repository.update(entity: unitCollection)
    }
}

extension UnitCollectionModel {
    struct Input: UnitCollectionModelInput {}

    struct Output: UnitCollectionModelOutput {
        var unitCollection: Observable<UnitCollection>
    }
}
