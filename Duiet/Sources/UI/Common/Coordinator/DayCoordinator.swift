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
        let repository = DayRepository()
        let model = DayModel(repository: repository)
        self.viewController = TopDayViewController(viewModel: .init(coordinator: self, model: model),
                                                   tabViewModel: tabViewModel)
    }

    func start() {
        navigator.pushViewController(viewController, animated: false)
    }

    func showDetail(image: UIImage?, meal: Meal) {
        let repository = DayRepository()
        let model = InputMealModel(repository: repository, meal: meal)
        let viewModel = NewInputMealViewModel(coordinator: self,
                                              model: model)
        let vc = InputMealViewController(viewModel: viewModel,
                                         image: image)
        viewController.present(vc, animated: true, completion: nil)
    }

    func showEdit(mealCard: MealCardViewCell, meal: Meal) {
        let heroID = "\(meal.date.timeIntervalSince1970)"
        mealCard.imageView.hero.id = heroID

        let repository = DayRepository()
        let model = InputMealModel(repository: repository,
                                   meal: meal)
        let viewModel = NewInputMealViewModel(coordinator: self,
                                           model: model)
        let vc = InputMealViewController(viewModel: viewModel,
                                         image: mealCard.imageView.image)
        vc.hero.isEnabled = true
        vc.hero.modalAnimationType = .auto
        vc.headerView.hero.id = heroID
        navigator.present(vc, animated: true, completion: nil)
    }

    func dismiss() {
        navigator.dismiss(animated: true, completion: nil)
    }
}
