//
//  alarm2.swift
//  ios_ass3
//
//  Created by Jaiden Gardner on 29/4/2026.
//

import Foundation

struct Alarm: Identifiable, Codable {
    let id: UUID
    var time: Date
    var label: String
    var isEnabled: Bool
    var vibrationEnabled: Bool
    var timezoneIdentifier: String

    init(
        id: UUID = UUID(),
        time: Date = Date(),
        label: String = "Alarm",
        isEnabled: Bool = true,
        vibrationEnabled: Bool = true,
        timezoneIdentifier: String = TimeZone.current.identifier
    ) {
        self.id = id
        self.time = time
        self.label = label
        self.isEnabled = isEnabled
        self.vibrationEnabled = vibrationEnabled
        self.timezoneIdentifier = timezoneIdentifier
    }
}
