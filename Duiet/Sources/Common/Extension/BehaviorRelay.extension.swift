//
//  BehaviorRelay.extension.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/19.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxSwift

extension BehaviorRelay {
    func asObserver() -> AnyObserver<E> {
        return AnyObserver { $0.element.map(self.accept) }
    }
}
