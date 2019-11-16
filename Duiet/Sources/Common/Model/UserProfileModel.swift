//
//  UserProfileModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift
import RxCocoa
import RxRealm
import RxRelay
import RxSwift

protocol UserProfileModelInput {}

protocol UserProfileModelOutput {
    var userProfile: Observable<UserProfile> { get }
}

protocol UserProfileModelState {
    var userProfileValue: UserProfile { get }

    func add(userProfile: UserProfile)
}

protocol UserProfileModelProtocol {
    var input: UserProfileModelInput { get }
    var output: UserProfileModelOutput { get }
    var state: UserProfileModelState { get }
}

final class UserProfileModel: UserProfileModelProtocol, UserProfileModelState {
    // MARK: - Singleton
    static let shared = UserProfileModel(repository: CoreDataRepository.shared)

    let input: UserProfileModelInput
    let output: UserProfileModelOutput
    var state: UserProfileModelState { return self }

    // MARK: - State
    var userProfileValue: UserProfile {
        userProfile.value ?? UserProfile(id: UUID(),
                                         age: 0,
                                         biologicalSex: "other",
                                         height: 0,
                                         weight: 0,
                                         activityLevel: "sedentary",
                                         createdAt: Date(),
                                         updatedAt: Date())
    }

    private let userProfile = BehaviorRelay<UserProfile?>(value: nil)
    private let repository: CoreDataRepositoryProtocol
    private let disposeBag = DisposeBag()

    init(repository: CoreDataRepositoryProtocol) {
        self.repository = repository

        input = Input()
        output = Output(userProfile: userProfile.compactMap { $0 })

        repository.find(UserProfile.self, predicate: nil, sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)])
            .compactMap { $0.first }
            .bind(to: userProfile)
            .disposed(by: disposeBag)
    }

    func add(userProfile: UserProfile) {
        repository.update(entity: userProfile)
    }
}

extension UserProfileModel {
    struct Input: UserProfileModelInput {}

    struct Output: UserProfileModelOutput {
        let userProfile: Observable<UserProfile>
    }
}
