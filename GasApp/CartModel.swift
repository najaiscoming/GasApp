//
//  CartModel.swift
//  GasApp
//
//  Created by Saran Noyprecha on 6/5/2565 BE.
//

import SwiftUI


struct Cart: Identifiable {
    
    var id = UUID().uuidString
    var item: Item
    var quantity: Int
    
    
}
