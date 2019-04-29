//
//  TodayViewController.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TodayViewController: UIViewController, NavigationBarCustomizable {

    @IBOutlet private(set) weak var collectionView: UICollectionView!

    let viewModel: TodayViewModel
    let dataSource: TodayViewDataSource

    private let disposeBag = DisposeBag()

    init() {
        self.viewModel = TodayViewModel()
        self.dataSource = TodayViewDataSource(viewModel: viewModel)
        super.init(nibName: TodayViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(with: viewModel.title)
        dataSource.configure(with: collectionView)

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        navigationItem.rightBarButtonItem = addButton

        rx.methodInvoked(#selector(self.viewDidAppear(_:)))
            .map { _ in }
            .bind(to: viewModel.input.viewDidAppear)
            .disposed(by: disposeBag)

        addButton.rx.tap
            .map { self }
            .bind(to: viewModel.input.addButtonTap)
            .disposed(by: disposeBag)

        viewModel.output.pickedImage
            .bind(to: showDetail)
            .disposed(by: disposeBag)

        viewModel.output.showDetail
            .bind(to: showDetail)
            .disposed(by: disposeBag)
    }

    private var showDetail: Binder<UIImage?> {
        return Binder(self) { me, image in
            print("go to detail view!!!")
            let vc = DetailViewController(mealImage: image)
            me.present(vc, animated: true, completion: nil)
            print("gone ✌️✌️✌️")
        }
    }
}
