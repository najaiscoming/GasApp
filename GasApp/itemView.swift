//
//  itemView.swift
//  GasApp
//
//  Created by Saran Noyprecha on 6/5/2565 BE.
//

import SwiftUI
import SDWebImageSwiftUI

struct itemView: View {
    
    @StateObject var HomeModel = HomeViewModel()
    var item: Item
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                WebImage(url: URL(string: item.item_image))
                    .resizable()
                    .cornerRadius(20)
                    .frame(width: 360)
                    .scaledToFit()
                
                VStack(alignment: .leading) {
                    Text(item.item_name)
                        .bold()
                    
                    Text("฿\(item.item_cost)")
                        .font(.caption)
                }
                .padding()
                .frame(width: 360, alignment: .leading)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
            .frame(width: 360, height: 250)
            .shadow(radius: 3)
            
            
//            Button(action: {HomeModel.addToCart(item: item)}, label: {
//                Image(systemName: item.isAdded ? "bag.badge.minus" : "bag.badge.plus")
//                    .renderingMode(.original)
//                    .padding(10)
//                    .foregroundColor(.white)
//                    .background(.black)
//                    .cornerRadius(50)
//                    .padding()
//            })
            
        
        }
}
}



//struct itemView_Previews: PreviewProvider {
//    static var previews: some View {
//        itemView()
//    }
//}

//VStack{
//
//    WebImage(url: URL(string: item.item_image))
//        .resizable()
//        .frame(width: 200, height: 300)
//        .aspectRatio(contentMode: .fill)
//
//    VStack(spacing: 8) {
//        Text(item.item_name)
//            .font(.body)
//            .fontWeight(.medium)
//            .foregroundColor(.black)
//        HStack{
//            Text("฿\(item.item_cost)")
//                .font(.body)
//                .foregroundColor(.black)
//                .fontWeight(.light)
//            //Spacer()
//        }
//}
//}
//
