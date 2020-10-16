//
//  AdminView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/15/20.
//

import SwiftUI

struct AdminView: View {
    
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
        Text("Hello World").onAppear(perform:loadData)
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
