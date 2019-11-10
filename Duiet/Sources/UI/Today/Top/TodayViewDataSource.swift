//
//  TodayViewDataSource.swift
//  Duiet
//
//  Created by 上西 隆平 on 2019/04/23.
//  Copyright © 2019 Duiet. All rights reserved.
//

import RxSwift
import UIKit

final class TodayViewDataSource: NSObject {
    private let viewModel: TodayViewModelProtocol

    init(viewModel: TodayViewModelProtocol) {
        self.viewModel = viewModel
    }

    func configure(with collectionView: UICollectionView) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(R.nib.daySummaryViewCell)
        collectionView.register(R.nib.mealCardViewCell)
        collectionView.register(R.nib.addMealCardViewCell)
    }
}

extension TodayViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewModel.state.meals.isEmpty {
            // progress + addMealView
            return 1 + 1
        }
        // progress + meals
        return 1 + viewModel.state.meals.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0: // progressView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.daySummaryViewCell,
                                                          for: indexPath)!
            cell.configure(with: viewModel.state.dayValue,
                           userProfile: viewModel.state.userProfileValue,
                           unitCollection: viewModel.state.unitCollectionValue)
            return cell

        case 1 + (viewModel.state.meals.count - 1) + 1: // addMealView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.addMealCardViewCell,
                                                          for: indexPath)!
            cell.configure(input: viewModel.input)
            return cell

        default: // mealView
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.mealCardViewCell,
                                                          for: indexPath)!
            let mealIndex = indexPath.row - 1
            let meal = viewModel.state.meals[mealIndex]
            cell.configure(input: viewModel.input,
                           output: viewModel.output,
                           state: viewModel.state,
                           meal: meal)
            return cell
        }
    }
}

extension TodayViewDataSource: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath),
            let cardCell = cell as? MealCardViewCell
        else { return }
        let mealIndex = indexPath.row - 1
        let meal = viewModel.state.meals[mealIndex]
        viewModel.input.selectedItem.on(.next((cardCell, meal, mealIndex)))
    }
}

extension TodayViewDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            let width = collectionView.frame.width * 0.9
            let height = width * 0.5
            let size = CGSize(width: width, height: height)
            return size

        case 1 + (viewModel.state.meals.count - 1) + 1:
            let width = collectionView.frame.width * 0.9
            let height = width * 0.25
            let size = CGSize(width: width, height: height)
            return size

        default:
            let width = collectionView.frame.width
            let height = width * 0.985
            let size = CGSize(width: width,
                              height: height)
            return size
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin = collectionView.frame.width * 0.1 / 2
        let edgeInset = UIEdgeInsets(top: margin,
                                     left: 0,
                                     bottom: margin,
                                     right: 0)
        return edgeInset
    }

    // MARK: It is set to make sure that there is no shadow line
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        collectionView.frame.width * 0.1 / 2
    }
}
