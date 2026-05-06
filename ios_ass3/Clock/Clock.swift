//
//  ClockComponent.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 6/5/2026.
//

import Foundation

struct Clock: Identifiable, Codable {
    let id: UUID
    var time: Date
    var timezoneIdentifier: String

    init(
        id: UUID = UUID(),
        time: Date = Date(),
        timezoneIdentifier: String = TimeZone.current.identifier
    ) {
        self.id = id
        self.time = time
        self.timezoneIdentifier = timezoneIdentifier
    }
}
