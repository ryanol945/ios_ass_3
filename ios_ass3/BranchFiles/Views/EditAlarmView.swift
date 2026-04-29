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
    
    let weedays = Alarm.Weekday.allCases
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Alarm Time").foregroundColor(.white)) {
                    DatePicker("Select Time", selection: $alarm.time, displayComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                }
                Section(header: Text("Label").foregroundColor(.white)) {
                    TextField("Enable Alarm", txt: $alarm.label)
                        .textInputAutocapitalization(.words)
                }
                Section(header: Text("Status").foregroundColor(.white)) {
                    Toggle("Enable Alarm", isOn: $alarm.isEnabled)
                        .tint(.green)
                }
                Section(header: Text("Vibration").foregroundColor(.white)) {
                    Toggle("Enable Vibration", isOn: $alarm.vibrationEnabled)
                        .tint(.orange)
                }
            }
            .navigationTitle("Edit Alarm")
            .navigationBarTitleDisplayMode(.inLine)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        alarmManager.updateAlarm(alarm: alarm)
                        HapticManager.triggerSuccessHaptic()
                        dismiss()
                    }
                }
            }
        }
    }
}
    
#Preview {
    EditAlarmView(
        alarmManager: AlarmManager(),
        alarm: Alarm.init(time: Date(), label: "Test", isEnabled: true)
    )
}
