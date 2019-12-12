//
//  ManageDataModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/24.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift

protocol ManageDataInput {}

protocol ManageDataOutput {}

protocol ManageDataState {
    func restore() -> Observable<Void>
    func backup() -> Observable<Void>
}

protocol ManageDataModelProtocol {
    var input: ManageDataInput { get }
    var output: ManageDataOutput { get }
    var state: ManageDataState { get }
}

final class ManageDataModel: ManageDataModelProtocol, ManageDataState {
    static let `default` = ManageDataModel()
    let input: ManageDataInput
    let output: ManageDataOutput
    var state: ManageDataState { self }

    private let manageDataService: ManageDataServiceProtocol

    init(manageDataService: ManageDataServiceProtocol = ManageDataService.shared) {
        self.manageDataService = manageDataService
        input = Input()
        output = Output()
    }

    func restore() -> Observable<Void> {
        manageDataService.restore()
    }

    func backup() -> Observable<Void> {
        manageDataService.backup()
    }
}

extension ManageDataModel {
    struct Input: ManageDataInput {}
    struct Output: ManageDataOutput {}
}
