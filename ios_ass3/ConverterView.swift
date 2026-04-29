//
//  ConverterView.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 29/4/2026.
//


import SwiftUI
import Combine

struct ConverterView: View {
    @ObservedObject var vm: TimezoneViewModel
    let allTimezones = TimeZone.knownTimeZoneIdentifiers.sorted()

    var body: some View {
        VStack(spacing: 0) {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Base Time: \(vm.formatTime(decimalHour: vm.timeValue))")
                        .font(.system(.headline, design: .monospaced))
                    Slider(value: $vm.timeValue, in: 0...23.92, step: 5/60)
                    Picker("Base", selection: $vm.timezoneNames[0]) {
                        ForEach(allTimezones, id: \.self) { Text($0).tag($0) }
                    }
                }.padding()
            }
            List {
                ForEach(vm.timezoneNames.indices, id: \.self) { i in
                    if i > 0 {
                        HStack {
                            Picker("", selection: $vm.timezoneNames[i]) {
                                ForEach(allTimezones, id: \.self) { Text($0).tag($0) }
                            }.labelsHidden().fixedSize()
                            Spacer()
                            Text(vm.calculateOffsetTime(for: vm.timezoneNames[i], baseHour: vm.timeValue))
                                .bold().monospacedDigit()
                        }
                    }
                }.onDelete(perform: vm.removeLocation)
                Button("Add Timezone") { vm.addLocation() }
            }
        }
        .navigationTitle("Converter")
    }
}
