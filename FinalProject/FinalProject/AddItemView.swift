//
//  AddItemView.swift
//  FinalProject
//
//  Created by Lucas Lee on 10/16/20.
//

import SwiftUI

struct AddItemView: View {
    @EnvironmentObject var currentToken:TokenWrapper
    @State var name = ""
    @State var description = ""
    @State var image:UIImage?
    @State var swiftImage:Image?
    @State var showingImagePicker = false
    @State var items:Items = Items()
    
    
    
    func loadImage(){
        guard let image = image else {return}
        swiftImage = Image(uiImage: image)
    }
    
    func addItem(){
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty && !description.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        //guard let image = image else {return}
        
        let newItem = Item(name: name, description: description/*, image: image*/)
        items.items.append(newItem)
        
    }
    
    func upload(){
        let toSend = ItemSend(token: currentToken.token!.token, items: items.items)
        guard let encoded = try? JSONEncoder().encode(toSend) else {
            print("Failed to encode items")
            return
        }
        
        let url = URL(string: "https://hkp-final.herokuapp.com/items/create")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        print(encoded)
        
        
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
                print("Invalid response from server on upload")
            }
        }.resume()
        self.items.items = [Item]()
    }
    
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Name of Item", text: $name)
                    TextField("Description", text: $description)
                }
                Section{
                    Button(action: {
                        self.showingImagePicker.toggle()
                    }){
                        Text("Tap to select or change picture")
                    }
                    .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                        ImagePicker(image: self.$image)
                    }
                    if swiftImage != nil{
                        swiftImage!.resizable().scaledToFit()
                    }
                }
                Section{
                    Button(action: {
                        self.addItem()
                    }){
                        Text("Confirm")
                    }
                }
                Section{
                    Text("To Add")
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
                        }
                    }
                }
            }
            .navigationBarTitle("Add Items")
            .navigationBarItems(leading: Button(action:{
                currentToken.token = nil
                currentToken.isAdmin = false
            }){
                Text("Logout")
            }, trailing: Button(action: {
                self.upload()
            }){
                Text("Upload")
            })
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
