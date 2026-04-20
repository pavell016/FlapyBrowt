import SwiftUI

enum Difficulty {
    case easy, hard
}

class ViewModel: ObservableObject {
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    @Published var isGameStarted: Bool = false
    @Published var gameID: UUID = UUID()
    @Published var difficulty: Difficulty = .easy
    
    let pipeGap: CGFloat = 170.0
    var spawnRate: TimeInterval {
        difficulty == .easy ? 1.8 : 1.3
    }
            
    var gravity: CGFloat {
        difficulty == .easy ? -8.5 : -15.0
    }
            
    var jumpImpulse: CGFloat {
        difficulty == .easy ? 14.0 : 20.0
    }
    
    
    func startGame(difficulty: Difficulty) {
        self.difficulty = difficulty
        self.score = 0
        self.isGameOver = false
        self.isGameStarted = true
        self.gameID = UUID()
    }
    
    func resetGame() {
        isGameOver = false
        isGameStarted = false
        score = 0
    }
    
    func addScore() {
        score += 1
    }
        
    func gameOver() {
        isGameOver = true
    }
}
