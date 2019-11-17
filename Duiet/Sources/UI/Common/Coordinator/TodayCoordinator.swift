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
        let model = TodayModel()
        let vm = TodayViewModel(coordinator: self,
                                todayModel: model)
        viewController = TopTodayViewController(viewModel: vm,
                                                segmentedViewModel: segmentedViewModel)
    }

    func start() {
        navigator.pushViewController(viewController, animated: false)
    }

    func showDetail(image: UIImage?, mealEntity: MealEntity, dayEntity: DayEntity) {
        let model = InputMealModel(mealEntity: mealEntity, dayEntity: dayEntity)
        let viewModel = InputMealViewModel(coordinator: self, inputMealModel: model, foodImage: image)
        let vc = InputMealViewController(viewModel: viewModel, image: image)
        viewController.present(vc, animated: true, completion: nil)
    }

    func showEdit(mealCard: MealCardViewCell, mealEntity: MealEntity, dayEntity: DayEntity) {
        let model = InputMealModel(mealEntity: mealEntity, dayEntity: dayEntity)
        let viewModel = InputMealViewModel(coordinator: self,
                                           inputMealModel: model,
                                           foodImage: mealCard.imageView.image)
        let vc = InputMealViewController(viewModel: viewModel,
                                         image: mealCard.imageView.image)
        navigator.present(vc, animated: true, completion: nil)
    }

    func showDetailDay(day: Day) {
        let model = TodayModel(date: day.createdAt)
        let vm = TodayViewModel(coordinator: self,
                                todayModel: model)
        let vc = TodayViewController(viewModel: vm)
        navigator.pushViewController(vc, animated: false)
    }

    func dismiss() {
        navigator.dismiss(animated: true, completion: nil)
    }
}
