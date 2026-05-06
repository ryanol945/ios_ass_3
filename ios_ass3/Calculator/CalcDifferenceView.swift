
//
//  CalcDifferenceView.swift
//  ios_ass3
//
//  Created by Alex Tully on 29/4/2026.
//

import SwiftUI

struct CalcDifferenceView: View {
    @State private var yearA = Calendar.current.component(.year, from: Date())
    @State private var monthA = Calendar.current.component(.month, from: Date())
    @State private var dayA = Calendar.current.component(.day, from: Date())
    @State private var hourA = 12; @State private var minuteA = 0
    @State private var periodA = 0; @State private var zoneA = TimeZone.current

    @State private var yearB = Calendar.current.component(.year, from: Date())
    @State private var monthB = Calendar.current.component(.month, from: Date())
    @State private var dayB = Calendar.current.component(.day, from: Date())
    @State private var hourB = 12; @State private var minuteB = 0
    @State private var periodB = 0; @State private var zoneB = TimeZone.current

    private var diff: (days: Int, hours: Int, minutes: Int, negative: Bool) {
        let a = makeDate(year: yearA, month: monthA, day: dayA, hour: hourA, minute: minuteA, period: periodA, zone: zoneA)
        let b = makeDate(year: yearB, month: monthB, day: dayB, hour: hourB, minute: minuteB, period: periodB, zone: zoneB)
        let secs = Int(b.timeIntervalSince(a))
        let neg = secs < 0
        let total = abs(secs) / 60
        return (total / 1440, (total % 1440) / 60, total % 60, neg)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                CalcTimeInputView(label: "Time A",
                                  year: $yearA, month: $monthA, day: $dayA,
                                  hour: $hourA, minute: $minuteA,
                                  period: $periodA, zone: $zoneA)

                Text("to")
                    .font(.title2.bold())
                    .foregroundStyle(.secondary)

                CalcTimeInputView(label: "Time B",
                                  year: $yearB, month: $monthB, day: $dayB,
                                  hour: $hourB, minute: $minuteB,
                                  period: $periodB, zone: $zoneB)

                Divider()

                if diff.days == 0 && diff.hours == 0 && diff.minutes == 0 {
                    Text("Same time")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                } else {
                    Text(diff.negative ? "B is before A" : "B is after A")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 16) {
                        unitBadge(value: diff.days,    label: "days")
                        unitBadge(value: diff.hours,   label: "hrs")
                        unitBadge(value: diff.minutes, label: "min")
                    }
                    .animation(.spring(duration: 0.3), value: diff.days)
                }

                Spacer()
            }
            .padding(24)
        }
        .navigationTitle("Difference")
        .navigationBarTitleDisplayMode(.large)
    }

    private func unitBadge(value: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(minWidth: 72)
        .padding(.vertical, 14)
        .background(.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(.blue.opacity(0.2)))
    }
}

#Preview {
    NavigationView { CalcDifferenceView() }
}
