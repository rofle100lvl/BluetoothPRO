import SwiftUI
import Combine

// MARK: - Strucutre for Circle
final class CircleData: ObservableObject, Identifiable {
    let id: Int
    var width: CGFloat
    @Published var isAnimating: Bool = false
    @Published var isFinished: Bool = false
    
    init(id: Int, width: CGFloat) {
        self.id = id
        self.width = width
        self.isAnimating = isAnimating
    }
}

struct DiscoverCircleView: View {
    @ObservedObject var circle: CircleData
    var animationTime: CGFloat
    var color: Color
    var scale: CGFloat
    
    var body: some View {
        Circle()
            .stroke(self.color, lineWidth: circle.isAnimating ? 1.0/scale : 1)
            .frame(width: circle.width, height: circle.width, alignment: .center)
            .scaleEffect(circle.isAnimating ? scale : 1)
            .opacity(circle.isAnimating ? 0 : 1)
            .animation(.easeInOut(duration: animationTime), value: circle.isAnimating)
            .onAppear {
                circle.isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
                    circle.isFinished = true
                }
            }
    }
}

struct PJRPulseButton: View {
    // MARK: - Properties
    @State private var circleArray: [CircleData]
    @State private var scale: CGFloat
    @State private var storedSize: CGSize = .zero
    var color: Color
    var startWidth: CGFloat
    var animationTime: CGFloat
    var timeBeetweenCircles: CGFloat
    let timer: Timer.TimerPublisher

    init(color: Color = Color.blue, startWidth: CGFloat = 40, timeBeetweenCircles: CGFloat = 2, animationTime: CGFloat = 10) {
        self.scale = 1
        self.color = color
        self.startWidth = startWidth
        self.timeBeetweenCircles = timeBeetweenCircles
        self.timer = Timer.publish(every: timeBeetweenCircles, on: .main, in: .common)
        self.animationTime = animationTime
        
        var circleData = [CircleData]()
        circleData.append(CircleData(id: Int.random(in: 0...100024), width: startWidth))
        self.circleArray = circleData
    }

    // MARK: - Body
    var body: some View {
        ZStack {
            Group {
                ForEach(circleArray) { cirlce in
                    DiscoverCircleView(circle: cirlce, animationTime: self.animationTime, color: self.color, scale: self.storedSize.height / cirlce.width)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        self.storedSize = proxy.size
                    }
            }
        }
        .onAppear {
            circleArray[0].isAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + animationTime) {
                circleArray[0].isFinished = true
            }
        }
        .onReceive(self.timer.autoconnect()) { _ in
            circleArray.removeAll { $0.isFinished }
            var arr = circleArray
            print(arr.count)
            let last = CircleData(id: Int.random(in: 0...100024), width: startWidth)
            arr.append(last)
            withAnimation(.easeInOut(duration: 0.5)) {
                circleArray = arr
            }
        }
    }
}

// MARK: - Preview
struct PulseButton_Previews: PreviewProvider {
    static var previews: some View {
        PJRPulseButton()
    }
}
