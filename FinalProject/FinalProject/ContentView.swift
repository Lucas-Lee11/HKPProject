//
//  ContentView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/12/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var currentToken:TokenWrapper
    @State var showingLogin:Bool = false
    @State var showingCreate:Bool = false
    @State var loadAdmin:Bool = false
    
    var body: some View {
        if (currentToken.token == nil){
            NavigationView{
                VStack{
                    Button(action: {
                        self.showingLogin.toggle()
                    }){
                        Text("Login")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    }
                    
                    .sheet(isPresented: $showingLogin){
                        LoginView()
                        
                    }
                    Button(action: {
                        self.showingCreate.toggle()
                    }){
                        Text("Create Account")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .clipShape(Capsule())
                    }
                    .sheet(isPresented: $showingCreate){
                        CreateAccountView()
                    }
                }.navigationBarTitle("Welcome")
                
            }
        }
        else{
            if(currentToken.isAdmin()){
                AdminView()
            }
            else{
                UserView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
