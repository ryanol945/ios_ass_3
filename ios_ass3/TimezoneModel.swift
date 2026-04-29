//
//  TimezoneModel.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 29/4/2026.
//

import Foundation
import Combine

class TimezoneModel: ObservableObject {
    @Published var timezoneNames: [String] = [TimeZone.current.identifier]
    
    @Published var timeValue: Double = {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let hour = Double(components.hour ?? 12)
        let minute = Double(components.minute ?? 0)
        let roundedMinute = (minute / 5.0).rounded() * 5.0
        return hour + (roundedMinute / 60.0)
    }()
}
