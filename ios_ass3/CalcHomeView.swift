//
//  CalcHomeView.swift
//  ios_ass3
//
//  Created by Alex Tully on 29/4/2026.
//

import SwiftUI

struct CalcHomeView: View {
    var body: some View {
        List {
            NavigationLink(destination: CalcDifferenceView()) {
                HStack {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.blue)
                    Text("Difference")
                }
            }

            NavigationLink(destination: CalcOffsetView()) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                    Text("Add / Subtract")
                }
            }
        }
        .navigationTitle("Calculator")
    }
}

#Preview {
    NavigationView { CalcHomeView() }
}
