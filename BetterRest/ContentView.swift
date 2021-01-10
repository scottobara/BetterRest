//
//  ContentView.swift
//  BetterRest
//
//  Created by Scott Obara on 10/1/21.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date()
    
    var body: some View {
        let now = Date()
        let tomorrow = Date().addingTimeInterval(86400)
        let range = now ... tomorrow
        
        Form {
            Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                Text("\(sleepAmount, specifier: "%g") hours")
            }
            DatePicker("Please enter a Time", selection: $wakeUp, in: range, displayedComponents: .hourAndMinute)
                //.labelsHidden()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
