//
//  MonthService.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift

protocol MonthServiceProtocol {
    func findAll() -> Observable<[MonthEntity]>
}

final class MonthService: MonthServiceProtocol {
    static let shared = MonthService()
    private let repository: CoreDataRepositoryProtocol

    private init(repository: CoreDataRepositoryProtocol = CoreDataRepository.shared) {
        self.repository = repository
    }

    func findAll() -> Observable<[MonthEntity]> {
        repository.find(type: Month.self,
                        predicate: nil,
                        sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)])
    }
}
