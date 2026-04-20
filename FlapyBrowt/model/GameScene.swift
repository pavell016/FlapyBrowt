import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate {
    var vm: ViewModel?
    var bird = SKNode()
    let birdRadius: CGFloat = 18.0
    private var lastJumpTime: TimeInterval = 0
    
    func cleanScene() {
        self.removeAllActions()
        self.removeAllChildren()
        self.physicsWorld.contactDelegate = nil
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .cyan
        // Usar gravedad del VM
        physicsWorld.gravity = CGVector(dx: 0, dy: vm?.gravity ?? -8.5)
        physicsWorld.contactDelegate = self
        setupBird()
        startSpawningPipes()
    }
    
    func setupBird() {
        let radius: CGFloat = 18.0
        let birdSize = CGSize(width: radius * 2, height: radius * 2)
        
        let birdImage = SKSpriteNode(imageNamed: "browt")
        birdImage.size = birdSize
        
        let mask = SKShapeNode(circleOfRadius: radius)
        mask.fillColor = .white
        
        let cropNode = SKCropNode()
        cropNode.maskNode = mask
        cropNode.addChild(birdImage)
        
        bird.removeAllChildren()
        bird.addChild(cropNode)
        bird.position = CGPoint(x: self.size.width * 0.2, y: self.size.height / 2)
        bird.zPosition = 10
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        bird.physicsBody?.categoryBitMask = PhysicsCategory.bird
        bird.physicsBody?.contactTestBitMask = PhysicsCategory.pipe | PhysicsCategory.score
        bird.physicsBody?.collisionBitMask = PhysicsCategory.pipe
        bird.physicsBody?.allowsRotation = false
        
        if bird.parent == nil {
            self.addChild(bird)
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let vm = vm, !vm.isGameOver else { return }
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == (PhysicsCategory.bird | PhysicsCategory.score) {
            vm.addScore()
        } else if contactMask == (PhysicsCategory.bird | PhysicsCategory.pipe) {
            triggerGameOver()
        }
    }
    
    func triggerGameOver() {
        guard let vm = vm, !vm.isGameOver else { return }
        
        bird.physicsBody?.contactTestBitMask = 0
        
        vm.gameOver()
        self.isPaused = true
        self.cleanScene()
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
            // Usar impulso del VM
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: vm?.jumpImpulse ?? 14))
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
        
        // Usar spawnRate del VM
        let delay = SKAction.wait(forDuration: vm?.spawnRate ?? 1.8)
        self.run(SKAction.repeatForever(SKAction.sequence([spawn, delay])))
    }
}
