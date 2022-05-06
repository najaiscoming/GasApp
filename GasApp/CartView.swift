//
//  CartView.swift
//  GasApp
//
//  Created by Saran Noyprecha on 5/5/2565 BE.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartView: View {
    @ObservedObject var homeData: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
       NavigationView {
        VStack {
            HStack(spacing : 20){
                Text("My Cart")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding()
            
            ScrollView {
                LazyVStack(spacing: 0){
                    ForEach(homeData.cartItems){
                        cart in
                        
                        HStack(spacing : 15){
                            WebImage(url: URL(string: cart.item.item_image))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .cornerRadius(15)
                            VStack(alignment: .leading, spacing: 10) {
                                Text(cart.item.item_name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                HStack(spacing: 15){
                                    Text(homeData.getPrice(value: Float(truncating: cart.item.item_cost)))
                                        .font(.title2)
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                    Spacer(minLength: 0)
                                    
                                    Button(action: {
                                        if cart.quantity > 1 {
                                            homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity -= 1
                                        }}) {
                                        Image(systemName: "minus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(Color("GasColor"))}
                                    Text("\(cart.quantity)")
                                        .fontWeight(.heavy)
                                        .foregroundColor(.black)
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                        .background(Color.black.opacity(0.06))
                                    
                                    Button(action: {homeData.cartItems[homeData.getIndex(item: cart.item, isCartIndex: true)].quantity += 1})  {
                                        Image(systemName: "plus")
                                            .font(.system(size: 16, weight: .heavy))
                                            .foregroundColor(Color("GasColor"))
                                    }
                                }
                            }
                        }
                        .padding()
                        .contentShape(RoundedRectangle(cornerRadius: 15))
                        Button(action: {
                            let index = homeData.getIndex(item: cart.item, isCartIndex: true)
                            let itemIndex = homeData.getIndex(item: cart.item, isCartIndex: false)
                            let filterIndex = homeData.filtered.firstIndex { (item1) -> Bool in
                                return cart.item.id == item1.id} ?? 0
                            homeData.items[itemIndex].isAdded = false
                            homeData.filtered[filterIndex].isAdded = false
                            homeData.cartItems.remove(at: index)})  {
                            Image(systemName: "trash")
                                .renderingMode(.original)
                        }
                    }
                }
                
                VStack {
                    HStack {
                        Text("Total")
                            .fontWeight(.heavy)
                            .foregroundColor(.gray)
                        Spacer()
                        
                        Text(homeData.calculateTotalPrice())
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                    }
                    .padding([.top, .horizontal])
                    
                    
                    Button(action:
                        homeData.updateOrder) {
                            Text(homeData.ordered ? "Cancel Order" : "Check Out")
                                .font(.title2)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: 300)
                                .background(Color("GasColor"))
                                .cornerRadius(15)
                    }
                    
                }
                
                
            }
            
            Text("Enter Your Address")
            Form {
                TextField("enter your address", text: $homeData.field)
            }
   
        }
        .ignoresSafeArea()
                    .navigationBarItems(leading: Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
                     Image(systemName: "xmark")
                }), trailing: EditButton())
        
        }
      
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(homeData: HomeViewModel())
    }
}
