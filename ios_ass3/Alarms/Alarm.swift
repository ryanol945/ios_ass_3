//
//  AlarmComponent.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 6/5/2026.
//

import Foundation

struct Alarm: Identifiable, Codable {
    let id: UUID
    var clock: Clock
    var label: String
    var isEnabled: Bool
    var vibrationEnabled: Bool

    init(
        clock: Clock = Clock(),
        label: String = "Alarm",
        isEnabled: Bool = true,
        vibrationEnabled: Bool = true,
    ) {
        self.clock = clock
        self.id = clock.id
        
        self.label = label
        self.isEnabled = isEnabled
        self.vibrationEnabled = vibrationEnabled
    }
}
