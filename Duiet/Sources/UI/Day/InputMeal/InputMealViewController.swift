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

final class InputMealViewController: BaseTableViewController, KeyboardFrameTrackkable {

    let headerView: UIImageView

    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            let image = R.image.cancel()?.withRenderingMode(.alwaysTemplate)
            cancelButton.setImage(image, for: .normal)
            cancelButton.imageView?.tintColor = .gray
        }
    }

    let viewModel: InputMealViewModel
    let keyboardTrackViewModel: KeyboardTrackViewModel
    let dataSource: InputMealDataSource

    init(viewModel: InputMealViewModel) {
        self.viewModel = viewModel
        self.keyboardTrackViewModel = KeyboardTrackViewModel()
        self.dataSource = InputMealDataSource(viewModel: viewModel,
                                              keyboardTrackViewModel: keyboardTrackViewModel)
        self.headerView = UIImageView(image: viewModel.mealImage)
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

        cancelButton.rx.tap
            .bind(to: viewModel.input.dismiss)
            .disposed(by: disposeBag)

        keyboardTrackViewModel.output.difference
            .bind(to: updateScroll)
            .disposed(by: disposeBag)

        viewModel.output.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)
    }

    deinit {
        print("🧹🧹🧹 Input Meal View controller parge 🧹🧹🧹")
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

    private var reloadData: Binder<Void> {
        return Binder(self) { me, _ in
            me.tableView.beginUpdates()
            me.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            me.tableView.endUpdates()
        }
    }
}
