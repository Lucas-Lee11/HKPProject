//
//  User.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/13/20.
//

import Foundation

struct User:Codable{
    var isAdmin:Bool = false
    var username:String
    var password:String
}

struct Token:Codable{
    var token:String
}

struct AdminConfirm:Codable{
    var isAdmin:Bool
}

struct Message:Codable{
    var message:String
}

//
//class UserWrapper:ObservableObject{
//    @Published var user:User?
//}

class TokenWrapper:ObservableObject{
    @Published var token:Token?
    
    func isAdmin() -> Bool{
        var out = false
        guard let encoded = try? JSONEncoder().encode(token) else {
            print("Failed to encode items or no token")
            return false
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
            if let decoded = try? JSONDecoder().decode(AdminConfirm.self, from: data) {
                DispatchQueue.main.async {
                    out = decoded.isAdmin
                }
            } else {
                print("Invalid response from server")
            }
        }.resume()
        
        return out
    }
}
