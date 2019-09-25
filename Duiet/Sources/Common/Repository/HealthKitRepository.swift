//
//  HealthKitRepository.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/23.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import HealthKit
import RxSwift

protocol HealthKitRepositoryProtocol {
    func isAuth() -> Single<Bool>
    func get(sampleType: HKSampleType, unit: HKUnit) -> Single<Double>
    func update(hkObject: HKObject) -> Single<Bool>
}

final class HealthKitRepository: HealthKitRepositoryProtocol {
    static let shared = HealthKitRepository()
    private let store = HKHealthStore()

    private let bodyMassType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
    private let heightType = HKQuantityType.quantityType(forIdentifier: .height)!

    private  var readTypes: Set<HKQuantityType> {
        Set([ bodyMassType, heightType ])
    }

    private var writeTypes: Set<HKQuantityType> {
        Set([ bodyMassType ])
    }

    func isAuth() -> Single<Bool> {
        Single<Bool>.create { [weak self] observer in
            guard let me = self else {
                return Disposables.create()
            }
            me.store.getRequestStatusForAuthorization(toShare: me.writeTypes, read: me.readTypes) { success, error in
                switch success {
                case .unnecessary:
                    observer(.success(true))

                default:
                    observer(.success(false))
                }
                if let error = error {
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    func get(sampleType: HKSampleType, unit: HKUnit) -> Single<Double> {
        Single<Double>.create { [weak self] observer in
            guard let me = self else {
                return Disposables.create()
            }
            let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(sampleType: sampleType,
                                      predicate: nil,
                                      limit: 1,
                                      sortDescriptors: [sort]) { _, results, error in
                if let result = results?.first as? HKQuantitySample {
                    let weight = result.quantity.doubleValue(for: unit)
                    observer(.success(weight))
                }

                if let error = error {
                    observer(.error(error))
                }
            }

            me.store.execute(query)
            return Disposables.create()
        }
    }

    func update(hkObject: HKObject) -> Single<Bool> {
        Single<Bool>.create { [weak self] observer in
            guard let me = self else {
                return Disposables.create()
            }
            me.store.save(hkObject) { bool, error in
                observer(.success(bool))
                if let error = error {
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
