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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var didTapNextButton: Binder<Void> {
        return Binder(self) { me, _  in
            
        }
    }
}
