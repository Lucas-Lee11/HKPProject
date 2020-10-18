//
//  ListView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/16/20.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var currentUser:UserWrapper
    @State var items:[Item] = [Item]()
    
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
                    self.items = decoded.items
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
                    Text("Hello")
                    Text("World")
                }
            }
            .navigationBarTitle("Current Items")
            .navigationBarItems(leading: Button(action:{
                currentUser.user = nil
            }){
                Text("Logout")
            })
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
