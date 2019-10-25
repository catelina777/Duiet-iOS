//
//  HistoriesViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/22.
//  Copyright © 2019 duiet. All rights reserved.
//

import FloatingSegmentedControl
import UIKit

final class HistoriesViewController: UIViewController {
    @IBOutlet private weak var segmentedControl: FloatingSegmentedControl!

    private let viewModel: HistoriesViewModelProtocol

    init(viewModel: HistoriesViewModelProtocol,
         viewControllers: [UIViewController]) {
        self.viewModel = viewModel
        super.init(nibName: HistoriesViewController.className, bundle: nil)

        viewControllers.forEach {
            addChild($0)
            view.addSubview($0.view)
            $0.didMove(toParent: self)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSegmentedControl()
    }

    func configureSegmentedControl() {
        segmentedControl.setSegments(with: [
            "Today", "Days", "Months"
        ])
        segmentedControl.addTarget(self, action: #selector(didTapSegmentedControl(_:)))
        segmentedControl.isAnimateFocusMoving = true
    }

    @objc
    func didTapSegmentedControl(_ sender: FloatingSegmentedControl) {
        viewModel.input.selectedIndex.on(.next(sender.focusedIndex))
    }
}
