import SwiftUI

struct FindUserView: View {
    let appModel: AppModel
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
                    Group {
                        Image(image.name)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .cornerRadius(20)
                            .offset(x: image.position.x, y: image.position.y)
                    }
                }
            }
            VStack {
                Spacer()
                FoundUserView(appModel: self.appModel)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))

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

extension FindUserView {
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
