//
//  SelectUnitViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/14.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation

protocol SelectUnitViewModelInput {}

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

    init() {
        input = Input()
        output = Output()
    }
}

extension SelectUnitViewModel {
    struct Input: SelectUnitViewModelInput {}

    struct Output: SelectUnitViewModelOutput {}
}
