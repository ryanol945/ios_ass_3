//
//  ContentView.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 22/4/2026.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                //NavigationLink(destination: CalculatorView()) {
                    HStack {
                        Image(systemName: "number")
                            .foregroundColor(.blue)
                        Text("Calculator")
                    }
                //}
                
                NavigationLink(destination: ConverterView()) {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.green)
                        Text("Converter")
                    }
                }

                //NavigationLink(destination: AlarmView()) {
                    HStack {
                        Image(systemName: "alarm")
                            .foregroundColor(.orange)
                        Text("Alarms")
                    }
                //}
            }
            .navigationTitle("Timezone Utilities")
        }
    }
}
