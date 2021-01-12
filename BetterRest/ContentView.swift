//
//  ContentView.swift
//  BetterRest
//
//  Created by Scott Obara on 10/1/21.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    //@State private var showingAlert = false
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your ideal bed time")) {
                    Text("\(alertMessage)").font(.largeTitle).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                }
                
                Section(header: Text("When do you want to wake up?")){
                    
                    HStack {
                        //Text("\(wakeUp)")
                        //Spacer()
                        DatePicker("Please enter a time", selection: Binding(get: {
                            self.wakeUp
                        }, set: { (newWakeUp) in
                            self.wakeUp = newWakeUp
                            self.calculateBedtime()
                        }), displayedComponents: .hourAndMinute)
                            .labelsHidden()
                    }
                    .datePickerStyle(GraphicalDatePickerStyle())
                }
                
                Section(header: Text("Desired amount of sleep")){
                    //https://stackoverflow.com/questions/58404421/how-to-trigger-a-function-when-a-slider-changes-in-swiftui
                    Stepper(value: Binding(get: {
                        self.sleepAmount
                    }, set: { (newSleep) in
                        self.sleepAmount = newSleep
                        self.calculateBedtime()
                    }), step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section(header: Text("Daily coffee intake")){

//                    Stepper(value: $coffeeAmount, in: 1...20) {
//                        if coffeeAmount == 1 {
//                            Text("1 cup")
//                        } else {
//                            Text("\(coffeeAmount) cups")
//                        }
//                    }
                    Picker(selection: Binding(get: {
                        self.coffeeAmount
                    }, set: { (newCoffeeAmount) in
                        self.coffeeAmount = newCoffeeAmount
                        self.calculateBedtime()
                    }), label: Text("\(coffeeAmount) cups")) {
                        ForEach((1...10), id: \.self) {
                            if ($0 == 1) {
                                Text("\($0) cup")
                            } else {
                                Text("\($0) cups")
                            }
                        }
                    } //https://developer.apple.com/documentation/swiftui/view/pickerstyle(_:)
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationBarTitle("BetterRest")
            //.padding(.horizontal, 20)
//            .navigationBarItems(trailing:
//                Button(action: calculateBedtime) {
//                    Text("Calculate")
//                }
//            )
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
        }
    }
    //https://stackoverflow.com/questions/37701187/when-to-use-static-constant-and-variable-in-swift
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() {
        //https://developer.apple.com/documentation/xcode-release-notes/xcode-12-release-notes
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is…"
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        //showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
