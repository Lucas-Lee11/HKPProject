//
//  Item.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/15/20.
//

import UIKit
import SwiftUI
import Foundation


struct Item:Codable{
    var name:String
    var description:String
    var image:Data
    var quantity:Int = 0
    
    init(name:String, description:String, image:UIImage){
        self.name = name
        self.description = description
        self.image = image.jpegData(compressionQuality: 1.0)!
    }
    
    func getImage() -> UIImage{
        return UIImage(data: self.image)!
    }
}

struct Items:Codable{
    var items:[Item] = [Item]()
}
