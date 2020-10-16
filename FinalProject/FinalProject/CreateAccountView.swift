//
//  CreateAccountView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/13/20.
//

import SwiftUI

struct CreateAccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var newUser:User?
    @State var username:String = ""
    @State var password:String = ""
    @State var adminStatus:Bool = false
    
    func verifyInput() -> Bool{
        guard  !username.trimmingCharacters(in: .whitespaces).isEmpty && !password.trimmingCharacters(in: .whitespaces).isEmpty else {return false}
        newUser = User(isAdmin: self.adminStatus, username: self.username, password: self.password)
        return true
    }
    
    func createAccount(){
        guard verifyInput() else {return}
        guard let user = newUser else {return}
        guard let encoded = try? JSONEncoder().encode(user) else {
            print("Failed to encode user")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/hkp")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decoded = try? JSONDecoder().decode(User.self, from: data) {
                print(decoded.username)
            } else {
                print("Invalid response from server")
            }
        }.resume()
        
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
                    Toggle(isOn: $adminStatus){
                        Text("Admin Access")
                    }
                }
                Section{
                    Button("Create"){
                        createAccount()
                    }
                }
                
            }
            .navigationBarTitle("Create Account")
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Back")
            })

                
        }
    }
}

struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
