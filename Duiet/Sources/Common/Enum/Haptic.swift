//
//  Haptic.swift
//  Duiet
//
//  Created by Ryuhei Kaminishi on 2019/11/02.
//  Copyright © 2019 duiet. All rights reserved.
//

import UIKit

enum HapticFeedbackStyle: Int {
    case light, medium, heavy
}

extension HapticFeedbackStyle {
    var value: UIImpactFeedbackGenerator.FeedbackStyle {
        UIImpactFeedbackGenerator.FeedbackStyle(rawValue: rawValue)!
    }
}

enum HapticFeedbackType: Int {
    case success, warning, error
}

extension HapticFeedbackType {
    var value: UINotificationFeedbackGenerator.FeedbackType {
        UINotificationFeedbackGenerator.FeedbackType(rawValue: rawValue)!
    }
}

enum Haptic {
    case impact(HapticFeedbackStyle)
    case notification(HapticFeedbackType)
    case selection

    func generate() {
        switch self {
        case .impact(let style):
            let generator = UIImpactFeedbackGenerator(style: style.value)
            generator.prepare()
            generator.impactOccurred()

        case .notification(let type):
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type.value)

        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
}
