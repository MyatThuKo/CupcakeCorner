//
//  CheckoutView.swift
//  Cup Cake Corner
//
//  Created by Myat Thu Ko on 6/9/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var confirmationTitle = ""
    @State private var confirmationMessage = ""
    @State private var showConfirmation = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.order.cost, specifier: "%g")")
                }
            }
            .navigationBarTitle("Check Out", displayMode: .inline)
            .navigationBarItems(trailing: Button("Place Order") {
                if self.order.internetConnection {
                    self.placeOrder()
                } else {
                    self.confirmationTitle = "No Internet Connection"
                    self.confirmationMessage = "Please connect to internet to continue."
                    self.showConfirmation = true
                }
            })
        }
        .onAppear(perform: self.order.checkInternet)
        .alert(isPresented: $showConfirmation) {
            Alert.init(title: Text(self.confirmationTitle), message: Text(self.confirmationMessage), dismissButton: .default(Text("Okay")))
        }
    }
    
    func placeOrder() {
        
        self.confirmationTitle = "Order Confirmation"
        
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unkown Error").")
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMessage = "Thank you for ordering with us. Your order for \(decodedOrder.quantity)x\(Order.types[decodedOrder.type]) cupcakes is on its way to \(decodedOrder.streetAddress). "
                self.showConfirmation = true
            } else {
                print("Invalid response from the server.")
            }
        }.resume()
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
