//
//  AlarmManager.swift
//  ios_ass3
//
//  Created by Jaiden Gardner on 29/4/2026.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

class AlarmManager: ObservableObject {
    @Published var alarms: [Alarm] = []

    private let storageKey = "saved_alarms"

    init() {
        loadAlarms()
        requestNotificationPermission()
    }

    // MARK: - CRUD

    func addAlarm(_ alarm: Alarm = Alarm()) {
        alarms.append(alarm)
        saveAlarms()
        if alarm.isEnabled {
            scheduleNotifications(for: alarm)
        }
    }

    func updateAlarm(alarm: Alarm) {
        guard let index = alarms.firstIndex(where: { $0.id == alarm.id }) else { return }
        cancelNotifications(for: alarms[index])
        alarms[index] = alarm
        saveAlarms()
        if alarm.isEnabled {
            scheduleNotifications(for: alarm)
        }
    }

    func deleteAlarm(at offsets: IndexSet) {
        for index in offsets {
            cancelNotifications(for: alarms[index])
        }
        alarms.remove(atOffsets: offsets)
        saveAlarms()
    }

    func toggleAlarm(_ alarm: Alarm) {
        var updated = alarm
        updated.isEnabled.toggle()
        updateAlarm(alarm: updated)
    }

    // MARK: - Persistence

    private func saveAlarms() {
        if let encoded = try? JSONEncoder().encode(alarms) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    private func loadAlarms() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([Alarm].self, from: data) else { return }
        alarms = decoded
    }

    // MARK: - Notifications

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    func scheduleNotifications(for alarm: Alarm) {
        guard alarm.isEnabled else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = alarm.label
        content.sound = .defaultCritical
        content.interruptionLevel = alarm.vibrationEnabled ? .critical : .active
        
        let tz = TimeZone(identifier: alarm.timezoneIdentifier) ?? .current
        var calendar = Calendar.current
        calendar.timeZone = tz
        let components = calendar.dateComponents([.hour, .minute], from: alarm.time)
        
        var triggerComponents = DateComponents()
        triggerComponents.hour = components.hour
        triggerComponents.minute = components.minute
        triggerComponents.second = 0
        triggerComponents.timeZone = tz
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        let request = UNNotificationRequest(
            identifier: alarm.id.uuidString,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule alarm: \(error.localizedDescription)")
            }
        }
    }

    func cancelNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [alarm.id.uuidString]
        )
    }
}
