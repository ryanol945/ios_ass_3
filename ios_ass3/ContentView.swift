//
//  ContentView.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 22/4/2026.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var converterVM = TimezoneViewModel()
    @StateObject var clockVM = TimezoneViewModel()

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CalcHomeView()) {
                    HStack {
                        Image(systemName: "number")
                            .foregroundColor(.blue)
                        Text("Calculator")
                    }
                }

                NavigationLink(destination: ConverterView(vm: converterVM)) {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.green)
                        Text("Converter")
                    }
                }
                HStack {
                    Image(systemName: "alarm")
                        .foregroundColor(.orange)
                    Text("Alarms")
                }

                NavigationLink(destination: ClockView(vm: clockVM)) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.purple)
                        Text("Clock")
                    }
                }
            }
            .navigationTitle("Timezone Utilities")
        }
    }
}
