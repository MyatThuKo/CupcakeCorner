//
//  AddressView.swift
//  Cup Cake Corner
//
//  Created by Myat Thu Ko on 6/9/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip Code/Postal Code", text: $order.zipCode)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Check out")
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery Details", displayMode: .inline)
        .onAppear(perform: self.order.checkInternet)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
