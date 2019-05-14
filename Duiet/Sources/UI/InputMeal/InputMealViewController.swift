//
//  InputMealViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/03.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class InputMealViewController: UIViewController {

    @IBOutlet private(set) weak var tableView: UITableView!
    let headerView: UIImageView
    let labelCanvasView: UIView

    let viewModel: InputMealViewModel
    let dataSource: InputMealDataSource

    private let disposeBag = DisposeBag()

    init(mealImage: UIImage?) {
        self.viewModel = InputMealViewModel(mealImage: mealImage)
        self.dataSource = InputMealDataSource(viewModel: viewModel)
        self.headerView = UIImageView(image: viewModel.mealImage)
        self.labelCanvasView = UIView()
        super.init(nibName: InputMealViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.configure(with: tableView)

        rx.methodInvoked(#selector(InputMealViewController.viewWillLayoutSubviews))
            .map { _ in }
            .bind(to: configureHeaderView)
            .disposed(by: disposeBag)

        tableView.rx.contentOffset
            .bind(to: updateParallax)
            .disposed(by: disposeBag)

        viewModel.output.difference
            .bind(to: updateScroll)
            .disposed(by: disposeBag)
    }

    private var configureHeaderView: Binder<Void> {
        return Binder(self) { me, _ in
            me.tableView.layoutIfNeeded()
            let multiple: CGFloat = 1
            let width = me.tableView.frame.width
            let height = width / multiple
            me.headerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            me.headerView.clipsToBounds = true
            me.headerView.layer.cornerRadius = 12
            me.view.addSubview(me.headerView)
            me.view.sendSubviewToBack(me.headerView)
        }
    }

    private var updateParallax: Binder<CGPoint> {
        return Binder(self) { me, point in
            let multiple: CGFloat = 1
            let defaultPointY = point.y
            if defaultPointY <= 0 {
                let width = me.tableView.frame.width - defaultPointY
                let height = me.tableView.frame.width / multiple - defaultPointY
                let headerFrame = CGRect(x: defaultPointY / 2,
                                         y: 0,
                                         width: width,
                                         height: height)
                me.headerView.frame = headerFrame
            } else {
                let width = me.tableView.frame.width + defaultPointY
                let height = me.tableView.frame.width / multiple + defaultPointY
                let headerFrame = CGRect(x: -defaultPointY / 2,
                                         y: -defaultPointY * 2,
                                         width: width,
                                         height: height)
                me.headerView.frame = headerFrame
            }
        }
    }

    private var updateScroll: Binder<CGFloat> {
        return Binder(self) { me, difference in
            let adaptedDifference = me.tableView.contentOffset.y + difference
            let movePoint = CGPoint(x: 0, y: adaptedDifference)
            me.tableView.setContentOffset(movePoint, animated: true)
        }
    }
}
