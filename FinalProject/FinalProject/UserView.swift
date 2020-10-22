//
//  UserView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/17/20.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var currentToken:TokenWrapper
    @State var cart:Items = Items()
    
    func loadCart(){
        guard let encoded = try? JSONEncoder().encode(currentToken.token) else {
            print("Failed to encode items or no token")
            return
        }
        
        let url = URL(string: "https://hkp-final.herokuapp.com/cart")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let decoded = try? JSONDecoder().decode(Items.self, from: data) {
                DispatchQueue.main.async {
                    self.cart = decoded
                }
            } else {
                print("Invalid response from server on loadCart")
            }
        }.resume()
    }
    
    var body: some View {
        TabView{
            MarketplaceView(cart: $cart)
                .tabItem{
                    Image(systemName: "cart.badge.plus")
                    Text("Marketplace")
                }
            CheckoutView(cart: $cart)
                .tabItem{
                    Image(systemName: "creditcard")
                    Text("Checkout")
                }
                .onAppear(perform: loadCart)
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
