//
//  LoginView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/13/20.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var currentUser:UserWrapper
    @State var username:String = ""
    @State var password:String = ""
    
    var validInput:Bool{
        return !username.trimmingCharacters(in: .whitespaces).isEmpty && !password.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func verifyInput(){
        guard validInput else {return}
        currentUser.user = User(username: self.username, password: self.password)
        self.presentationMode.wrappedValue.dismiss()
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
                }
                Section{
                    Button("Login"){
                        verifyInput()
                    }
                }
                
            }.navigationBarTitle("Login")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
