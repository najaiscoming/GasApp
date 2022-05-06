//
//  HomeModel.swift
//  GasApp
//
//  Created by Saran Noyprecha on 5/5/2565 BE.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var search = ""
    
    //MARK:- Functions for Authentication
    
    
    let yoyo = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        
        return yoyo.currentUser != nil
    }
    
    func signIn(email: String, pass: String) {
        
        yoyo.signIn(withEmail: email, password: pass) { [weak self] result, error in
            
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
            
        }
    }
    
    
    
    func signUp(email: String, pass: String) {
        
        yoyo.createUser(withEmail: email, password: pass) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            //success
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
            
        }
        
    }
    
    
    func signOut() {
        try? yoyo.signOut()
        
        self.signedIn = false
        
    }
    
    //fetch Data
    
    @Published var items: [Item] = []
    
    func fetchData() {
        
        let db = Firestore.firestore()
        db.collection("Items").getDocuments {
            (snap, err) in
            guard let itemData = snap else{return}
            self.items = itemData.documents.compactMap({
                (doc) -> Item? in
                let id = doc.documentID
                let name = doc.get("item_name") as? String ?? ""
                let cost = doc.get("item_cost") as! NSNumber
                let image = doc.get("item_image") as? String ?? ""
                let details = doc.get("item_details") as? String ?? ""
                
                return Item(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image)
                
            })
            
            
            self.filtered = self.items
        }
        
        
    }
    
    
    //search bar
    
    
    @Published var filtered: [Item] = []
    
    func filterData() {
        
        self.filtered = self.items.filter {
            return
                $0.item_name.lowercased().contains(self.search.lowercased())
        }
        
        
    }
    
    
    //cart
    
    @Published var cartItems: [Cart] = []
    
    
    func addToCart(item: Item) {
        
        self.items[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        self.filtered[getIndex(item: item, isCartIndex: false )].isAdded = !item.isAdded
        if item.isAdded {
            
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            return
            
        }
        self.cartItems.append(Cart(item: item, quantity: 1))}
    
    //index func
    
    func getIndex(item: Item, isCartIndex: Bool) -> Int {
        
        let index = self.items.firstIndex { (item1) -> Bool in
            
            return item.id == item1.id
        } ?? 0
        let cartIndex = self.cartItems.firstIndex {
            (item1) -> Bool in
            return item.id == item1.item.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
        
    }
    
    //cart view
    
    
    func calculateTotalPrice() -> String {
    
    var price: Float = 0
    
    cartItems.forEach { (item) in
    
    price += Float(item.quantity) * Float(truncating: item.item.item_cost)
    }
    return getPrice(value: price)
    }
    
    func getPrice(value: Float) -> String {
        
        let format = NumberFormatter()
        format.numberStyle = .currency
        return format.string(from: NSNumber(value: value)) ?? ""
        
    }
    
    @Published var ordered = false
    
    @Published var field = ""
    
    func updateOrder() {
        
        let db = Firestore.firestore()
        
        if ordered {
            ordered = false
            
            db.collection("Users").document(Auth.auth().currentUser!.uid).delete {
                (error) in
                if error != nil {
                    self.ordered = true
                }
            }
            return
        }
        var details: [[String: Any]] = []
        cartItems.forEach { (cart) in
            details.append([
            
                "item_name": cart.item.item_name,
                "item_quantity": cart.quantity,
                "item_cost": cart.item.item_cost])
        }
        ordered = true
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
        
            "ordered_items": details,
            "total_cost": calculateTotalPrice(),
            "Address": field])
        
        {
            (error) in
            if error != nil {
                self.ordered = false
                return}
            print("success")
        }
        
        
        
    }
  
    
}

