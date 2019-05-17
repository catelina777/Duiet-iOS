//
//  KeyboardFrameTrackkable.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol KeyboardFrameTrackkable {
    var keyboardTrackViewModel: KeyboardTrackViewModel { get }
    var updateScroll: Binder<CGFloat> { get }
}

extension KeyboardFrameTrackkable where Self: BaseTableViewController {

    var updateScroll: Binder<CGFloat> {
        return Binder(self) { me, difference in
            let adaptedDifference = me.tableView.contentOffset.y + difference
            let movePoint = CGPoint(x: 0, y: adaptedDifference)
            me.tableView.setContentOffset(movePoint, animated: true)
        }
    }
}
