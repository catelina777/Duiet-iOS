//
//  TodayCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class TodayCoordinator: Coordinator {
    private let navigator: UINavigationController
    private let segmentedViewModel: SegmentedControlViewModel
    private var viewController: TopTodayViewController!

    init(navigator: UINavigationController,
         segmentedViewModel: SegmentedControlViewModel) {
        self.navigator = navigator
        self.segmentedViewModel = segmentedViewModel
        let model = TodayModel(repository: DayRepository.shared)
        let vm = TodayViewModel(coordinator: self,
                                userProfileModel: UserProfileModel.shared,
                                todayModel: model,
                                unitCollectionModel: UnitCollectionModel.shared)
        viewController = TopTodayViewController(viewModel: vm,
                                                segmentedViewModel: segmentedViewModel)
    }

    func start() {
        navigator.pushViewController(viewController, animated: false)
    }

    func showDetail(image: UIImage?, meal: Meal) {
        let model = InputMealModel(repository: DayRepository.shared, meal: meal)
        let viewModel = InputMealViewModel(coordinator: self, model: model, foodImage: image)
        let vc = InputMealViewController(viewModel: viewModel, image: image)
        viewController.present(vc, animated: true, completion: nil)
    }

    func showEdit(mealCard: MealCardViewCell, meal: Meal, row: Int) {
        let model = InputMealModel(repository: DayRepository.shared,
                                   meal: meal)
        let viewModel = InputMealViewModel(coordinator: self,
                                           model: model,
                                           foodImage: mealCard.imageView.image)
        let vc = InputMealViewController(viewModel: viewModel,
                                         image: mealCard.imageView.image)
        navigator.present(vc, animated: true, completion: nil)
    }

    func showDetailDay(day: Day) {
        let model = TodayModel(repository: DayRepository.shared, date: day.createdAt)
        let vm = TodayViewModel(coordinator: self,
                                userProfileModel: UserProfileModel.shared,
                                todayModel: model,
                                unitCollectionModel: UnitCollectionModel.shared)
        let vc = TodayViewController(viewModel: vm)
        navigator.pushViewController(vc, animated: false)
    }

    func dismiss() {
        navigator.dismiss(animated: true, completion: nil)
    }
}
