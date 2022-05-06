//
//  Home.swift
//  GasApp
//
//  Created by Saran Noyprecha on 5/5/2565 BE.
//

import SwiftUI
import FirebaseAuth

struct Home: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var showingMenuView = false
    @StateObject var HomeModel = HomeViewModel()
    @State private var showingCartScreen = false
    
    
    var body: some View {
        VStack {
            if viewModel.signedIn {
//            Text("GAS")
//                .font(Font.custom("Inter", size: 80))
//            Image("heroimage")
//                .padding()
//            Spacer()
//                
//                Button(action: {self.showingMenuView.toggle()}, label: {
//                    Text("MENU")
//                        .font(.body)
//                        .foregroundColor(.white)
//                        .padding()
//                        .clipShape(Rectangle())
//                        .frame(width: 600)
//                        .background(Color.black)
//                        .padding()
//                })
//                .sheet(isPresented: $showingMenuView, content: {
//                    Menu()
//                })
//                .padding()
//                Button(action: {viewModel.signOut()}, label: {
//                    Text("Sign Out")
//                        .font(.body)
//                        .foregroundColor(.white)
//                        .padding()
//                        .clipShape(Rectangle())
//                        .frame(width: 600)
//                        .background(Color.black)
//                    
//                })
                NavigationView{
                VStack {
        //            Spacer()
        //                .frame(height: 40)
                    HStack(spacing: 15) {
                        TextField("Search", text: $HomeModel.search)
                            .padding(.leading, 25)
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(Color("GasColor"))
                            
                        Spacer()
                            .frame(width: 25)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Divider()
                        .frame(width: 325)
                        .padding(.trailing, 60)
                        .padding(.bottom, 25)
                        .padding(.leading, 45)

                    ScrollView{
                        
                        VStack{
                            
                            ForEach(HomeModel.filtered) { item in
                                
                                itemView(item: item)
                                Button(action: {HomeModel.addToCart(item: item)}, label: {
                                    Image(systemName: item.isAdded ? "bag.badge.minus" : "bag.badge.plus")
                                        .renderingMode(.original)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color("GasColor"))
                                        .cornerRadius(8)
                                        .padding()
                                    
                                })
                            
                            }
                        }
                        
                    }
                    .navigationBarTitle("รุ่งโรจน์แก๊ส")
                    .navigationBarItems(leading: Button(action: {viewModel.signOut()}, label: {
                        Image(systemName: "person.circle")
                            .renderingMode(.original)
                            .foregroundColor(Color("GasColor"))
                        .font(.title)}), trailing: Button(action: {self.showingCartScreen.toggle()}, label: {
                            Image(systemName: "cart")
                                .renderingMode(.original)
                                .foregroundColor(Color("GasColor"))
                            .font(.title)}))
                    .sheet(isPresented: $showingCartScreen){
                        CartView(homeData: HomeModel)}
                    
                    //scroll view end
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
            
                
            }
            
            else {
               SigningIn()
            }
        }
        .onAppear{
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}


struct SigningIn: View {
    
    @State private var email = ""
    @State private var pass = ""
    @EnvironmentObject var viewModel: HomeViewModel
    @State private var shwoingRegisterView = false
    @State var color = Color.black.opacity(0.7)
    @State var visible = false
    @State var alert = UIAlertController(title: "Error", message: "Password Did not Match", preferredStyle: .alert)
    @State var showingAlert = false
    @State var goodshowingAlert = false
    @State var goodalert = UIAlertController(title: "Reset Password Successful", message: "The Link have been sent to email", preferredStyle: .alert)

    
    var body: some View {
        
        VStack {
            
            Image("heroimage")
                .padding(.top, 75)
            
            
            TextField("อีเมล", text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(self.email != "" ? Color(.gray) : self.color,lineWidth: 2))
            
            HStack(spacing: 15){
                VStack{
                    if self.visible {
                        TextField("รหัสผ่าน", text: self.$pass)
                            
                    }
                    else {
                        SecureField("รหัสผ่าน", text: self.$pass)
                            
                    }
                }
                Button(action: {
                    self.visible.toggle()
                }) {
                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.color)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).stroke(self.pass != "" ? Color(.gray) :
              self.color,lineWidth: 2))
            .padding(.top, 10
            )
            
            HStack{
                
                Spacer()
                
                Button(action: {
                    if self.email != "" {
                        
                        Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                            
                            if err != nil{
                                showingAlert.toggle()
                            }
                            goodshowingAlert.toggle()
                        }
                    }else{
                        showingAlert.toggle()
                    }
                   
                    
                }) {
                    Text("ลืมรหัสผ่าน")
                        .fontWeight(.bold)
                        .foregroundColor(Color(.gray))
                }
            }.padding(.top, 0)
            
            Button(action: {
                guard !email.isEmpty, !pass.isEmpty else{return}
                viewModel.signIn(email: email, pass: pass)}, label: {
                Text("เข้าสู่ระบบ")
                    .padding()
                    .foregroundColor(.white)
                    .clipShape(Rectangle())
                    .frame(width: 350)
                    .background(Color("GasColor"))
                    .cornerRadius(10)
            })
            
            Button(action: {self.shwoingRegisterView.toggle()}, label: {
                Text("สร้างบัญชีใหม่")
                    .font(.body)
                    .foregroundColor(Color("GasColor"))
                    .padding()
                    .clipShape(Rectangle())
                    .padding()
            })
            .sheet(isPresented: $shwoingRegisterView, content: {
                SigningUp()
            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Email Is Wrong"), dismissButton: .default(Text("OK")))}
            .alert(isPresented: $goodshowingAlert) {
                Alert(title: Text("Reset Password Successful"), message: Text("The Link have been sent to email"), dismissButton: .default(Text("OK")))}
            Spacer()
        } .padding(.horizontal, 25)
        
        
    }
    
}




struct SigningUp: View {
    
    @State private var email = ""
    @State private var pass = ""
    @EnvironmentObject var viewModel: HomeViewModel
    @State var visible = false
    @State var color = Color.black.opacity(0.7)
    @State var revisible = false
    @State private var repass = ""
    @State var showingAlert = false
    @State var alert = UIAlertController(title: "Error", message: "Password Did not Match", preferredStyle: .alert)


    
    
    var body: some View {
        VStack {
            Text("สร้างบัญชีใหม่")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding(.vertical, 55)
            

            
            TextField("อีเมล", text: $email)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(self.email != "" ? Color(.gray) : self.color,lineWidth: 2))
            
            
            
            HStack(spacing: 15){
                VStack{
                    if self.visible {
                        TextField("รหัสผ่าน", text: self.$pass)
                            
                    }
                    else {
                        SecureField("รหัสผ่าน", text: self.$pass)
                            
                    }
                }
                Button(action: {
                    self.visible.toggle()
                }) {
                    Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.color)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).stroke(self.pass != "" ? Color(.gray) :
              self.color,lineWidth: 2))
            .padding(.top, 10
            )
            
            HStack(spacing: 15){
                
                VStack{
                    if self.revisible{
                        TextField("ใส่รหัสผ่านอีกครั้ง", text: self.$repass)
                            .autocapitalization(.none)
                    } else{
                        SecureField("ใส่รหัสผ่านอีกครั้ง", text:self.$repass)
                            .autocapitalization(.none)
                    }
                }
                Button(action: {
                    self.revisible.toggle()
                }) {
                    Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(self.color)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).stroke(self.repass != "" ? Color(.gray) :
              self.color,lineWidth: 2))
            .padding(.top, 10)
            
//            SecureField("รหัสผ่าน", text: $pass)
//                .disableAutocorrection(true)
//                .autocapitalization(.none)
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 8).stroke(self.email != "" ? Color(.gray) : self.color,lineWidth: 2))
            
            
            Button(action: {
                guard !email.isEmpty, !pass.isEmpty, !repass.isEmpty else {return}
                if self.pass == self.repass {
                    viewModel.signUp(email: email, pass: pass)}
                else{
                    showingAlert.toggle()
                }
            }, label: {
                Text("Create Account")
                    .padding()
                    .foregroundColor(.white)
                    .clipShape(Rectangle())
                    .frame(width: 350)
                    .background(Color("GasColor"))
                    .cornerRadius(10)
            })
            .padding(.top, 35)
            Spacer()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Password Did Not Match"), dismissButton: .default(Text("OK")))}
                
        }.padding(.horizontal, 25)
    }
}













struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
