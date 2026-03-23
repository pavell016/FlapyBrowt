import SwiftUI
import SpriteKit

class ViewModel: ObservableObject {
    @Published var score: Int = 0
        @Published var isGameOver: Bool = false
        
        let pipeGap: CGFloat = 160.0
        let spawnRate: TimeInterval = 2.0
        
        func resetGame() {
            score = 0
            isGameOver = false
        }
}
