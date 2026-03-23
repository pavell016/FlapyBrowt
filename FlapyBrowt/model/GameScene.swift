import SpriteKit

class GameScene: SKScene {
    var vm: ViewModel?
    
    override func didMove(to view: SKView) {
        self.removeAllChildren()
        self.removeAllActions()
        startSpawningPipes()
    }
    
    func startSpawningPipes() {
        let spawn = SKAction.run { [weak self] in
            guard let self = self, let viewModel = self.vm, !viewModel.isGameOver else { return }
            
            let pipes = PipePair()
            pipes.setup(gapSize: viewModel.pipeGap, screenWidth: self.size.width)
            
            let randomY = CGFloat.random(in: self.size.height * 0.3...self.size.height * 0.7)
            pipes.position = CGPoint(x: self.size.width + 50, y: randomY)
            
            self.addChild(pipes)
        }
        
        let wait = SKAction.wait(forDuration: vm?.spawnRate ?? 2.0)
        let sequence = SKAction.sequence([spawn, wait])
        self.run(SKAction.repeatForever(sequence))
    }
}
