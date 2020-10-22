//
//  LoginView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/13/20.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var currentToken:TokenWrapper
    @State var username:String = ""
    @State var password:String = ""
    @State var user:User?
    @State var errorMessage:String = ""
    @State var errorTitle:String = ""
    @State var showingAlert:Bool = false
    @Binding var nextToken:Token
    
    func verifyInput() -> Bool{
        guard  !username.trimmingCharacters(in: .whitespaces).isEmpty && !password.trimmingCharacters(in: .whitespaces).isEmpty else {return false}
        user = User(username: self.username, password: self.password)
        return true
    }
    
    func checkAccount(){
        guard verifyInput() else {
            self.errorMessage = "Enter a username and password"
            self.errorTitle = "Error in logging in"
            self.showingAlert.toggle()
            return
        }
        guard let encoded = try? JSONEncoder().encode(self.user) else {
            self.errorMessage = "Failed to encode user"
            self.errorTitle = "Error in logging in"
            self.showingAlert.toggle()
            return
        }
        
        let url = URL(string: "https://hkp-final.herokuapp.com/users/login")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data in response: \(error?.localizedDescription ?? "Unknown error")."
                    self.errorTitle = "Error in logging in"
                    self.showingAlert.toggle()
                }
                return
            }
            if let decoded = try? JSONDecoder().decode(Token.self, from: data) {
                DispatchQueue.main.sync {
                    self.nextToken = decoded
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            else if let decoded = try? JSONDecoder().decode(Message.self, from: data){
                DispatchQueue.main.async{
                    self.errorMessage = "\(decoded.message)"
                    self.errorTitle = "Error in logging in"
                    self.showingAlert.toggle()
                }
               return
            }
            else {
                DispatchQueue.main.async{
                    self.errorMessage = "Invalid response from server"
                    self.errorTitle = "Error in logging in"
                    self.showingAlert.toggle()
                }
            }
        }.resume()
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
                        checkAccount()
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
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
