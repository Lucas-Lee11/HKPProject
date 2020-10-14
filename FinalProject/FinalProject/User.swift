//
//  User.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/13/20.
//

import Foundation

struct User:Codable,Identifiable{
    var id:UUID = UUID()
    var isAdmin:Bool = false
    var username:String
    var password:String
}

class UserWrapper:ObservableObject{
    @Published var user:User?
}
