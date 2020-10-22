//
//  ListView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/16/20.
//

import SwiftUI



struct ListView: View {
    @EnvironmentObject var currentToken:TokenWrapper
    @State var items:Items = Items()
    @State var toDelete:Items = Items()
    
   
    func loadData(){
        print("Running load Data")
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
    
    func deleteItems(){
        guard let encoded = try? JSONEncoder().encode(toDelete) else {
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
            if let decoded = try? JSONDecoder().decode(Message.self, from: data) {
                DispatchQueue.main.async {
                    print(decoded)
                }
            } else {
                print("Invalid response from server for ListView")
            }
        }.resume()
        self.toDelete.items = [Item]()
        loadData()
    }
    
    var body: some View {
        NavigationView{
            Form{
                List{
                    ForEach(items.items, id: \.name){item in
                        HStack{
                            //Image(uiImage: item.getImage()).resizable().scaledToFit()
                            //Spacer()
                            VStack{
                                Text("\(item.name)").bold()
                                Text("\(item.description)")
                            }
                        }
                    }.onDelete{range in
                        self.toDelete.items += items.items[range.rangeView.startIndex...range.rangeView.endIndex]
                        deleteItems()
                    }
                }
            }
            .navigationBarTitle("Current Items")
            .navigationBarItems(leading: Button(action:{
                currentToken.token = nil
                currentToken.isAdmin = false
            }){
                Text("Logout")
            }, trailing: Button(action: {
                loadData()
            }){
                Text("Reload")
            })
        }.onAppear{
            loadData()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
