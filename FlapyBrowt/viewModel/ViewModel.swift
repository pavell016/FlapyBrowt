import SwiftUI

class ViewModel: ObservableObject {
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    @Published var gameID: UUID = UUID()
    
    let pipeGap: CGFloat = 170.0
    let spawnRate: TimeInterval = 1.8
    
    func resetGame() {
        score = 0
        isGameOver = false
        gameID = UUID() // Esto regenera la vista del juego
    }
    
    func addScore() {
        score += 1
    }
    
    func gameOver() {
        isGameOver = true
    }
}
