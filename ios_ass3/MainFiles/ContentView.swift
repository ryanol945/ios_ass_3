//
//  ContentView.swift
//  ios_ass3
//
//  Created by Ryan Nolan on 22/4/2026.
//

import SwiftUI
import Combine

struct ContentView: View {
    let timezones: [String] = [
        "America/Denver",
        "America/Chicago",
        "Sydeny",
        "Los Angeles"
    ]
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var currentDate = Date()
    
    var body: some View {
        List(timezones, id: \.self) { timezone in
            HStack {
                Text(timezone)
                Spacer()
                Text(currentTime(for: timezone, at: currentDate))
                    .onReceive(timer) { input in
                        currentDate = input
                    }
            }
        }
    }
}

func currentTime(for timezoneIdentifier: String, at date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss"
    
    if let timezone = TimeZone(identifier: timezoneIdentifier) {
        formatter.timeZone = timezone
    }
    
    return formatter.string(from: date)
}

#Preview {
    ContentView()
}
