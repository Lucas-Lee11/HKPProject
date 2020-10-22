//
//  WelcomeView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/21/20.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var currentToken:TokenWrapper
    @State var showingLogin:Bool = false
    @State var showingCreate:Bool = false
    @State var loadAdmin:Bool = false
    @State var nextToken:Token = Token(token:"")
    
    var body: some View {
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
                    LoginView(nextToken: $nextToken)
                        .onDisappear {
                            if nextToken.token != ""{
                                currentToken.token = Token(token: nextToken.token)
                                nextToken.token = ""
                                currentToken.setAdmin()
                            }
                        }
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
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
