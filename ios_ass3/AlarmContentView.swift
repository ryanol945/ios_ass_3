//
//  Untitled.swift
//  ios_ass3
//
//  Created by Jaiden Gardner on 4/5/2026.
//

import SwiftUI

struct AlarmMainContentView: View {
    @StateObject private var alarmManager = AlarmManager()

    @State private var showingAddSheet  = false
    @State private var editAlarm: Alarm? = nil
    @State private var detailAlarm: Alarm? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                Group {
                    if alarmManager.alarms.isEmpty {
                        emptyState
                    } else {
                        alarmList
                    }
                }

                // Invisible NavigationLink for detail navigation
                NavigationLink(
                    destination: detailAlarm.map { AlarmDetailView(alarm: $0, alarmManager: alarmManager) },
                    isActive: Binding(
                        get: { detailAlarm != nil },
                        set: { if !$0 { detailAlarm = nil } }
                    )
                ) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationTitle("Alarms")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.orange)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                EditAlarmView(alarmManager: alarmManager, alarm: Alarm(), isNew: true)
            }
            .sheet(item: $editAlarm) { alarm in
                EditAlarmView(alarmManager: alarmManager, alarm: alarm, isNew: false)
            }
        }
        .preferredColorScheme(.light)
    }

    // MARK: - Subviews

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "alarm")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            Text("No Alarms")
                .font(.title2)
                .foregroundColor(.gray)
            Text("Tap + to add your first alarm")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.7))
        }
    }

    private var alarmList: some View {
        List {
            ForEach(alarmManager.alarms) { alarm in
                alarmRow(alarm: alarm)
                    .listRowBackground(Color.gray.opacity(0.15))
                    .listRowSeparatorTint(Color.gray.opacity(0.3))
            }
            .onDelete(perform: alarmManager.deleteAlarm)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func alarmRow(alarm: Alarm) -> some View {
        Button {
            detailAlarm = alarm
        } label: {
            HStack(spacing: 14) {
                // Active indicator
                Circle()
                    .fill(alarm.isEnabled ? Color.orange : Color.gray.opacity(0.4))
                    .frame(width: 10, height: 10)

                VStack(alignment: .leading, spacing: 4) {
                    Text(formattedTime(alarm.time, timezoneID: alarm.timezoneIdentifier))
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(alarm.isEnabled ? .black : .gray)

                    HStack(spacing: 6) {
                        Text(alarm.label)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                Toggle("", isOn: Binding(
                    get: { alarm.isEnabled },
                    set: { _ in
                        alarmManager.toggleAlarm(alarm)
                        HapticManager.triggerSelectionHaptic()
                    }
                ))
                .labelsHidden()
                .tint(.orange)
            }
            .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                if let index = alarmManager.alarms.firstIndex(where: { $0.id == alarm.id }) {
                    alarmManager.deleteAlarm(at: IndexSet([index]))
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }

            Button {
                editAlarm = alarm
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
        }
    }

    // MARK: - Helpers

    private func formattedTime(_ date: Date, timezoneID: String) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: timezoneID) ?? .current
        return formatter.string(from: date)
    }
}
