//
//  RxYPImagePicker.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import YPImagePicker

final class RxYPImagePicker: YPImagePicker {

    var didCancel: PublishRelay<Bool>
    var pickedImage: PublishRelay<UIImage?>

    init(config: YPImagePickerConfiguration) {
        didCancel = PublishRelay<Bool>()
        pickedImage = PublishRelay<UIImage?>()
        super.init(configuration: config)

        didFinishPicking {[weak self] items, cancel in
            guard let self = self else { return }
            if let photo = items.singlePhoto {
                self.pickedImage.accept(photo.originalImage)
            }
            self.didCancel.accept(cancel)
            self.dismiss(animated: true, completion: nil)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required init(configuration: YPImagePickerConfiguration) {
        fatalError("init(configuration:) has not been implemented")
    }
}

extension Reactive where Base: RxYPImagePicker {

    static func create(_ parent: UIViewController?) -> Observable<RxYPImagePicker> {
        return Observable.create { [weak parent] observer in
            var config = YPImagePickerConfiguration()
            config.albumName = "Duiet"
            config.screens = [.photo, .library]
            config.showsPhotoFilters = false
            let picker = RxYPImagePicker(config: config)
            let dissmissDisposable = picker
                .didCancel
                .subscribe(onNext: { [weak picker] _ in
                    guard let picker = picker else { return }
                    picker.dismiss(animated: true, completion: nil)
                })

            guard let parent = parent else {
                observer.on(.completed)
                return Disposables.create()
            }

            parent.present(picker, animated: true, completion: nil)
            observer.on(.next(picker))

            return Disposables.create([dissmissDisposable])
        }
    }
}
