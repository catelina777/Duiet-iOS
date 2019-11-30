//
//  CoreDataRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/10.
//  Copyright © 2019 duiet. All rights reserved.
//

import CloudKit
import CoreData
import Foundation
import RxCoreData
import RxSwift

protocol CoreDataRepositoryProtocol {
    func create<E: Persistable>(_ type: E.Type) -> E.T
    func find<E: Persistable>(_ type: E.Type,
                              predicate: NSPredicate?,
                              sortDescriptors: [NSSortDescriptor]?) -> Observable<[E]>
    func find<E: Persistable>(type: E.Type,
                              predicate: NSPredicate?,
                              sortDescriptors: [NSSortDescriptor]?) -> Observable<[E.T]>
    func findAll<E: Persistable>(type: E.Type,
                                 sortDescriptors: [NSSortDescriptor]) -> [E.T]
    func get<E: Persistable>(_ type: E.Type, key: String, value: String) -> E.T?
    func get<E: Persistable>(type: E.Type, key: String, value: String) -> Observable<E.T>
    func update<E: Persistable>(_ entity: E)
    func update<E: NSManagedObject>(_ entity: E)
    func delete<E: NSManagedObject>(_ entity: E)
}

class CoreDataRepository: CoreDataRepositoryProtocol {
    static let shared = CoreDataRepository()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Schemes")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                Logger.shared.error(error)
            }
            Logger.shared.info(storeDescription)
        })
        return container
    }()

    private init() {}

    func create<E: Persistable>(_ type: E.Type = E.self) -> E.T {
        NSEntityDescription.insertNewObject(forEntityName: E.entityName, into: persistentContainer.viewContext) as! E.T
    }

    func find<E>(type: E.Type,
                 predicate: NSPredicate? = nil,
                 sortDescriptors: [NSSortDescriptor]? = nil) -> Observable<[E.T]> where E: Persistable {
        let fetchRequest = buildFetchRequest(type: type,
                                             predicate: predicate,
                                             sortDescriptors: sortDescriptors)
        return persistentContainer.viewContext.rx.entities(fetchRequest: fetchRequest)
    }

    func find<E>(_ type: E.Type,
                 predicate: NSPredicate? = nil,
                 sortDescriptors: [NSSortDescriptor]? = nil) -> Observable<[E]> where E: Persistable {
        persistentContainer.viewContext.rx.entities(type, predicate: predicate, sortDescriptors: sortDescriptors)
    }

    func findAll<E>(type: E.Type,
                    sortDescriptors: [NSSortDescriptor]) -> [E.T] where E: Persistable {
        let fetchRequest = buildFetchRequest(type: type,
                                             sortDescriptors: sortDescriptors)
        do {
            let entities = try persistentContainer.viewContext.fetch(fetchRequest)
            return entities
        } catch let error {
            Logger.shared.error(error)
            return []
        }
    }

    func get<E>(_ type: E.Type, key: String, value: String) -> E.T? where E: Persistable {
        let predicate = NSPredicate(format: "\(key) == %@", argumentArray: [value])
        let fetchRequest = buildFetchRequest(type: type, predicate: predicate, sortDescriptors: nil)
        do {
            let result = try persistentContainer.viewContext.execute(fetchRequest) as? NSAsynchronousFetchResult<E.T>
            return result?.finalResult?.first
        } catch let error {
            Logger.shared.error(error)
            return nil
        }
    }

    func get<E>(type: E.Type, key: String, value: String) -> Observable<E.T> where E: Persistable {
        let predicate = NSPredicate(format: "\(key) == %@", argumentArray: [value])
        let fetchRequest = buildFetchRequest(type: type, predicate: predicate, sortDescriptors: nil)
        return persistentContainer.viewContext.rx.entities(fetchRequest: fetchRequest)
            .compactMap { $0.first }
    }

    private func buildFetchRequest<E>(type: E.Type,
                                      predicate: NSPredicate? = nil,
                                      sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<E.T> where E: Persistable {
        let fetchRequest: NSFetchRequest<E.T> = NSFetchRequest(entityName: E.entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors ?? [NSSortDescriptor(key: E.primaryAttributeName, ascending: true)]
        return fetchRequest
    }

    func update<E: Persistable>(_ entity: E) {
        do {
            try persistentContainer.viewContext.rx.update(entity)
        } catch let error {
            Logger.shared.error(error)
        }
    }

    func update<E>(_ entity: E) where E: NSManagedObject {
        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            Logger.shared.error(error)
        }
    }

    func delete<E: Persistable>(_ entity: E) {
        do {
            try persistentContainer.viewContext.rx.delete(entity)
        } catch let error {
            Logger.shared.error(error)
        }
    }

    func delete<E>(_ entity: E) where E: NSManagedObject {
        persistentContainer.viewContext.delete(entity)
    }
}
