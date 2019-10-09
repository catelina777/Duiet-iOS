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

final class WalkthroughViewController: BaseViewController {
    @IBOutlet private weak var firstImageView: UIImageView! {
        didSet {
            firstImageView.image = R.image.accessibility()?.withRenderingMode(.alwaysTemplate)
        }
    }
    @IBOutlet private weak var secondImageView: UIImageView! {
        didSet {
            secondImageView.image = R.image.image()?.withRenderingMode(.alwaysTemplate)
        }
    }
    @IBOutlet private weak var thirdImageView: UIImageView! {
        didSet {
            thirdImageView.image = R.image.edit()?.withRenderingMode(.alwaysTemplate)
        }
    }
    @IBOutlet private weak var fourthImageView: UIImageView! {
        didSet {
            fourthImageView.image = R.image.thumb_up()?.withRenderingMode(.alwaysTemplate)
        }
    }

    @IBOutlet private weak var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 10
            nextButton.setTitle(R.string.localizable.nextButton(), for: .normal)
        }
    }

    @IBOutlet private weak var topTitleLabel: UILabel! {
        didSet {
            topTitleLabel.text = R.string.localizable.topTitle()
        }
    }

    @IBOutlet private weak var row1TitleLabel: UILabel! {
        didSet {
            row1TitleLabel.text = R.string.localizable.calculate()
        }
    }

    @IBOutlet private weak var row2TitleLabel: UILabel! {
        didSet {
            row2TitleLabel.text = R.string.localizable.getPhotoTitle()
        }
    }

    @IBOutlet private weak var row3TitleLabel: UILabel! {
        didSet {
            row3TitleLabel.text = R.string.localizable.recordCaloriesTitle()
        }
    }

    @IBOutlet private weak var row4TitleLabel: UILabel! {
        didSet {
            row4TitleLabel.text = R.string.localizable.controlWeightTitle()
        }
    }

    @IBOutlet private weak var row1TextView: UITextView! {
        didSet {
            row1TextView.text = R.string.localizable.calculateContent()
        }
    }

    @IBOutlet private weak var row2TextView: UITextView! {
        didSet {
            row2TextView.text = R.string.localizable.getPhotoContent()
        }
    }

    @IBOutlet private weak var row3TextView: UITextView! {
        didSet {
            row3TextView.text = R.string.localizable.recordCaloriesContent()
        }
    }

    @IBOutlet private weak var row4TextView: UITextView! {
        didSet {
            row4TextView.text = R.string.localizable.controlWeightContent()
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
