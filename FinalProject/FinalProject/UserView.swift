//
//  UserView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/17/20.
//

import SwiftUI

struct UserView: View {
    @State var cart:Items = Items()
    
    func loadCart(){
        let url = URL(string: "https://reqres.in/api/hkp")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
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
                print("Invalid response from server")
            }
        }.resume()
    }
    
    var body: some View {
        TabView{
            MarketplaceView(cart: $cart)
                .tabItem{
                    Image(systemName: "card.badge.plus")
                    Text("Marketplace")
                }
            CheckoutView(cart: $cart)
                .tabItem{
                    Image(systemName: "creditcard")
                    Text("Checkout")
                }
        }.onAppear(perform: loadCart)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
