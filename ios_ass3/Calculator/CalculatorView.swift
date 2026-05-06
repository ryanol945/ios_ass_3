////
////  Calculatorview.swift
////  ios_ass3
////
////  Created by Alex Tully on 29/4/2026.
////
//
//import SwiftUI
//
//struct CalculatorView: View {
//    @State private var hourA = 12
//    @State private var minuteA = 0
//    @State private var periodA = 0
//    @State private var zoneA = TimeZone.current
//
//    @State private var hourB = 12
//    @State private var minuteB = 0
//    @State private var periodB = 0
//    @State private var zoneB = TimeZone.current
//
//    @State private var isAdding = true
//    @State private var resultZone = TimeZone.current
//
//    @State var clock: Clock
//    private let timezoneIdentifiers = TimeZone.knownTimeZoneIdentifiers.sorted()
//    
//    private func toMinutes(_ h: Int, _ m: Int, _ period: Int, _ zone: TimeZone) -> Int {
//        let hour = h % 12 + (period == 1 ? 12 : 0)
//        return hour * 60 + m - zone.secondsFromGMT() / 60
//    }
//
//    private var result: String {
//        let a = toMinutes(hourA, minuteA, periodA, zoneA)
//        let b = toMinutes(hourB, minuteB, periodB, zoneB)
//        let raw = ((isAdding ? a + b : a - b) + resultZone.secondsFromGMT() / 60)
//        let mins = ((raw % 1440) + 1440) % 1440
//        let h24 = mins / 60
//        let m   = mins % 60
//        let h12 = h24 % 12 == 0 ? 12 : h24 % 12
//        return String(format: "%d:%02d %@", h12, m, h24 < 12 ? "AM" : "PM")
//    }
//
//    var body: some View {
//        VStack(spacing: 32) {
//            Text("Time Calculator")
//                .font(.system(size: 28, weight: .bold, design: .rounded))
//
//            // Time A
//            timeInput(hour: $hourA, minute: $minuteA, period: $periodA, zone: $zoneA)
//
//            // Operator dropdown
//            Picker("", selection: $isAdding) {
//                Text("＋  Plus").tag(true)
//                Text("－  Minus").tag(false)
//            }
//            .pickerStyle(.menu)
//            .font(.title2.bold())
//            .padding(.horizontal, 24)
//            .padding(.vertical, 10)
//            .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
//
//            // Time B
//            timeInput(hour: $hourB, minute: $minuteB, period: $periodB, zone: $zoneB)
//
//            Divider()
//
//            // Result
//            VStack(spacing: 6) {
//                Text("= \(result)")
//                    .font(.system(size: 42, weight: .bold, design: .rounded))
//                    .contentTransition(.numericText())
//                    .animation(.spring(duration: 0.3), value: result)
//
//                HStack {
//                    Text("in").foregroundStyle(.secondary)
//                    Picker("Timezone", selection: $clock.timezoneIdentifier) {
//                        ForEach(timezoneIdentifiers, id: \.self) { tz in
//                            Text(tz).tag(tz)
//                        }
//                    }
//                    .pickerStyle(.navigationLink)
//                }
//                .font(.subheadline)
//            }
//
//            Spacer()
//        }
//        .padding(24)
//    }
//
//    @ViewBuilder
//    private func timeInput(
//        hour: Binding<Int>, minute: Binding<Int>,
//        period: Binding<Int>, zone: Binding<TimeZone>
//    ) -> some View {
//        VStack(spacing: 10) {
//            HStack(spacing: 0) {
//                Picker("", selection: hour) {
//                    ForEach(1...12, id: \.self) { Text("\($0)").tag($0) }
//                }
//                .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()
//
//                Text(":").font(.title2.bold()).foregroundStyle(.secondary)
//
//                Picker("", selection: minute) {
//                    ForEach(0...59, id: \.self) { Text(String(format: "%02d", $0)).tag($0) }
//                }
//                .pickerStyle(.wheel).frame(maxWidth: .infinity).clipped()
//
//                Picker("", selection: period) {
//                    Text("AM").tag(0)
//                    Text("PM").tag(1)
//                }
//                .pickerStyle(.wheel).frame(width: 70).clipped()
//            }
//            .frame(height: 100)
//
//            // Timezone dropdown
//            Picker("Timezone", selection: $clock.timezoneIdentifier) {
//                ForEach(timezoneIdentifiers, id: \.self) { tz in
//                    Text(tz).tag(tz)
//                }
//            }
//            .pickerStyle(.navigationLink)
//            .frame(maxWidth: .infinity, alignment: .center)
//        }
//        .padding(16)
//        .background(.quaternary, in: RoundedRectangle(cornerRadius: 16))
//    }
//}
