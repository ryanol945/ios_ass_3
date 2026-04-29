//
//  ContentView.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 22/4/2026.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var settings = TimezoneModel()
    let allTimezones = TimeZone.knownTimeZoneIdentifiers.sorted()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Base Time: \(formatTime(settings.timeValue))")
                            .font(.system(.headline, design: .monospaced))
                        
                        Slider(value: $settings.timeValue, in: 0...23.92, step: 5/60)
                            .accentColor(.blue)
                        
                        Picker("Base Location", selection: $settings.timezoneNames[0]) {
                            ForEach(allTimezones, id: \.self) { tz in
                                Text(tz).tag(tz)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .padding()
                }

                Divider()

                List {
                    ForEach(settings.timezoneNames.indices, id: \.self) { index in
                        if index > 0 {
                            HStack {
                                Picker("", selection: $settings.timezoneNames[index]) {
                                    ForEach(allTimezones, id: \.self) { tz in
                                        Text(tz).tag(tz)
                                    }
                                }
                                .pickerStyle(.menu)
                                .labelsHidden()
                                .fixedSize()
                                
                                Spacer()
                                
                                Text(calculateTime(for: settings.timezoneNames[index]))
                                    .fontWeight(.bold)
                                    .monospacedDigit()
                            }
                        }
                    }
                    .onDelete(perform: removeLocation)

                    Button(action: addLocation) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Timezone")
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Timezone Converter")
            .toolbar {
                EditButton()
            }
        }
    }

    func addLocation() {
        settings.timezoneNames.append("America/New_York")
    }
    
    func removeLocation(at offsets: IndexSet) {
        settings.timezoneNames.remove(atOffsets: offsets)
    }

    func calculateTime(for targetIdentifier: String) -> String {
        let anchorIdentifier = settings.timezoneNames[0]
        guard let anchorTZ = TimeZone(identifier: anchorIdentifier),
              let targetTZ = TimeZone(identifier: targetIdentifier) else { return "--:--" }
        
        let secondsDifference = TimeInterval(targetTZ.secondsFromGMT() - anchorTZ.secondsFromGMT())
        let hoursDifference = secondsDifference / 3600.0
        var finalHour = settings.timeValue + hoursDifference
        
        if finalHour < 0 { finalHour += 24 }
        if finalHour >= 24 { finalHour -= 24 }
        
        return formatTime(finalHour)
    }

    func formatTime(_ decimalHour: Double) -> String {
        let totalMinutes = Int(round(decimalHour * 60))
        let hours = (totalMinutes / 60) % 24
        let minutes = totalMinutes % 60
        return String(format: "%02d:%02d", hours, minutes)
    }
}
