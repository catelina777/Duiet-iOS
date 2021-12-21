//
//  ManageDataService.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/24.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxCoreData
import RxSwift

protocol ManageDataServiceProtocol {
    func backup() -> Single<Void>
}

final class ManageDataService: ManageDataServiceProtocol {
    private let coreDataRepository: CoreDataRepositoryProtocol

    private init(coreDataRepository: CoreDataRepositoryProtocol = CoreDataRepository.shared) {
        self.coreDataRepository = coreDataRepository
    }

    func backup() -> Single<Void> {
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        let months = coreDataRepository.findAll(type: Month.self, sortDescriptors: [sortDescriptor])
        let monthEntities = months.map { month -> MonthCodable in
            let days = month.days.map { day -> DayCodable in
                let meals = day.meals.map { meal -> MealCodable in
                    let foods = meal.foods.map { food -> FoodCodable in
                        FoodCodable(id: food.id.uuidString,
                                    name: food.name,
                                    calorie: food.calorie,
                                    multiple: food.multiple,
                                    relativeX: food.relativeX,
                                    relativeY: food.relativeY,
                                    createdAt: food.createdAt,
                                    updatedAt: food.updatedAt)
                    }
                    return MealCodable(id: meal.id.uuidString,
                                       imageId: meal.imageId,
                                       createdAt: meal.createdAt,
                                       updatedAt: meal.updatedAt,
                                       foods: foods)
                }
                return DayCodable(id: day.id.uuidString,
                                  date: day.date,
                                  createdAt: day.createdAt,
                                  updatedAt: day.updatedAt,
                                  meals: meals)
            }
            return MonthCodable(id: month.id.uuidString,
                                date: month.date,
                                createdAt: month.createdAt,
                                updatedAt: month.updatedAt,
                                days: days)
        }
        return export(entities: monthEntities, fileName: "v1.json")
    }

    private func export<T: Codable>(entities: [T], fileName: String) -> Single<Void> {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(entities)
            return write(data, fileName: fileName)
        } catch let error {
            return Single<Void>.error(error)
        }
    }

    private func `import`<T: Persistable, D: Decodable>(_ entityType: T.Type,
                                                        fileName: String,
                                                        mapping: ((_ decodedEntities: [D]) -> [T])) -> Single<[T]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            if let data = read(fileName) {
                let decodedEntities = try decoder.decode([D].self, from: data)
                let entities = mapping(decodedEntities)
                return Single<[T]>.just(entities)
            }
            return Single<[T]>.just([])
        } catch let error {
            return Single<[T]>.error(error)
        }
    }

    private func write(_ data: Data, fileName: String) -> Single<Void> {
        Single<Void>.create { singleEvent in
            do {
                if let folderURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
                    if !FileManager.default.fileExists(atPath: folderURL.path, isDirectory: nil) {
                        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                    }

                    let fileURL = folderURL.appendingPathComponent(fileName)
                    if FileManager.default.fileExists(atPath: fileURL.path) {
                        try FileManager.default.removeItem(atPath: fileURL.path)
                    }
                    FileManager.default.createFile(atPath: fileURL.path, contents: data, attributes: nil)
                }
                logger.info("write \(fileName) success")
                singleEvent(.success(()))
            } catch let error {
                singleEvent(.failure(error))
            }
            return Disposables.create()
        }
    }

    private func read(_ fileName: String) -> Data? {
        if let folderURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            if FileManager.default.fileExists(atPath: folderURL.path) {
                let fileURL = folderURL.appendingPathComponent(fileName)
                if let data = FileManager.default.contents(atPath: fileURL.path) {
                    logger.info("read \(fileName) success")
                    return data
                }
            }
        }
        return nil
    }
}
