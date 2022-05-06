//
//  item.swift
//  GasApp
//
//  Created by Saran Noyprecha on 6/5/2565 BE.
//

import SwiftUI

struct Item: Identifiable {
    var id: String
    var item_name: String
    var item_cost: NSNumber
    var item_details: String
    var item_image: String
    var isAdded: Bool = false

}

