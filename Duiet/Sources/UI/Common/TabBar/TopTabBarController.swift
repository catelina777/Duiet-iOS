//
//  TopTabBarController.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/06/30.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

class TopTabBarController: UITabBarController {

    let viewModel: TopTabBarViewModel

    let dayVC: DayViewController
    let monthVC: MonthViewController
    let yearVC: YearViewController
    let settingVC: SettingViewController

    init(dayVC: DayViewController,
         monthVC: MonthViewController,
         yearVC: YearViewController,
         settingVC: SettingViewController) {
        viewModel = TopTabBarViewModel()
        self.dayVC = dayVC
        self.monthVC = monthVC
        self.yearVC = yearVC
        self.settingVC = settingVC
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
