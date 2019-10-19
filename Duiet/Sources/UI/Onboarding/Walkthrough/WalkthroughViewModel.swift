//
//  WalkthrouthViewModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/06.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

protocol WalkthroughViewModelInput {
    var didTapNextButton: AnyObserver<Void> { get }
}

protocol WalkthroughViewModelOutput {}

protocol WalkthroughViewModelProtocol {
    var input: WalkthroughViewModelInput { get }
    var output: WalkthroughViewModelOutput { get }
}

final class WalkthroughViewModel: WalkthroughViewModelProtocol {
    let input: WalkthroughViewModelInput
    let output: WalkthroughViewModelOutput

    private let disposeBag = DisposeBag()

    init(coordinator: OnboardingCoordinator) {
        let didTapNextButton = PublishRelay<Void>()
        input = Input(didTapNextButton: didTapNextButton.asObserver())
        output = Output()

        // MARK: - Processing to transitions
        didTapNextButton
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                coordinator.showSelectUnit()
            })
            .disposed(by: disposeBag)
    }
}

extension WalkthroughViewModel {
    struct Input: WalkthroughViewModelInput {
        let didTapNextButton: AnyObserver<Void>
    }

    struct Output: WalkthroughViewModelOutput {}
}
