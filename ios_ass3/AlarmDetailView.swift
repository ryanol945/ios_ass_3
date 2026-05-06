//
//  AlarmdetailView.swift
//  ios_ass3
//
//  Created by Jaiden Gardner on 4/5/2026.
//

import SwiftUI

struct AlarmDetailView: View {
    let alarm: Alarm
    @ObservedObject var alarmManager: AlarmManager
    @Environment(\.dismiss) var dismiss
    @State private var showingEdit = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {

                    // ── Big time display ─────────────────────────────────────
                    VStack(spacing: 4) {
                        Text(formattedTime(alarm.time))
                            .font(.system(size: 64, weight: .bold, design: .rounded))
                            .foregroundColor(alarm.isEnabled ? .black : .gray)

                        Text(alarm.timezoneIdentifier)
                            .font(.caption)
                            .foregroundColor(.orange.opacity(0.8))
                    }
                    .padding(.top, 16)

                    // ── Notification preview card ────────────────────────────
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Notification Preview")
                            .font(.headline)
                            .foregroundColor(.black)

                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.gray.opacity(0.25))
                            .frame(maxWidth: .infinity)
                            .frame(height: 90)
                            .overlay(
                                HStack(spacing: 14) {
                                    Image(systemName: "alarm.fill")
                                        .font(.title2)
                                        .foregroundColor(.orange)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Alarm")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                        Text("\(alarm.label)  ·  \(formattedTime(alarm.time))")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                            )
                    }
                    .padding(.horizontal)

                    // ── Detail rows ──────────────────────────────────────────
                    VStack(spacing: 0) {
                        detailRow(title: "Label",     value: alarm.label)
                        Divider().background(Color.gray.opacity(0.3))
                        detailRow(title: "Status",    value: alarm.isEnabled ? "Enabled" : "Disabled",
                                  valueColor: alarm.isEnabled ? .green : .red)
                        Divider().background(Color.gray.opacity(0.3))
                        detailRow(title: "Vibration", value: alarm.vibrationEnabled ? "On" : "Off")
                    }
                    .background(Color.gray.opacity(0.12))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // ── Actions ──────────────────────────────────────────────
                    HStack(spacing: 16) {
                        Button {
                            showingEdit = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }

                        Button {
                            var updated = alarm
                            updated.isEnabled.toggle()
                            alarmManager.updateAlarm(alarm: updated)
                            HapticManager.triggerSelectionHaptic()
                            dismiss()
                        } label: {
                            Label(alarm.isEnabled ? "Disable" : "Enable",
                                  systemImage: alarm.isEnabled ? "bell.slash" : "bell")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background((alarm.isEnabled ? Color.red : Color.green).opacity(0.2))
                                .foregroundColor(alarm.isEnabled ? .red : .green)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle("Alarm Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingEdit) {
            EditAlarmView(alarmManager: alarmManager, alarm: alarm, isNew: false)
        }
    }

    // MARK: - Helpers

    private func detailRow(title: String, value: String, valueColor: Color = .black) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
                .frame(width: 100, alignment: .leading)
            Spacer()
            Text(value)
                .foregroundColor(valueColor)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: alarm.timezoneIdentifier) ?? .current
        return formatter.string(from: date)
    }
}
