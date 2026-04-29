//
//  TimezoneAlarm.swift
//  ios_ass3
//
//  Created by Jaiden Gardner on 29/4/2026.
//

import SwiftUI
import AlarmKit

struct AlarmContentView: View {
    private let alarmManager = AlarmManager.shared
    
    var body: some View {
        VStack{
            TimelineView(.periodic(from: .now, by: 1)) { context in
                Text(context.date, format: Date.FormatStyle(date: .omitted, time: .standard))
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .padding()
            }
            
            Button("Schedule Alarm") {
                Task {
                    await scheduleTimer()
                }
            }
        }
        .task {
            guard await requestPermission() else { return }
        }
    }
    
    private func requestPermission() async -> Bool {
        switch alarmManager.authorizationState {
        case .notDetermined:
            do {
                return try await alarmManager.requestAuthorization() == .authorized
            } catch {
                return false
            }
        case .authorized:
            return true
        case .denied:
            return true
        
        @unknown default:
            return false
        }
    }
    
    private func scheduleTimer() async {
        let alert = AlarmPresentation.Alert(
            title: "Ready",
            stopButton: AlarmButton(
                text: "Done",
                textColor: .pink,
                systemImageName: "Checkmark"
                )
            )
        
        let attributes = AlarmAttributes<EmptyMetadata>(
            presentation: AlarmPresentation(alert: alert),
            tintColor: .pink
        )
        do {
            let timerAlarm = try await alarmManager.schedule(
                id: UUID(),
                configuration: .timer(
                    duration: 60,
                    attributes: attributes
                )
            )
        } catch {
            print("Schedulig error: \(error)")
        }
    }
}

nonisolated
struct EmptyMetadata: AlarmMetadata{
    
}
