//
//  ClockManager.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 6/5/2026.
//

import Foundation
import SwiftUI
import Combine

class ClockManager: ObservableObject {
    @Published var settings: TimezoneSettings {
        didSet {
            saveTimezones()
        }
    }
    
    private let storageKey = "saved_timezones"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(TimezoneSettings.self, from: data) {
            self.settings = decoded
        } else {
            self.settings = .defaultSettings
        }
    }
    
    func saveTimezones() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}
