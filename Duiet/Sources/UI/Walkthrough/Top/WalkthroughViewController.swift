//
//  WalkthroughViewController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/04/26.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WalkthroughViewController: UIViewController {

    @IBOutlet weak var firstImageView: UIImageView! {
        didSet {
            firstImageView.image = R.image.accessibility()?.withRenderingMode(.alwaysTemplate)
            firstImageView.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }
    @IBOutlet weak var secondImageView: UIImageView! {
        didSet {
            secondImageView.image = R.image.image()?.withRenderingMode(.alwaysTemplate)
            firstImageView.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }
    @IBOutlet weak var thirdImageView: UIImageView! {
        didSet {
            thirdImageView.image = R.image.edit()?.withRenderingMode(.alwaysTemplate)
            thirdImageView.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }
    @IBOutlet weak var fourthImageView: UIImageView! {
        didSet {
            fourthImageView.image = R.image.thumb_up()?.withRenderingMode(.alwaysTemplate)
            fourthImageView.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }

    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = 10
        }
    }

    private let viewModel: WalkthroughViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: WalkthroughViewModel) {
        self.viewModel = viewModel
        super.init(nibName: WalkthroughViewController.className, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.rx.tap
            .bind(to: viewModel.input.pushFillInformation)
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
