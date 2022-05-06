//
//  Menu.swift
//  GasApp
//
//  Created by Saran Noyprecha on 5/5/2565 BE.
//

import SwiftUI


struct Menu: View {
    @StateObject var HomeModel = HomeViewModel()
    @State private var showingCartScreen = false
    
    let columns = [
    
        GridItem(.flexible()),
        GridItem(.flexible())
    
    ]
    
    var body: some View {
        NavigationView{
        VStack {
//            Spacer()
//                .frame(height: 40)
            HStack(spacing: 15) {
                TextField("Search", text: $HomeModel.search)
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.gray)
                Spacer()
                    .frame(width: 40)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            Divider()
                .frame(width: 325)
                .padding(.trailing, 60)
          
            ScrollView{
                
                VStack{
                    ForEach(HomeModel.filtered) { item in
                        
                        itemView(item: item)
                        Button(action: {HomeModel.addToCart(item: item)}, label: {
                            Image(systemName: item.isAdded ? "bag.badge.minus" : "bag.badge.plus")
                                .renderingMode(.original)
                        })
                    
                    }
                }
                
            }
            .navigationBarTitle("รุ่งโรจน์แก๊ส")
            .navigationBarItems(trailing: Button(action: {self.showingCartScreen.toggle()}, label: {
                Image(systemName: "bag.fill")
                    .renderingMode(.original)
                    .font(.title)}))
            .sheet(isPresented: $showingCartScreen){
                CartView(homeData: HomeModel)}
            
            //MARK:- scroll view end
            }
       // .ignoresSafeArea()
        //MARK:- VStack end
        .onAppear(perform: {
            self.HomeModel.fetchData()
        })
            
            
        .onChange(of: HomeModel.search, perform: { value in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                if value == HomeModel.search && HomeModel.search != "" {
                    //search the data
                    HomeModel.filterData()
                }
            }
            if HomeModel.search == "" {
                //we need to reset all data
                
                withAnimation(.linear){
                    HomeModel.filtered = HomeModel.items }
                
            }
            
        })
            
        }
        //MARK:- navigation view end
        
      
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
