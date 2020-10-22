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
    @State var errorMessage:String = ""
    @State var errorTitle:String = ""
    @State var adminStatus:Bool = false
    @State var showingAlert:Bool = false
    
    func verifyInput() -> Bool{
        guard  !username.trimmingCharacters(in: .whitespaces).isEmpty && !password.trimmingCharacters(in: .whitespaces).isEmpty else {return false}
        newUser = User(username: self.username, password: self.password, isAdmin: self.adminStatus)
        return true
    }
    
    func createAccount(){
        guard verifyInput() else {
            self.errorMessage = "Enter a username and password"
            self.errorTitle = "Error in creating account"
            self.showingAlert.toggle()
            return
        }
        guard let encoded = try? JSONEncoder().encode(newUser) else {
            self.errorMessage = "Failed to encode"
            self.errorTitle = "Error in creating account"
            self.showingAlert.toggle()
            print("Failed to encode user")
            return
        }
        
        let url = URL(string: "https://hkp-final.herokuapp.com/users/register")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data in response: \(error?.localizedDescription ?? "Unknown error")."
                    self.errorTitle = "Error in creating account"
                    self.showingAlert.toggle()
                }
                return
            }
            if let decoded = try? JSONDecoder().decode(Token.self, from: data) {
                print(decoded.token)
                self.presentationMode.wrappedValue.dismiss()
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid response from server"
                    self.errorTitle = "Error in creating account"
                    self.showingAlert.toggle()
                }
                return
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
                    Toggle(isOn: $adminStatus){
                        Text("Admin Access")
                    }
                }
                Section{
                    Button("Create"){
                        createAccount()
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
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
