//
//  CalcHelpers.swift
//  ios_ass3
//
//  Created by Alex Tully on 29/4/2026.
//
import SwiftUI


let zones: [TimeZone] = TimeZone.knownTimeZoneIdentifiers.sorted().compactMap { TimeZone(identifier: $0) }

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

struct CalcTimeInputView: View {
    let label: String
    @Binding var year: Int
    @Binding var month: Int
    @Binding var day: Int
    @Binding var hour: Int
    @Binding var minute: Int
    @Binding var period: Int
    @Binding var zone: TimeZone

    var body: some View {
        VStack(spacing: 10) {
            Text(label)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 0) {
                Picker("", selection: $day) {
                    ForEach(1...31, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()

                Picker("", selection: $month) {
                    ForEach(1...12, id: \.self) {
                        Text(DateFormatter().monthSymbols[$0 - 1].prefix(3).description).tag($0)
                    }
                }
                .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()

                Picker("", selection: $year) {
                    ForEach(2020...2035, id: \.self) { yearValue in
                        Text("\(yearValue, format: .number.grouping(.never))")
                            .tag(yearValue)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .clipped()
            }
            .frame(height: 80)

            HStack(spacing: 0) {
                Picker("", selection: $hour) {
                    ForEach(1...12, id: \.self) { Text("\($0)").tag($0) }
                }
                .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()

                Text(":").font(.title2.bold()).foregroundStyle(.secondary)

                Picker("", selection: $minute) {
                    ForEach(0...59, id: \.self) { Text(String(format: "%02d", $0)).tag($0) }
                }
                .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()

                Picker("", selection: $period) {
                    Text("AM").tag(0)
                    Text("PM").tag(1)
                }
                .pickerStyle(.wheel).frame(width: 70).clipped()
            }
            .frame(height: 80)

            Picker("Select Time Zone", selection: $zone) {
                ForEach(zones, id: \.identifier) { tz in
                    let displayName = tz.identifier.replacingOccurrences(of: "_", with: " ")
                    
                    Text(displayName)
                        .tag(tz)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(16)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
    }
}
