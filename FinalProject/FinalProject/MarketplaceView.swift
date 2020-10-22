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
        guard let encoded = try? JSONEncoder().encode(currentToken.token) else {
            print("Failed to encode items")
            return
        }
        
        let url = URL(string: "https://hkp-final.herokuapp.com/items/list")!
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
                    self.items = decoded
                }
            } else {
                print("Invalid response from server for ListView")
            }
        }.resume()
    }
    
    func saveCart(){
        let newCart:ItemSend = ItemSend(token: self.currentToken.token!.token, items: cart.items)
        
        guard let encoded = try? JSONEncoder().encode(newCart) else {
            return
        }
        
        let url = URL(string: "https://hkp-final.herokuapp.com/cart/create")!
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
                print("Invalid response from server on saveCart")
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
            }
            .navigationBarTitle("Current Items")
            .navigationBarItems(leading: Button(action:{
                currentToken.token = nil
            }){
                Text("Logout")
            }, trailing: Button("Save"){
                saveCart()
            })
        }.onAppear(perform: loadData)
    }
}

struct MarketplaceView_Previews: PreviewProvider {
    @State static var cart:Items = Items()
    static var previews: some View {
        MarketplaceView(cart: MarketplaceView_Previews.$cart)
    }
}
