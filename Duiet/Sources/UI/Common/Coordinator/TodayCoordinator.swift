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
    private let tabViewModel: TopTabBarViewModel
    private var viewController: TopTodayViewController!

    init(navigator: UINavigationController,
         tabViewModel: TopTabBarViewModel) {
        self.navigator = navigator
        self.tabViewModel = tabViewModel
        let model = TodayModel(repository: DayRepository.shared)
        let vm = TodayViewModel(coordinator: self,
                                userInfoModel: UserInfoModel.shared,
                                todayModel: model)
        viewController = TopTodayViewController(viewModel: vm,
                                                tabViewModel: tabViewModel)
    }

    func start() {
        navigator.pushViewController(viewController, animated: false)
    }

    func showDetail(image: UIImage?, meal: Meal) {
        let model = InputMealModel(repository: DayRepository.shared, meal: meal)
        let viewModel = InputMealViewModel(coordinator: self, model: model)
        let vc = InputMealViewController(viewModel: viewModel, image: image)
        viewController.present(vc, animated: true, completion: nil)
    }

    func showEdit(mealCard: MealCardViewCell, meal: Meal, row: Int) {
        let model = InputMealModel(repository: DayRepository.shared,
                                   meal: meal)
        let viewModel = InputMealViewModel(coordinator: self,
                                           model: model)
        let vc = InputMealViewController(viewModel: viewModel,
                                         image: mealCard.imageView.image)
        navigator.present(vc, animated: true, completion: nil)
    }

    func showDetailDay(day: Day) {
        let model = TodayModel(repository: DayRepository.shared, date: day.createdAt)
        let vm = TodayViewModel(coordinator: self,
                                userInfoModel: UserInfoModel.shared,
                                todayModel: model)
        let vc = TodayViewController(viewModel: vm)
        navigator.pushViewController(vc, animated: true)
    }

    func dismiss() {
        navigator.dismiss(animated: true, completion: nil)
    }
}
