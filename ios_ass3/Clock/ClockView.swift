//
//  TimeView.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 29/4/2026.
//


import SwiftUI
import Combine

struct ClockView: View {
    @StateObject private var clockManager = ClockManager()
    
    let allTimezones = TimeZone.knownTimeZoneIdentifiers.sorted()
    
    var body: some View {
        List {
            ForEach(clockManager.settings.timezoneNames.indices, id: \.self) { i in
                HStack() {
                    Picker("", selection: $clockManager.settings.timezoneNames[i]) {
                        ForEach(allTimezones, id: \.self) { tz in
                            Text(tz.replacingOccurrences(of: "_", with: " ")).tag(tz)
                        }
                    }.pickerStyle(.menu)
                    .labelsHidden()
                    .fixedSize()
                    .tint(.purple)
                    .onChange(of: clockManager.settings.timezoneNames[i]) { _ in
                                clockManager.saveTimezones()
                            }
                    
                    Spacer()
                    
                    Text(formatTime(for: clockManager.settings.timezoneNames[i]))
                        .bold().monospacedDigit()
                }
                .padding(.vertical, 4)
            }
            .onDelete(perform: removeLocation)

            Button(action: addLocation) {
                Label("Add Timezone", systemImage: "plus.circle.fill")
            }
            .foregroundColor(.purple)
        }
        .navigationTitle("World Clock")
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            clockManager.objectWillChange.send()
        }
    }

    //memory
    
    private func addLocation() {
        clockManager.settings.timezoneNames.append(TimeZone.current.identifier)
        clockManager.saveTimezones()
    }

    private func removeLocation(at offsets: IndexSet) {
        clockManager.settings.timezoneNames.remove(atOffsets: offsets)
        clockManager.saveTimezones()
    }

    func formatTime(for identifier: String) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: identifier)
        return formatter.string(from: Date())
    }
}
