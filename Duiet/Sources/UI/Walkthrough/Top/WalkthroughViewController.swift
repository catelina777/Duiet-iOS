//
//  WalkthroughViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/26.
//  Copyright © 2019 duiet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class WalkthroughViewController: BaseViewController {
    @IBOutlet weak var firstImageView: UIImageView! {
        didSet {
            firstImageView.image = R.image.accessibility()?.withRenderingMode(.alwaysTemplate)
        }
    }
    @IBOutlet weak var secondImageView: UIImageView! {
        didSet {
            secondImageView.image = R.image.image()?.withRenderingMode(.alwaysTemplate)
        }
    }
    @IBOutlet weak var thirdImageView: UIImageView! {
        didSet {
            thirdImageView.image = R.image.edit()?.withRenderingMode(.alwaysTemplate)
        }
    }
    @IBOutlet weak var fourthImageView: UIImageView! {
        didSet {
            fourthImageView.image = R.image.thumb_up()?.withRenderingMode(.alwaysTemplate)
        }
    }

    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 10
        }
    }

    private let viewModel: WalkthroughViewModelProtocol

    init(viewModel: WalkthroughViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: WalkthroughViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.rx.tap
            .bind(to: viewModel.input.didTapNextButton)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
