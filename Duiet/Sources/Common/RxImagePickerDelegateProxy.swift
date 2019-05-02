//
//  RxImagePickerDelegateProxy.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/24.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class RxImagePickerDelegateProxy: RxNavigationControllerDelegateProxy, UIImagePickerControllerDelegate {

    init(imagePicker: UIImagePickerController) {
        super.init(navigationController: imagePicker)
    }
}
