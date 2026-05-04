//
//  CalcDifferenceView.swift
//  ios_ass3
//
//  Created by Alex Tully on 29/4/2026.
//

import SwiftUI

struct CalcDifferenceView: View {

    @State private var a = TimePoint()
    @State private var b = TimePoint()

    private var diff: (days: Int, hours: Int, minutes: Int, negative: Bool) {
        timeDifference(from: a.asDate, to: b.asDate)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                CalcTimeInputView(label: "Time A", point: $a)

                Text("to")
                    .font(.title2.bold())
                    .foregroundStyle(.secondary)

                CalcTimeInputView(label: "Time B", point: $b)

                Divider()

                resultSection

                Spacer()
            }
            .padding(24)
        }
        .navigationTitle("Difference")
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private var resultSection: some View {
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
