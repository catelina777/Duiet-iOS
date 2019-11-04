//
//  ContentRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/04.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RealmSwift

protocol ContentRepositoryProtocol {
    func findAll() -> Results<Content>
    func find(name: String) -> Results<Content>
}

final class ContentRepository: ContentRepositoryProtocol {
    static let shared = ContentRepository()

    private let realm: Realm

    private init() {
        realm = try! Realm()
    }

    func findAll() -> Results<Content> {
        realm.objects(Content.self)
            .filter("name != ''")
            .sorted(byKeyPath: "createdAt", ascending: false)
    }

    func find(name: String) -> Results<Content> {
        realm.objects(Content.self)
            .filter("name CONTAINS '\(name)'")
            .sorted(byKeyPath: "createdAt", ascending: false)
    }
}
