//
//  HistoriesViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/10/22.
//  Copyright © 2019 duiet. All rights reserved.
//

import FloatingSegmentedControl
import RxCocoa
import RxSwift
import UIKit

final class HistoriesViewController: UIViewController {
    @IBOutlet private weak var segmentedControl: FloatingSegmentedControl!
    @IBOutlet private weak var todayView: UIView!
    @IBOutlet private weak var daysView: UIView!
    @IBOutlet private weak var monthsView: UIView!
    private let navigationControllers: [UIViewController]
    private var views: [UIView]! // To make it easy to handle childViews

    private let viewModel: HistoriesViewModelProtocol
    private let disposeBag = DisposeBag()

    init(viewModel: HistoriesViewModelProtocol,
         navigationControllers: [UIViewController]) {
        self.viewModel = viewModel
        self.navigationControllers = navigationControllers
        super.init(nibName: HistoriesViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        configureSegmentedControl()
        bindSegmentedControl()
    }

    override func viewWillLayoutSubviews() {
        configureChildViews()
    }

    private func configureChildViews() {
        views = [todayView, daysView, monthsView]
        navigationControllers.enumerated().forEach { index, viewController in
            views[index].layoutIfNeeded()
            let frame = views[index].frame
            viewController.view.frame = frame
            views[index].addSubview(viewController.view)
            addChild(viewController)
        }
    }

    private func configureSegmentedControl() {
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

    private func bindSegmentedControl() {
        viewModel.output.selectedIndex
            .bind(to: switchTab)
            .disposed(by: disposeBag)
    }

    var switchTab: Binder<Int> {
        Binder<Int>(self) { me, index in
            guard index < 3 else { return }
            me.views
                .enumerated()
                .forEach { $0.element.isHidden = $0.offset == index ? false : true }
        }
    }
}
