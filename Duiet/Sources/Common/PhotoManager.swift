//
//  PhotoManager.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

final class PhotoManager {}

extension Reactive where Base: PhotoManager {

    static func save(image: UIImage) -> Observable<String?> {
        return Observable<String?>.create { observer in

            PHPhotoLibrary.shared().performChanges({
                let requestAsset = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let placeholder = requestAsset.placeholderForCreatedAsset
                if let identifier = placeholder?.localIdentifier {
                    observer.on(.next(identifier))
                }
            }, completionHandler: { _, error in

                if let error = error {
                    observer.on(.error(error))
                }
                observer.on(.completed)
            })
            return Disposables.create()
        }
    }

    static func fetchImage(with localIdentifier: String) -> Observable<UIImage?> {
        return Observable<UIImage?>.create { observer in

            let results = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
            guard
                results.count > 0,
                let asset = results.firstObject
            else { return Disposables.create() }

            PHImageManager.default().requestImageData(for: asset, options: nil) { data, _, _, _ in
                guard
                    let data = data,
                    let image = UIImage(data: data)
                else { return }
                observer.on(.next(image))
            }
            return Disposables.create()
        }
    }
}
