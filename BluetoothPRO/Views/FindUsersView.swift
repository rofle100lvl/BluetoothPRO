import SwiftUI

struct FindUserView: View {
    let appModel: AppModel
    @State private var storedSize: CGSize = .zero

    
    init(appModel: AppModel) {
        self.appModel = appModel
        appModel.recieveManager.startSearch()
    }
    
    var body: some View {
        ZStack {
            PJRPulseButton()
                .background {
                    GeometryReader { proxy in
                        Color.clear.onAppear {
                            self.storedSize = proxy.size
                        }
                    }
                }
            RandomImagesView(storedSize: $storedSize)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Spacer()
                FoundUserView(appModel: self.appModel)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))

            }
        }
    }
}


