//
//  CreateAccountView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/13/20.
//

import SwiftUI

struct CreateAccountView: View {
    @State var newUser:User?
    @State var username:String = ""
    @State var password:String = ""
    @State var adminStatus:Bool = false
    
    var validInput:Bool{
        return !username.trimmingCharacters(in: .whitespaces).isEmpty && !password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func verifyInput(){
        guard validInput else {return}
        newUser = User(isAdmin: self.adminStatus, username: self.username, password: self.password)
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Text("Enter your info").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    HStack{
                        Text("Username:")
                        Spacer()
                        TextField("Enter Username", text: $username)
                    }
                    HStack{
                        Text("Password:")
                        Spacer()
                        TextField("Enter Password", text: $password)
                    }
                    Toggle(isOn: $adminStatus){
                        Text("Admin Access")
                    }
                }
                Section{
                    Button("Create"){

                    }
                }
                
            }.navigationBarTitle("Create Account")
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
