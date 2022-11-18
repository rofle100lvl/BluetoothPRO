//
//  ContentView.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 15/11/22.
//

import SwiftUI
import CoreData

struct SomeOtherView: View {
    let manager = BroadCastManager()
    var body: some View {
        Text("SendView")
    }
}

struct ContentView: View {
    private enum Const {
        static let firstImage = "First"
        static let secondImage = "Second"
        static let thirdImage = "Third"
        static let fourthImage = "Fourth"
        static let fifthImage = "Fifth"
        static let sixthImage = "Sixth"
    }
    
    struct ImageDescribe: Hashable {
        struct OffsetPoint: Hashable {
            let x: CGFloat
            let y: CGFloat
        }
        let name: String
        let position: OffsetPoint
    }
    
    @ObservedObject var recieveManager = RecieveManager()
    @State var currentImages = [ImageDescribe]()
    @State private var storedSize: CGSize = .zero
    let staticArrayWithImageNames: [String] = [Const.firstImage, Const.secondImage, Const.thirdImage, Const.fourthImage, Const.fifthImage, Const.sixthImage]
    
    var body: some View {
        ZStack {
            PJRPulseButton()
                .background {
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                self.storedSize = proxy.size
                            }
                    }
                }
            if currentImages.count > 0 {
                ForEach(currentImages, id: \.self) { image in
                    Image(image.name)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                        .offset(x: image.position.x, y: image.position.y)
                }
            }
        }
        .onReceive(Timer.publish(every: 5, on: .main, in: .common).autoconnect()) { _ in
            var imagesOnScreen = currentImages
            guard let randomImageName = staticArrayWithImageNames.randomElement() else { return }
            imagesOnScreen.append(ImageDescribe(name: randomImageName, position: ImageDescribe.OffsetPoint(x: CGFloat.random(in: -self.storedSize.width/4...self.storedSize.width/4), y: CGFloat.random(in: -self.storedSize.height/4...self.storedSize.height/4))))
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                withAnimation(.easeInOut(duration: 1)) {
                    let _ = self.currentImages.removeFirst()
                }
            }
            withAnimation(.easeInOut(duration: 1)) {
                self.currentImages = imagesOnScreen
            }
        }
    }
}

struct ContenftView: View {
    @ObservedObject var recieveManager = RecieveManager()
    
    var body: some View {
        NavigationView {
            
            VStack {
                NavigationLink(destination: LazyView(SomeOtherView())) {
                    Text("To send View")
                }
                Text("RecieveView")
                if let user = recieveManager.user {
                    Text(user.name)
                    Text(user.userToken)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
