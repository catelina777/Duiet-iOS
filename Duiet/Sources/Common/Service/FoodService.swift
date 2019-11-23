//
//  FoodService.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/17.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift

protocol FoodServiceProtocol {
    func findAll() -> Observable<[FoodEntity]>
    func find(by name: String) -> Observable<[FoodEntity]>
    func update(_ foodEntity: FoodEntity)
    func delete(_ foodEntity: FoodEntity)
}

final class FoodService: FoodServiceProtocol {
    static let shared = FoodService()
    private let repository: CoreDataRepositoryProtocol

    private init(repository: CoreDataRepositoryProtocol = CoreDataRepository.shared) {
        self.repository = repository
    }

    func findAll() -> Observable<[FoodEntity]> {
        repository.find(type: Food.self,
                        predicate: NSPredicate(format: "name != %@", argumentArray: [""]),
                        sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)])
    }

    func find(by name: String) -> Observable<[FoodEntity]> {
        repository.find(type: Food.self,
                        predicate: NSPredicate(format: "name CONTAINS[c] %@", argumentArray: [name]),
                        sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)])
    }

    func update(_ foodEntity: FoodEntity) {
        repository.update(foodEntity)
    }

    func delete(_ foodEntity: FoodEntity) {
        repository.delete(foodEntity)
    }
}
