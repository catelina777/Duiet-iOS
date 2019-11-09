//
//  InputMealViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/03.
//  Copyright © 2019 Duiet. All rights reserved.
//

import RxCocoa
import RxGesture
import RxSwift
import UIKit

final class InputMealViewController: BaseTableViewController, KeyboardFrameTrackkable {
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            let image = R.image.cancel()?.withRenderingMode(.alwaysTemplate)
            cancelButton.setImage(image, for: .normal)
            cancelButton.imageView?.tintColor = .gray
        }
    }

    let viewModel: InputMealViewModelProtocol
    let keyboardTrackViewModel: KeyboardTrackViewModel
    let dataSource: InputMealDataSource

    init(viewModel: InputMealViewModelProtocol,
         image: UIImage?) {
        self.viewModel = viewModel
        keyboardTrackViewModel = KeyboardTrackViewModel()
        dataSource = InputMealDataSource(viewModel: viewModel,
                                         keyboardTrackViewModel: keyboardTrackViewModel)
        super.init(nibName: InputMealViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.configure(with: tableView)

        bindCancelButton()
        bindKeyboardDifference()
        bindReloadData()
    }

    // MARK: - Processing to make viewWillAppear of the original screen called when returning from this screen
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingViewController?.endAppearanceTransition()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }

    deinit {
        Logger.shared.info("🧹memory released🧹")
    }
}

extension InputMealViewController {
    private func bindCancelButton() {
        cancelButton.rx.tap
            .bind(to: viewModel.input.dismiss)
            .disposed(by: disposeBag)
    }

    private func bindKeyboardDifference() {
        keyboardTrackViewModel.output.difference
            .bind(to: updateScroll)
            .disposed(by: disposeBag)
    }

    /// Reload to initialize the textfields affter adding the label.
    private func bindReloadData() {
        viewModel.output.reloadData
            .bind(to: reloadData)
            .disposed(by: disposeBag)
    }

    private var reloadData: Binder<Void> {
        Binder<Void>(self) { me, _ in
            me.tableView.reloadData()
        }
    }
}
