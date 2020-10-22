//
//  User.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/13/20.
//

import Foundation

struct User:Codable{
    var username:String
    var password:String
    var isAdmin:Bool = false
}

struct Token:Codable{
    var token:String
}

struct AdminConfirm:Codable{
    var message:Bool
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
    @Published var isAdmin:Bool = false
    
    func setAdmin(){
        print(token?.token ?? "no token")
        guard let encoded = try? JSONEncoder().encode(token) else {
            print("Failed to encode items or no token")
            return
        }
        
        let url = URL(string: "https://hkp-final.herokuapp.com/isAdmin")!
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
                DispatchQueue.main.sync {
                    print(decoded.message)
                    self.isAdmin = decoded.message
                }
            } else {
                print("Invalid response from server for isAdmin")
            }
        }.resume()
    }
}
