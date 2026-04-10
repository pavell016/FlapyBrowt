import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    var vm: ViewModel?
    var bird = SKShapeNode(circleOfRadius: 18)
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .cyan
        physicsWorld.gravity = CGVector(dx: 0, dy: -8.5)
        physicsWorld.contactDelegate = self
        setupBird()
        startSpawningPipes()
    }
    
    func setupBird() {
        bird.fillColor = .yellow
        bird.strokeColor = .black
        bird.position = CGPoint(x: self.size.width * 0.2, y: self.size.height / 2)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: 18)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.pipe | PhysicsCategory.score
        bird.physicsBody?.collisionBitMask = PhysicsCategory.pipe // Rebota en tuberías
        bird.physicsBody?.allowsRotation = false
        
        self.addChild(bird)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == (PhysicsCategory.bird | PhysicsCategory.score) {

            vm?.addScore()
        } else if contactMask == (PhysicsCategory.bird | PhysicsCategory.pipe) {
            triggerGameOver()
        }
    }
    
    func triggerGameOver() {
        guard let vm = vm, !vm.isGameOver else { return }
        vm.gameOver()
        self.isPaused = true // Detiene el mundo de SpriteKit
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Si cae al suelo o sube demasiado
        if bird.position.y < 0 || bird.position.y > self.size.height {
            triggerGameOver()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if vm?.isGameOver == false {
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 14))
        }
    }
    
    func startSpawningPipes() {
        let spawn = SKAction.run { [weak self] in
            guard let self = self, let vm = self.vm, !vm.isGameOver else { return }
            let pipes = PipePair()
            pipes.setup(gapSize: vm.pipeGap, screenWidth: self.size.width, screenHeight: self.size.height)
            let randomY = CGFloat.random(in: self.size.height * 0.25...self.size.height * 0.75)
            pipes.position = CGPoint(x: self.size.width + 100, y: randomY)
            self.addChild(pipes)
        }
        let delay = SKAction.wait(forDuration: 2.0)
        self.run(SKAction.repeatForever(SKAction.sequence([spawn, delay])))
    }
}
