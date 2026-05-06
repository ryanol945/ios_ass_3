//
//  HapticManager.swift
//  ios_ass3
//
//  Created by Jaiden Gardner on 4/5/2026.
//

import Foundation
import SwiftUI
import CoreHaptics

struct HapticManager {
    static func triggerSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func triggerSelectionHaptic() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
