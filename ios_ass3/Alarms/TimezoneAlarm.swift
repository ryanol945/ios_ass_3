//
//  TimezoneAlarm.swift
//  ios_ass3
//
//  Created by Jaiden Gardner on 29/4/2026.
//

import SwiftUI
import UserNotifications

/// A live clock widget that also shows the current pending alarm count.
/// This view is kept for reference; main alarm UI is AlarmMainContentView.
struct TimezoneAlarmStatusView: View {
    @StateObject private var alarmManager = AlarmManager()
    @State private var pendingCount: Int = 0

    var body: some View {
        VStack(spacing: 20) {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                Text(context.date, format: Date.FormatStyle(date: .omitted, time: .standard))
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .padding()
            }

            Text(pendingCount == 0
                 ? "No alarms scheduled"
                 : "\(pendingCount) notification\(pendingCount == 1 ? "" : "s") pending")
                .font(.subheadline)
                .foregroundColor(.gray)

            Button("Refresh Status") {
                refreshPendingCount()
            }
            .buttonStyle(.bordered)
            .tint(.orange)
        }
        .onAppear { refreshPendingCount() }
    }

    private func refreshPendingCount() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.pendingCount = requests.count
            }
        }
    }
}
