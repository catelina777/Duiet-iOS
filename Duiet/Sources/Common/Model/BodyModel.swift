//
//  BodyModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/29.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import HealthKit

protocol BodyModelInput {
    var add: AnyObserver<ActivityLevel> { get }
}

protocol BodyModelOutput {
    var activityLevel: Observable<ActivityLevelType> { get }
    var body: Observable<Body> { get }
}

protocol BodyModelProtocol {
    var input: BodyModelInput { get }
    var output: BodyModelOutput { get }
}

final class BodyModel: BodyModelProtocol {
    let input: BodyModelInput
    let output: BodyModelOutput

    private let disposeBag = DisposeBag()

    init(activityLevelRepository: ActivityLevelRepositoryProtocol = ActivityLevelRepository.shared,
         healthKitRepository: HealthKitRepositoryProtocol = HealthKitRepository.shared) {
        let add = PublishRelay<ActivityLevel>()

        let biologicalSex = PublishRelay<HKBiologicalSex?>()
        let age = PublishRelay<Int?>()
        let height = PublishRelay<Double?>()
        let weight = PublishRelay<Double?>()
        let activityLevel = PublishRelay<ActivityLevelType>()

        input = Input(add: add.asObserver())

        let body = Observable.combineLatest(biologicalSex, age, height, weight, activityLevel)
            .map { Body(biologicalSex: $0, age: $1, height: $2, weight: $3, activityLevel: $4) }
            .share()

        output = Output(activityLevel: activityLevel.asObservable(),
                        body: body)

        // MARK: - Get health data and bind
        healthKitRepository.getBiologicalSex()
            .asObservable()
            .map { $0.biologicalSex }
            .bind(to: biologicalSex)
            .disposed(by: disposeBag)

        healthKitRepository.getBirthOfDate()
            .asObservable()
            .map { Calendar.current.compare($0.date!, to: Date(), toGranularity: .year).rawValue }
            .bind(to: age)
            .disposed(by: disposeBag)

        healthKitRepository.get(sampleType: HealthType.bodyMass.quantity!, unit: .gramUnit(with: .kilo))
            .asObservable()
            .bind(to: height)
            .disposed(by: disposeBag)

        healthKitRepository.get(sampleType: HealthType.height.quantity!, unit: .gramUnit(with: .kilo))
            .asObservable()
            .bind(to: height)
            .disposed(by: disposeBag)

        activityLevelRepository.find()
            .compactMap { $0.first?.row }
            .map { ActivityLevelType.get($0) }
            .bind(to: activityLevel)
            .disposed(by: disposeBag)
    }
}

extension BodyModel {
    struct Input: BodyModelInput {
        let add: AnyObserver<ActivityLevel>
    }
    struct Output: BodyModelOutput {
        let activityLevel: Observable<ActivityLevelType>
        let body: Observable<Body>
    }
}
