//
//  ContentView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/12/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var currentToken:TokenWrapper
    
    var body: some View {
        if (currentToken.token == nil){
            WelcomeView()
        }
        else{
            if(currentToken.isAdmin){
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
