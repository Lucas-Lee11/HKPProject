//
//  Marketplace.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/17/20.
//

import SwiftUI

struct MarketplaceView: View {
    @EnvironmentObject var currentToken:TokenWrapper
    @Binding var cart:Items
    @State var items:Items = Items()
    
    func loadData(){
        
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
                    self.items = decoded
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
    
    func saveCart(){
        let newCart:CartSend = CartSend(token: self.currentToken.token!.token, cart: cart.items)
        
        guard let encoded = try? JSONEncoder().encode(newCart) else {
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
            if let decoded = try? JSONDecoder().decode(Message.self, from: data) {
                DispatchQueue.main.async {
                    print(decoded.message)
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
        
    }
    
    var body: some View {
        NavigationView{
            Form{
                List{
                    ForEach(items.items, id: \.name){item in
                        NavigationLink(destination: DetailView(item:item, cart: $cart)){
                            Text("\(item.name)").bold()
                        }
                    }
                }
                .onAppear(perform: loadData)
            }
            .navigationBarTitle("Current Items")
            .navigationBarItems(leading: Button(action:{
                currentToken.token = nil
            }){
                Text("Logout")
            }, trailing: Button("Save"){
                saveCart()
            })
        }
    }
}

struct MarketplaceView_Previews: PreviewProvider {
    @State static var cart:Items = Items()
    static var previews: some View {
        MarketplaceView(cart: MarketplaceView_Previews.$cart)
    }
}
