//
//  AdminView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/15/20.
//

import SwiftUI

struct AdminView: View {
    
    var body: some View {
        TabView{
            ListView()
                .tabItem{
                    Image(systemName: "text.justify")
                    Text("Current Stock")
                }
            AddItemView()
                .tabItem{
                    Image(systemName: "text.badge.plus")
                    Text("Add Item")
                }
        }
        
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
