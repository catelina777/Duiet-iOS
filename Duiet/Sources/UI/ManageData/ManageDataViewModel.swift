//
//  ManageDataViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

protocol ManageDataViewModelInput {
}

protocol ManageDataViewModelOutput {
}

protocol ManageDataViewModelState {
}

protocol ManageDataViewModelProtocol {
    var input: ManageDataViewModelInput { get }
    var output: ManageDataViewModelOutput { get }
    var state: ManageDataViewModelState { get }
}

final class ManageDataViewModel: ManageDataViewModelProtocol, ManageDataViewModelState {
    let input: ManageDataViewModelInput
    let output: ManageDataViewModelOutput
    var state: ManageDataViewModelState { self }

    init() {
        input = Input()
        output = Output()
    }
}

extension ManageDataViewModel {
    struct Input: ManageDataViewModelInput {}

    struct Output: ManageDataViewModelOutput {}
}
