//
//  DetailView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/18/20.
//

import SwiftUI

struct DetailView: View {
    @State var item:Item
    @State var num:Int = 0
    @Binding var cart:Items
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Image(uiImage: item.getImage()).resizable().scaledToFit()
                    Text("\(item.description)")
                }
                Section{
                    Stepper("Quantity", value: $num, in: 0...100)
                    Button(action: {
                        self.cart.add(item, num: num)
                    }){
                        Text("Add to cart")
                    }
                }
                
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    @State static var cart:Items = Items()
    static var previews: some View {
        DetailView(item: Item(name: "Hello", description: "asdf", image: UIImage(systemName: "circle.fill")!), cart: DetailView_Previews.$cart)
    }
}
