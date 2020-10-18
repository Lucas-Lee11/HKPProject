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
    
    func clearCart(){
        let url = URL(string: "https://reqres.in/api/hkp")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            if let _ = try? JSONDecoder().decode(Message.self, from: data) {
                DispatchQueue.main.async {
                    self.cart = Items()
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    List{
                        ForEach(cart.items, id: \.name){item in
                            NavigationLink(destination: DetailView(item:item, cart: $cart)){
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
