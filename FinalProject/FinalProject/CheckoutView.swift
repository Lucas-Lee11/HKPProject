//
//  CheckoutView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/17/20.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var currentToken:TokenWrapper
    @Binding var cart:Items
    @State var showingAlert:Bool = false
    
    func saveCart(){
        let newCart = ItemSend(token: self.currentToken.token!.token, items: cart.items)
        
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
    
    func clearCart(){
        let newCart = ItemSend(token: self.currentToken.token!.token, items: cart.items)
        
        guard let encoded = try? JSONEncoder().encode(newCart) else {
            return
        }
        
        let url = URL(string: "https://hkp-final.herokuapp.com/checkout")!
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
        self.cart = Items()
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    List{
                        ForEach(cart.items, id: \.name){item in
                            NavigationLink(destination: DetailView(item:item, num: item.quantity , cart: $cart)){
                                Text("\(item.name)").bold()
                            }
                        }
                    }
                }
                Section{
                    Button(action: {
                        self.clearCart()
                    }){
                        Text("Proceed to Payment")
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Thanks for Shopping!"), message: Text("Succesfully checked out"), dismissButton: .default(Text("OK")))
                    }
                }
                
            }
            .navigationBarTitle("Checkout")
            .navigationBarItems(leading: Button(action:{
                currentToken.token = nil
            }){
                Text("Logout")
            })
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    @State static var cart:Items = Items()
    static var previews: some View {
        CheckoutView(cart: CheckoutView_Previews.$cart)
    }
}
