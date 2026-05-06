//
//  TimezoneViewModel.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 29/4/2026.
//

import SwiftUI
import Combine

class TimezoneViewModel: ObservableObject {
    @Published var timezoneNames: [String] = [TimeZone.current.identifier]
    @Published var timeValue: Double = 12.0
    @Published var currentTime = Date()
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        let hour = Double(components.hour ?? 12)
        let minute = Double(components.minute ?? 0)
        self.timeValue = hour + ((minute / 5.0).rounded() * 5.0 / 60.0)
        
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .assign(to: \.currentTime, on: self)
            .store(in: &cancellables)
    }

    func addLocation(identifier: String = TimeZone.current.identifier) {
        timezoneNames.append(identifier)
    }

    func removeLocation(at offsets: IndexSet) {
        timezoneNames.remove(atOffsets: offsets)
    }

    func formatTime(decimalHour: Double) -> String {
        let totalMinutes = Int(round(decimalHour * 60))
        let hours = (totalMinutes / 60) % 24
        let minutes = totalMinutes % 60
        return String(format: "%02d:%02d", hours, minutes)
    }

    func calculateOffsetTime(for targetID: String, baseHour: Double) -> String {
        let anchorID = timezoneNames[0]
        guard let anchorTZ = TimeZone(identifier: anchorID),
              let targetTZ = TimeZone(identifier: targetID) else { return "--:--" }
        
        let secondsDiff = TimeInterval(targetTZ.secondsFromGMT() - anchorTZ.secondsFromGMT())
        var finalHour = baseHour + (secondsDiff / 3600.0)
        
        if finalHour < 0 { finalHour += 24 }
        if finalHour >= 24 { finalHour -= 24 }
        
        return formatTime(decimalHour: finalHour)
    }

    func formatLiveTime(for identifier: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: identifier) ?? .current
        return formatter.string(from: currentTime)
    }
}
