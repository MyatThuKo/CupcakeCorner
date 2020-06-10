//
//  ContentView.swift
//  Cup Cake Corner
//
//  Created by Myat Thu Ko on 6/9/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your ckae type", selection: $order.type) {
                        ForEach(0..<Order.types.count, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Stepper(value: $order.quantity, in: 3...20) {
                        Text("Number of cupcakes: \(order.quantity)")
                    }
                }
                
                Section {
                    Toggle(isOn: $order.specialRequest.animation()) {
                        Text("Any Special Request")
                    }
                    
                    if order.specialRequest {
                        Toggle(isOn: $order.extraFrosting) {
                            Text("Add Extra Frosting")
                        }
                        
                        Toggle(isOn: $order.extraSprinkles) {
                            Text("Add Extra Sprinkles")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: AddressView(order: order)) {
                        Text("Delivery Details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
