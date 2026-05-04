//
//  CalcHelpers.swift
//  ios_ass3
//
//  Created by Alex Tully on 29/4/2026.
//

import SwiftUI

struct TimePoint {
    var year   = Calendar.current.component(.year,  from: Date())
    var month  = Calendar.current.component(.month, from: Date())
    var day    = Calendar.current.component(.day,   from: Date())
    var hour   = 12
    var minute = 0
    var period = 0
    var zone   = TimeZone.current

    var asDate: Date {
        makeDate(year: year, month: month, day: day,
                 hour: hour, minute: minute, period: period, zone: zone)
    }
}

let zones: [TimeZone] = [
    "America/New_York", "America/Los_Angeles", "America/Chicago",
    "America/Denver", "Europe/London", "Europe/Paris",
    "Asia/Tokyo", "Asia/Singapore", "Australia/Sydney", "UTC"
].compactMap { TimeZone(identifier: $0) }

func makeDate(year: Int, month: Int, day: Int,
              hour: Int, minute: Int, period: Int,
              zone: TimeZone) -> Date {
    var c = DateComponents()
    c.year = year; c.month = month; c.day = day
    c.hour = hour % 12 + (period == 1 ? 12 : 0)
    c.minute = minute
    c.timeZone = zone
    return Calendar.current.date(from: c) ?? Date()
}

func timeDifference(from a: Date, to b: Date) -> (days: Int, hours: Int, minutes: Int, negative: Bool) {
    let secs  = Int(b.timeIntervalSince(a))
    let total = abs(secs) / 60
    return (total / 1440, (total % 1440) / 60, total % 60, secs < 0)
}

struct CalcTimeInputView: View {
    let label: String
    @Binding var point: TimePoint

    var body: some View {
        VStack(spacing: 10) {
            Text(label)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 0) {
                Picker("Day", selection: $point.day) {
                    ForEach(1...31, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()

                Picker("Month", selection: $point.month) {
                    ForEach(1...12, id: \.self) {
                        Text(DateFormatter().monthSymbols[$0 - 1].prefix(3).description).tag($0)
                    }
                }
                .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()

                Picker("Year", selection: $point.year) {
                    ForEach(2020...2035, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()
            }
            .frame(height: 80)

            HStack(spacing: 0) {
                Picker("Hour", selection: $point.hour) {
                    ForEach(1...12, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()

                Text(":").font(.title2.bold()).foregroundStyle(.secondary)

                Picker("Minute", selection: $point.minute) {
                    ForEach(0...59, id: \.self) { Text(String(format: "%02d", $0)).tag($0) }
                }
                .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()

                Picker("Period", selection: $point.period) {
                    Text("AM").tag(0)
                    Text("PM").tag(1)
                }
                .pickerStyle(.wheel).frame(width: 70).clipped()
            }
            .frame(height: 80)

            Picker("Timezone", selection: $point.zone) {
                ForEach(zones, id: \.identifier) {
                    Text($0.abbreviation() ?? $0.identifier).tag($0)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(16)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
    }
}
