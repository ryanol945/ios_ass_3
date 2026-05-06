//
//  EditAlarmView.swift
//  ios_ass3
//
//  Created by Jaiden Gardner on 29/4/2026.
//

import SwiftUI

struct EditAlarmView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var alarmManager: AlarmManager

    @State var alarm: Alarm
    let isNew: Bool

    // All available IANA timezone identifiers
    private let timezoneIdentifiers = TimeZone.knownTimeZoneIdentifiers.sorted()

    var body: some View {
        NavigationStack {
            Form {
                // ── Timezone ─────────────────────────────────────────────────
                Section(header: Text("Timezone")) {
                    Picker("Timezone", selection: $alarm.clock.timezoneIdentifier) {
                        ForEach(timezoneIdentifiers, id: \.self) { tz in
                            Text(tz).tag(tz)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                // ── Time Picker ──────────────────────────────────────────────
                Section(header: Text("Alarm Time")) {
                    DatePicker(
                        "Select Time",
                        selection: $alarm.clock.time,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .environment(\.timeZone, TimeZone(identifier: alarm.clock.timezoneIdentifier) ?? .current)
                }
                
                // ── Label ────────────────────────────────────────────────────
                Section(header: Text("Label")) {
                    TextField("Alarm label", text: $alarm.label)
                        .textInputAutocapitalization(.words)
                }

                // ── Options ──────────────────────────────────────────────────
                Section(header: Text("Options")) {
                    Toggle("Enable Alarm", isOn: $alarm.isEnabled)
                        .tint(.orange)
                    Toggle("Vibration", isOn: $alarm.vibrationEnabled)
                        .tint(.orange)
                }
            }
            .navigationTitle(isNew ? "New Alarm" : "Edit Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if isNew {
                            alarmManager.addAlarm(alarm)
                        } else {
                            alarmManager.updateAlarm(alarm: alarm)
                        }
                        HapticManager.triggerSuccessHaptic()
                        dismiss()
                    }
                }
            }
        }
    }
}
