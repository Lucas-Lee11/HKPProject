//
//  DetailView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/18/20.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var item:Item
    @State var num:Int = 0
    @Binding var cart:Items
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    //Image(uiImage: item.getImage()).resizable().scaledToFit()
                    Text("\(item.description)")
                }
                Section{
                    Stepper("Quantity", value: $num, in: 0...100)
                    Text("Number: \(num)")
                    Button(action: {
                        self.cart.add(item, num: num)
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("Add to cart")
                    }
                }
                
            }
        }
    }
}
