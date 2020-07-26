//
//  PhotoRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/05/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import Photos
import RxCocoa
import RxSwift
import UIKit

protocol PhotoRepositoryProtocol {
    func save(image: UIImage) -> Observable<String>
    func fetch(with localIdentifier: String) -> Observable<UIImage>
}

final class PhotoRepository: PhotoRepositoryProtocol {
    static let shared = PhotoRepository()

    private init() {}

    func save(image: UIImage) -> Observable<String> {
        Observable<String>.create { observer in
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

    func fetch(with localIdentifier: String) -> Observable<UIImage> {
        Observable<UIImage>.create { observer in
            let results = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
            guard let asset = results.firstObject else {
                return Disposables.create()
            }

            let targetSize = CGSize(width: asset.pixelWidth / 2, height: asset.pixelHeight / 2)
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: targetSize,
                                                  contentMode: .default,
                                                  options: nil) { image, _ in
                if let image = image {
                    observer.on(.next(image))
                }
            }
            return Disposables.create()
        }
    }
}
