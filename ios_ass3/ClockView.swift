//
//  TimeView.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 29/4/2026.
//


import SwiftUI
import Combine

struct ClockView: View {
    @ObservedObject var vm: TimezoneViewModel
    let allTimezones = TimeZone.knownTimeZoneIdentifiers.sorted()

    var body: some View {
        List {
            ForEach(vm.timezoneNames.indices, id: \.self) { i in
                VStack {
                    Picker("", selection: $vm.timezoneNames[i]) {
                        ForEach(allTimezones, id: \.self) { Text($0).tag($0) }
                    }.labelsHidden().fixedSize()
                    Text(vm.formatLiveTime(for: vm.timezoneNames[i]))
                        .font(.title3).monospacedDigit()
                }
            }
            .onDelete(perform: vm.removeLocation)
            Button("Add Timezone") { vm.addLocation() }
        }
        .navigationTitle("World Clock")
    }
}
