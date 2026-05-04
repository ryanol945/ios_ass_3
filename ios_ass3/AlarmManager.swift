//
//  AlarmManager.swift
//  ios_ass3
//
//  Created by Jaiden Gardner on 29/4/2026.
//

import Foundation
import SwiftUI
import Combine

class AlarmManager: ObservableObject {
    @Published var alarms: [Alarm] = []
    
    func addAlarm() {
        let newAlarm = Alarm(time: Date(), label: "New Alarm", isEnabled: true)
        alarms.append(newAlarm)
    }
    
    func updateAlarm(alarm: Alarm) {
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id}) else { return }
        alarms[index] = alarm
    }
    
    func deleteAlarm(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
    }
}
