//
//  ManageDataViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol ManageDataViewModelInput {
    var itemDidSelect: AnyObserver<ManageDataType> { get }
    var importStart: AnyObserver<Void> { get }
    var exportStart: AnyObserver<Void> { get }
}

protocol ManageDataViewModelOutput {}

protocol ManageDataViewModelState {}

protocol ManageDataViewModelProtocol {
    var input: ManageDataViewModelInput { get }
    var output: ManageDataViewModelOutput { get }
    var state: ManageDataViewModelState { get }
}

final class ManageDataViewModel: ManageDataViewModelProtocol, ManageDataViewModelState {
    let input: ManageDataViewModelInput
    let output: ManageDataViewModelOutput
    var state: ManageDataViewModelState { self }

    private let disposeBag = DisposeBag()

    init(manageDataModel: ManageDataModelProtocol = ManageDataModel.default) {
        let itemDidSelect = PublishRelay<ManageDataType>()
        let importStart = PublishRelay<Void>()
        let exportStart = PublishRelay<Void>()
        input = Input(itemDidSelect: itemDidSelect.asObserver(),
                      importStart: importStart.asObserver(),
                      exportStart: exportStart.asObserver())

        let importDidSelect = itemDidSelect
            .filter { $0 == .import }
            .map { _ in }

        let exportDidSelect = itemDidSelect
            .filter { $0 == .export }
            .map { _ in }

        output = Output()
    }
}

extension ManageDataViewModel {
    struct Input: ManageDataViewModelInput {
        var itemDidSelect: AnyObserver<ManageDataType>
        var importStart: AnyObserver<Void>
        var exportStart: AnyObserver<Void>
    }

    struct Output: ManageDataViewModelOutput {}
}
