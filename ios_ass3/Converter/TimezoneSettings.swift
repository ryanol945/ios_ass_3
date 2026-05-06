//
//  TimezoneSettings.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 6/5/2026.
//

import Foundation
import SwiftUI
import Combine

struct TimezoneSettings: Codable {
    var timezoneNames: [String]
    var timeValue: Double
    
    static var defaultSettings: TimezoneSettings {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let hour = Double(components.hour ?? 12)
        let minute = Double(components.minute ?? 0)
        let roundedMinute = (minute / 5.0).rounded() * 5.0
        
        return TimezoneSettings(
            timezoneNames: [TimeZone.current.identifier],
            timeValue: hour + (roundedMinute / 60.0)
        )
    }
}
