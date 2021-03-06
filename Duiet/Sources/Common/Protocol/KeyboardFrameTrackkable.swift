//
//  KeyboardFrameTrackkable.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/05/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

/*  // MARK: - How to prevent wrapped Keyboard on cell's textfield
    1. Adapt this protocol
    2. KeyboardTrackViewModel's property difference bind to updateScroll
    3. Adapt CellFrameTrackkable protocol to the cell you want to track
    4. Setting Cell's property configure(with: KeyboardTrackViewModel)
 */

protocol KeyboardFrameTrackkable {
    var keyboardTrackViewModel: KeyboardTrackViewModel { get }
    var updateScroll: Binder<CGFloat> { get }
}

extension KeyboardFrameTrackkable where Self: BaseTableViewController {
    var updateScroll: Binder<CGFloat> {
        Binder<CGFloat>(self) { me, difference in
            let adaptedDifference = me.tableView.contentOffset.y + difference
            let movePoint = CGPoint(x: 0, y: adaptedDifference)
            me.tableView.setContentOffset(movePoint, animated: true)
        }
    }
}
