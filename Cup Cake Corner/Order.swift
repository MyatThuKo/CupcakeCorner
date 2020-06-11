//
//  Order.swift
//  Cup Cake Corner
//
//  Created by Myat Thu Ko on 6/9/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import Foundation
import Network

class Order: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, extraSprinkles, name, streetAddress, city, zipCode
    }
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequest = false {
        didSet {
            if specialRequest == false {
                extraSprinkles = false
                extraFrosting = false 
            }
        }
    }
    @Published var extraFrosting = false
    @Published var extraSprinkles = false
    
    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zipCode = ""
    
    @Published var internetConnection = false
    
    func checkInternet() {
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                self.internetConnection = true
            } else {
                print("No connection.")
                self.internetConnection = false
            }
            
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        
        print("Connection -> \(self.internetConnection)")
    }
    
    var hasValidAddress: Bool {
        if name.isEmpty || city.isEmpty || streetAddress.isEmpty || zipCode.isEmpty {
            return false
        }
        
        // to remove the white spaces in the beginning of each TextField
        if name.starts(with: " ") {
            name = name.trimmingCharacters(in: .whitespaces)
        }
        
        if city.starts(with: " ") {
            city = city.trimmingCharacters(in: .whitespaces)
        }
        
        if streetAddress.starts(with: " ") {
            streetAddress = streetAddress.trimmingCharacters(in: .whitespaces)
        }
        
        if zipCode.starts(with: " ") {
            zipCode = zipCode.trimmingCharacters(in: .whitespaces)
        }
        
        return true
    }
    
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += Double(type) / 2
        
        if extraFrosting {
            cost += Double(quantity)
        }
        
        if extraSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost 
    }
    
    // to avoid initializing data on the ContentView.swift
    init() { }
    
    // decoding an ObservableObject class
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        extraSprinkles = try container.decode(Bool.self, forKey: .extraSprinkles)
        
        name = try container.decode(String.self, forKey: .name)
        city = try container.decode(String.self, forKey: .city)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        zipCode = try container.decode(String.self, forKey: .zipCode)
    }
    
    // encoding an ObservableObject class
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(extraSprinkles, forKey: .extraSprinkles)
        
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zipCode, forKey: .zipCode)
    }
}
