//
//  ContentView.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 15/11/22.
//

import SwiftUI
import CoreData
import PhotosUI

struct RegistrationView: View {
    @State var userName: String = ""
    @State var selectedImageData: Data?
    @State var photo: PhotosPickerItem?
    @ObservedObject var vm: RegistrationViewModel
    
    init(appModel: AppModel) {
        vm = RegistrationViewModel(appModel: appModel)
    }
    
    var body: some View {
        if vm.currentUser != nil {
            MainView(appModel: vm.appModel)
        } else {
            VStack {
                Text("Choose your photo:")
                PhotosPicker("some", selection: $photo)
                Text("Enter your name")
                TextField("Enter your username", text: $userName)
                Button(action: {
                    guard let selectedImageData = self.selectedImageData else { return }
                    let user: User = User(id: UUID(), name: userName, photo_data: selectedImageData, friends: [])
                    vm.appModel.networkManager.sendUser(user: user) {
                        vm.currentUser = user
                    }
                }) {
                    Text("Continue")
                }
            }
            .onChange(of: photo) { newValue in
                Task {
                    if let imageData = try? await newValue?.loadTransferable(type: Data.self), let uiimage = UIImage(data: imageData) {
                        self.selectedImageData = uiimage.jpegData(compressionQuality: 0.5)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(appModel: AppModel())
            .preferredColorScheme(.light)
    }
}
