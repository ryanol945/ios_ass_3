//
//  Untitled.swift
//  ios_ass3
//
//  Created by Jaiden Gardner on 4/5/2026.
//

import SwiftUI

struct AlarmMainContentView: View {
    @StateObject private var alarmManager = AlarmManager()
    
    @State private var selectedAlarm: Alarm? = nil
    @State private var detailAlarm: Alarm? = nil
    
    @State private var editMode: EditMode = .inactive
    
    var ListOfAlarms: [Alarm] {
        var alarmList = alarmManager.alarms
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack {
                    
                }
                
                NavigationLink(destination: detailAlarm.map { AlarmDetailView(alarm: $0) }, isActive: Binding(
                    get: { detailAlarm != nil },
                    set: { if !$0 { detailAlarm = nil } })) {
                        EmptyView()
                    }
                    .hidden()
            }
            .sheet(item: $selectedAlarm) {alarm in
                EditAlarmView(alarmManager: alarmManager, alarm: alarm)
            }
            .onAppear {
                if alarmManager.alarms.isEmpty {
                    alarmManager.addAlarm()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    @State private var editSelection: Set<Alarm.ID> = []
    
    private func onDelete(offsets: IndexSet) {
        //itemsToDelete = offsets
        //showingDeleteConfirmation = true
    }
    
    private func alarmRow(alarm: Alarm) -> some View {
        Button {
            detailAlarm = alarm
        } label: {
            HStack {
                Circle()
                    .fill(.red)
                    .frame(width: 10, height: 10)
                VStack(alignment: .leading, spacing: 4) {
                    Text(formattedTime(alarm.time))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    HStack {
                        Text(alarm.label)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                    }
                }
                
                Spacer ()
                
                Toggle("", isOn: Binding(
                    get: { alarm.isEnabled },
                    set: { newValue in
                        var updatedAlarm = alarm
                        updatedAlarm.isEnabled = newValue
                        alarmManager.updateAlarm(alarm: updatedAlarm)
                        HapticManager.triggerSelectionHaptic()
                    }
                ))
                labelsHidden()
                    .tint(.green)
            }
        }
        .buttonStyle(.plain)
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
