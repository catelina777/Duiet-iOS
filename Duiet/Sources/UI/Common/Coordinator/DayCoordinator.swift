//
//  DayCoordinator.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/07/05.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

final class DayCoordinator: Coordinator {

    private let navigator: UINavigationController
    private let tabViewModel: TopTabBarViewModel
    private var viewController: TopDayViewController!

    init(navigator: UINavigationController,
         tabViewModel: TopTabBarViewModel) {
        self.navigator = navigator
        self.tabViewModel = tabViewModel
        let model = DayModel(repository: DayRepository.shared)
        self.viewController = TopDayViewController(viewModel: .init(coordinator: self,
                                                                    userInfoModel: UserInfoModel.shared,
                                                                    dayModel: model),
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

    func showEdit(mealCard: MealCardViewCell, meal: Meal) {
        let heroID = "\(meal.date.timeIntervalSince1970)"
        mealCard.imageView.hero.id = heroID

        let model = InputMealModel(repository: DayRepository.shared,
                                   meal: meal)
        let viewModel = InputMealViewModel(coordinator: self,
                                           model: model)
        let vc = InputMealViewController(viewModel: viewModel,
                                         image: mealCard.imageView.image)
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .auto
        vc.headerView.hero.id = heroID
        navigator.present(vc, animated: true, completion: nil)
    }

    func showDetailDay(day: Day) {
        let model = DayModel(date: day.createdAt, repository: DayRepository.shared)
        let vc = DayViewController(viewModel: .init(coordinator: self,
                                                    userInfoModel: UserInfoModel.shared,
                                                    dayModel: model))
        navigator.pushViewController(vc, animated: false)
    }

    func dismiss() {
        navigator.dismiss(animated: true, completion: nil)
    }
}
