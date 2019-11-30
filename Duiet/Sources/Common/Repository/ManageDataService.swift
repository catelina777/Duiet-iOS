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
    func backup() -> Observable<Void>
    func restore() -> Observable<Void>
}

final class ManageDataService: ManageDataServiceProtocol {
    static let shared = ManageDataService()

    private let coreDataRepository: CoreDataRepositoryProtocol

    private init(coreDataRepository: CoreDataRepositoryProtocol = CoreDataRepository.shared) {
        self.coreDataRepository = coreDataRepository
    }

    func backup() -> Observable<Void> {
        let monthsWillExport = export(Month.self, fileName: "months.json") {
            $0.map { MonthCodable(id: $0.id.uuidString,
                                  date: $0.date,
                                  createdAt: $0.createdAt,
                                  updatedAt: $0.updatedAt,
                                  dayIds: $0.days.map { $0.id.uuidString })
            }
        }
        let daysWillExport = export(Day.self, fileName: "days.json") {
            $0.map { DayCodable(id: $0.id.uuidString,
                                date: $0.date,
                                createdAt: $0.createdAt,
                                updatedAt: $0.updatedAt,
                                monthId: $0.month.id.uuidString,
                                mealIds: $0.meals.map { $0.id.uuidString })
            }
        }
        return Observable.of(monthsWillExport, daysWillExport)
            .concat()
    }

    func restore() -> Observable<Void> {
        let monthsWillLoad = `import`(Month.self, fileName: "months.json") { (months: [MonthCodable]) in
            months.map { Month(codableEntity: $0) }
        }

        return Observable.of(monthsWillLoad)
            .concat()
            .debug()
            .map { _ in }
    }

    private func export<T: Persistable, E: Encodable>(_ entityType: T.Type, fileName: String, mapping: ( (_ entities: [T.T]) -> [E])) -> Single<Void> {
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        let entities = coreDataRepository.findAll(type: entityType,
                                                  sortDescriptors: [sortDescriptor])
        let encodableEntities = mapping(entities)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let data = try encoder.encode(encodableEntities)
            return write(data, fileName: fileName)
        } catch let error {
            return Single.error(error)
        }
    }

    private func `import`<T: Persistable, D: Decodable>(_ entityType: T.Type, fileName: String, mapping: ((_ decodedEntities: [D]) -> [T])) -> Single<[T]> {
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
                if let folderURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Duiet") {
                    if !FileManager.default.fileExists(atPath: folderURL.path, isDirectory: nil) {
                        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                    }

                    let fileURL = folderURL.appendingPathComponent(fileName)
                    if FileManager.default.fileExists(atPath: fileURL.path) {
                        try FileManager.default.removeItem(atPath: fileURL.path)
                    }
                    FileManager.default.createFile(atPath: fileURL.path, contents: data, attributes: nil)
                }
                Logger.shared.info("write \(fileName) success")
                singleEvent(.success(()))
            } catch let error {
                singleEvent(.error(error))
            }
            return Disposables.create()
        }
    }

    private func read(_ fileName: String) -> Data? {
        if let folderURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Duiet") {
            if FileManager.default.fileExists(atPath: folderURL.path) {
                let fileURL = folderURL.appendingPathComponent(fileName)
                if let data = FileManager.default.contents(atPath: fileURL.path) {
                    Logger.shared.info("read \(fileName) success")
                    return data
                }
            }
        }
        return nil
    }
}
