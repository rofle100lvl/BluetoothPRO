//
//  RandomImagesView.swift
//  BluetoothPRO
//
//  Created by Roman Gorbenko on 22/11/22.
//

import Foundation
import SwiftUI

struct RandomImagesView: View {
    @State var currentImages = [ImageDescribe]()
    @Binding var storedSize: CGSize
    let staticArrayWithImageNames: [String] = [Const.firstImage, Const.secondImage, Const.thirdImage, Const.fourthImage, Const.fifthImage, Const.sixthImage]
    
    var body: some View {
        Group {
            if currentImages.count > 0 {
                ForEach(currentImages, id: \.self) { image in
                    Group {
                        Image(image.name)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(20)
                            .offset(x: image.position.x, y: image.position.y)
                    }
                }
            } else {
                EmptyView()
            }
        }
        .onReceive(Timer.publish(every: 3, on: .main, in: .common).autoconnect()) { _ in
            var imagesOnScreen = currentImages
            guard let randomImageName = staticArrayWithImageNames.randomElement() else { return }
            imagesOnScreen.append(ImageDescribe(name: randomImageName, position: ImageDescribe.OffsetPoint(x: CGFloat.random(in: -self.storedSize.width/6...self.storedSize.width/6), y: CGFloat.random(in: -self.storedSize.height/6...self.storedSize.height/6))))
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

extension RandomImagesView {
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
    
}
