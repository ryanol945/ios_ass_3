//
//  alarm2.swift
//  ios_ass3
//
//  Created by Jaiden Gardner on 29/4/2026.
//

import Foundation
import SwiftUI

struct Alarm: Identifiable {
    let id = UUID()
    let time: Date
    let label: String
    var isEnabled: Bool
    var vibrationEnabled: Bool = false
    
    enum Weekday: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case monday = "Mon"
        case tuesday = "Tue"
        case wednesday = "Wed"
        case thursday = "Thu"
        case friday = "Fri"
        case saturday = "Sat"
        case sunday = "Sun"
    }
}
