//
//  CalcOffsetView.swift
//  ios_ass3
//
//  Created by Alex Tully on 29/4/2026.
//

import SwiftUI

struct CalcOffsetView: View {
    @State private var year = Calendar.current.component(.year, from: Date())
    @State private var month = Calendar.current.component(.month, from: Date())
    @State private var day = Calendar.current.component(.day, from: Date())
    @State private var hour = 12; @State private var minute = 0
    @State private var period = 0; @State private var zone = TimeZone.current

    @State private var offsetDays = 0
    @State private var offsetHours = 0
    @State private var offsetMinutes = 0
    @State private var isAdding = true
    @State private var resultZone = TimeZone.current

    private var result: Date {
        let base = makeDate(year: year, month: month, day: day,
                            hour: hour, minute: minute, period: period, zone: zone)
        let secs = (offsetDays * 86400 + offsetHours * 3600 + offsetMinutes * 60) * (isAdding ? 1 : -1)
        return base.addingTimeInterval(TimeInterval(secs))
    }

    private var resultString: String {
        let f = DateFormatter()
        f.dateFormat = "EEE d MMM yyyy, h:mm a"
        f.timeZone = resultZone
        return f.string(from: result)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                CalcTimeInputView(label: "Start Time",
                                  year: $year, month: $month, day: $day,
                                  hour: $hour, minute: $minute,
                                  period: $period, zone: $zone)

                VStack(spacing: 12) {
                    Picker("", selection: $isAdding) {
                        Text("＋  Add").tag(true)
                        Text("－  Subtract").tag(false)
                    }
                    .pickerStyle(.menu)
                    .font(.title2.bold())
                    .padding(.horizontal, 24).padding(.vertical, 10)
                    .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))

                    HStack(spacing: 0) {
                        Picker("", selection: $offsetDays) {
                            ForEach(0...365, id: \.self) { Text("\($0)d").tag($0) }
                        }
                        .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()

                        Picker("", selection: $offsetHours) {
                            ForEach(0...23, id: \.self) { Text("\($0)h").tag($0) }
                        }
                        .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()

                        Picker("", selection: $offsetMinutes) {
                            ForEach(0...59, id: \.self) { Text(String(format: "%02dm", $0)).tag($0) }
                        }
                        .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()
                    }
                    .frame(height: 100)
                    .padding(16)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
                }

                Divider()

                VStack(spacing: 8) {
                    Text(resultString)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .contentTransition(.numericText())
                        .animation(.spring(duration: 0.3), value: resultString)

                    HStack {
                        Text("in").foregroundStyle(.secondary)
                        Picker("", selection: $resultZone) {
                            ForEach(zones, id: \.identifier) {
                                Text($0.abbreviation() ?? $0.identifier).tag($0)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    .font(.subheadline)
                }

                Spacer()
            }
            .padding(24)
        }
        .navigationTitle("Add / Subtract")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack { CalcOffsetView() }
}
