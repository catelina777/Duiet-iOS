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
    static let shared = UnitCollectionModel(repository: UnitCollectionRepository.shared)

    let input: UnitCollectionModelInput
    let output: UnitCollectionModelOutput
    var state: UnitCollectionModelState { return self }

    // MARK: - State
    var unitCollectionValue: UnitCollection {
        unitCollection.value
    }

    private let unitCollection: BehaviorRelay<UnitCollection>
    private let repository: UnitCollectionRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: UnitCollectionRepositoryProtocol) {
        self.repository = repository
        unitCollection = BehaviorRelay<UnitCollection>(value: repository.get())

        input = Input()
        output = Output(unitCollection: unitCollection.asObservable())
    }

    func add(unitCollection: UnitCollection) {
        repository.add(unitCollection: unitCollection)
    }
}

extension UnitCollectionModel {
    struct Input: UnitCollectionModelInput {}

    struct Output: UnitCollectionModelOutput {
        var unitCollection: Observable<UnitCollection>
    }
}
