//
//  BehaviorRelay.extension.swift
//  ToolKits
//
//  Created by Ryuhei Kaminishi on 2019/12/12.
//  Copyright © 2019 catelina777. All rights reserved.
//

import RxRelay
import RxSwift

public extension BehaviorRelay {
    func asObserver() -> AnyObserver<Element> {
        AnyObserver { $0.element.map(self.accept) }
    }
}
