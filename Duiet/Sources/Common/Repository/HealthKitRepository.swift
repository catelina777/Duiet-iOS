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
    /// Request permission to save and read the specified type
    /// - Parameter writeTypes: Request write types
    /// - Parameter readTypes: Request read types
    func requestPermission(writeTypes: [HealthType], readTypes: [HealthType]) -> Single<Bool>

    /// Check permission to save and read specified type
    /// - Parameter writeTypes: Check write types
    /// - Parameter readTypes: Check read types
    func isAuth(writeTypes: [HealthType], readTypes: [HealthType]) -> Single<Bool>

    /// Get Health data
    /// - Parameter sampleType: Want to get health type
    /// - Parameter unit: Health type unit
    func get(sampleType: HKSampleType, unit: HKUnit) -> Single<Double>

    /// Get biologicalSex
    func getBiologicalSex() -> Single<HKBiologicalSexObject>

    /// Get BirthOfDate
    func getBirthOfDate() -> Single<DateComponents>

    /// Add Health data
    /// - Parameter hkObject: Add object
    func add(hkObject: HKObject) -> Single<Bool>
}

/// Repository to operate HealthKit
final class HealthKitRepository: HealthKitRepositoryProtocol {
    static let shared = HealthKitRepository()
    private let store = HKHealthStore()

    func requestPermission(writeTypes: [HealthType], readTypes: [HealthType]) -> Single<Bool> {
        Single<Bool>.create { [weak self] observer in
            guard let me = self else {
                return Disposables.create()
            }
            let writeSet = Set(writeTypes.map { $0.quantity! })
            let readSet = Set(readTypes.map { $0.object })
            me.store.requestAuthorization(toShare: writeSet, read: readSet) { success, error in
                observer(.success(success))
                if let error = error {
                    observer(.error(error))
                }
            }

            return Disposables.create()
        }
    }

    func isAuth(writeTypes: [HealthType], readTypes: [HealthType]) -> Single<Bool> {
        Single<Bool>.create { [weak self] observer in
            guard let me = self else {
                return Disposables.create()
            }
            let writeSet = Set(writeTypes.map { $0.quantity! })
            let readSet = Set(readTypes.map { $0.object })
            me.store.getRequestStatusForAuthorization(toShare: writeSet, read: readSet) { success, error in
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

    func getBiologicalSex() -> Single<HKBiologicalSexObject> {
        Single<HKBiologicalSexObject>.create { [weak self] observer in
            guard let me = self else {
                return Disposables.create()
            }
            do {
                let biologicalSex = try me.store.biologicalSex()
                observer(.success(biologicalSex))
            } catch let error {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    func getBirthOfDate() -> Single<DateComponents> {
        Single<DateComponents>.create { [weak self] observer in
            guard let me = self else {
                return Disposables.create()
            }
            do {
                let birthOfDate = try me.store.dateOfBirthComponents()
                observer(.success(birthOfDate))
            } catch let error {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    func add(hkObject: HKObject) -> Single<Bool> {
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
