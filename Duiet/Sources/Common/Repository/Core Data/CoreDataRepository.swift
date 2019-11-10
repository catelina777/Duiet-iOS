//
//  CoreDataRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/10.
//  Copyright © 2019 duiet. All rights reserved.
//

import CoreData
import Foundation
import RxCoreData
import RxSwift

protocol CoreDataRepositoryProtocol {
    func find<E: Persistable>(_ type: E.Type,
                              predicate: NSPredicate?,
                              sortDescriptors: [NSSortDescriptor]?) -> Observable<[E]>
    func find<E: Persistable>(type: E.Type,
                              predicate: NSPredicate?,
                              sortDescriptors: [NSSortDescriptor]?) -> Observable<[E.T]>
    func update<E: Persistable>(entity: E)
    func delete<E: Persistable>(entity: E)
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

    private func buildFetchRequest<E>(type: E.Type,
                                      predicate: NSPredicate? = nil,
                                      sortDescriptors: [NSSortDescriptor]? = nil) -> NSFetchRequest<E.T> where E: Persistable {
        let fetchRequest: NSFetchRequest<E.T> = NSFetchRequest(entityName: E.entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors ?? [NSSortDescriptor(key: E.primaryAttributeName, ascending: true)]
        return fetchRequest
    }

    func update<E: Persistable>(entity: E) {
        do {
            try persistentContainer.viewContext.rx.update(entity)
        } catch let error {
            Logger.shared.error(error)
        }
    }

    func delete<E: Persistable>(entity: E) {
        do {
            try persistentContainer.viewContext.rx.delete(entity)
        } catch let error {
            Logger.shared.error(error)
        }
    }
}
