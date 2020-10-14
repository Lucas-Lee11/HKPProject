//
//  ContentView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/12/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var currentUser:UserWrapper
    @State var showingLogin:Bool = false
    @State var showingCreate:Bool = false
    
    var body: some View {
        if (currentUser.user == nil){
            Button(action: {
                self.showingLogin.toggle()
            }){Text("Login")}
            .sheet(isPresented: $showingLogin){LoginView()}
            Button(action: {
                self.showingCreate.toggle()
            }){Text("Create Account")}
            .sheet(isPresented: $showingCreate){CreateAccountView()}
        }
        else{
            Text("\(currentUser.user!.username)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
