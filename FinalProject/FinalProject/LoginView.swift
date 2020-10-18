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
    
    func verifyInput(){
        guard  !username.trimmingCharacters(in: .whitespaces).isEmpty && !password.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        let user = User(isAdmin: true, username: self.username, password: self.password)
        
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
                DispatchQueue.main.async {
                    self.currentUser.user = decoded
                }
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
                    Text("Enter your info").bold()
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
                
            }
            .navigationBarTitle("Login")
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Back")
            })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
