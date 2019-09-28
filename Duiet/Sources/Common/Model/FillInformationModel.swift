//
//  FillInformationModel.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/09/28.
//  Copyright © 2019 duiet. All rights reserved.
//

import Foundation
import HealthKit
import RxCocoa
import RxSwift

protocol FillInformationModelInput {
    var height: AnyObserver<Double?> { get }
    var weight: AnyObserver<Double?> { get }
}

protocol FillInformationModelOutput {
    var basalMetabolicRate: Observable<Double> { get }
    var totalDailyEnergyExpenditure: Observable<Double> { get }
    var isValidate: Observable<Bool> { get }
}

protocol FillInformationModelProtocol {
    var input: FillInformationModelInput { get }
    var output: FillInformationModelOutput { get }
}

final class FillInformationModel: FillInformationModelProtocol {
    let input: FillInformationModelInput
    let output: FillInformationModelOutput

    private let disposeBag = DisposeBag()

    init(healthKitRepository: HealthKitRepositoryProtocol = HealthKitRepository.shared) {
        let biologicalSex = PublishRelay<HKBiologicalSex?>()
        let age = PublishRelay<Int?>()
        let height = PublishRelay<Double?>()
        let weight = PublishRelay<Double?>()
        let activityLevel = PublishRelay<ActivityLevelType>()

        input = Input(height: height.asObserver(),
                      weight: weight.asObserver())

        // MARK: - Transform input
        let userInfo = Observable.combineLatest(biologicalSex, age, height, weight, activityLevel)
            .map { UserInfo(biologicalSex: $0, age: $1, height: $2, weight: $3, activityLevel: $4) }
            .share()

        let basalMetabolicRate = userInfo
            .map { $0.BMR }

        let totalDailyEnergyExpenditure = userInfo
            .map { $0.TDEE }

        let isValidate = activityLevel
            .map { $0 == .none ? false : true }

        output = Output(basalMetabolicRate: basalMetabolicRate,
                        totalDailyEnergyExpenditure: totalDailyEnergyExpenditure,
                        isValidate: isValidate)

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
    }
}

extension FillInformationModel {
    struct Input: FillInformationModelInput {
        let height: AnyObserver<Double?>
        let weight: AnyObserver<Double?>
    }

    struct Output: FillInformationModelOutput {
        let basalMetabolicRate: Observable<Double>
        let totalDailyEnergyExpenditure: Observable<Double>
        let isValidate: Observable<Bool>
    }
}
