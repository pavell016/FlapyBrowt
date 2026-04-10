import SpriteKit

class PipePair: SKNode {
    func setup(gapSize: CGFloat, pipeWidth: CGFloat = 65, screenWidth: CGFloat, screenHeight: CGFloat) {
        let pipeHeight = screenHeight
        let pipeColor = SKColor.systemGreen
        
        // --- Tubería Superior ---
        let topPipe = SKShapeNode(rectOf: CGSize(width: pipeWidth, height: pipeHeight))
        topPipe.fillColor = pipeColor
        topPipe.strokeColor = .black
        topPipe.lineWidth = 2
        topPipe.position = CGPoint(x: 0, y: (gapSize / 2) + (pipeHeight / 2))
        
        // --- Tubería Inferior ---
        let bottomPipe = SKShapeNode(rectOf: CGSize(width: pipeWidth, height: pipeHeight))
        bottomPipe.fillColor = pipeColor
        bottomPipe.strokeColor = .black
        bottomPipe.lineWidth = 2
        bottomPipe.position = CGPoint(x: 0, y: -(gapSize / 2) - (pipeHeight / 2))
        
        // --- Sensor de Puntos (invisible) ---
        let scoreNode = SKSpriteNode(color: .clear, size: CGSize(width: 2, height: gapSize))
        scoreNode.position = CGPoint(x: pipeWidth / 2 + 10, y: 0)
        
        // Físicas
        [topPipe, bottomPipe].forEach { pipe in
            pipe.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeWidth, height: pipeHeight))
            pipe.physicsBody?.isDynamic = false
            pipe.physicsBody?.categoryBitMask = PhysicsCategory.pipe
            self.addChild(pipe)
        }
        
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.score
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.bird
        self.addChild(scoreNode)
        
        // MOVIMIENTO: Calculamos la distancia para que salga totalmente
        let startX = screenWidth + pipeWidth
        let endX = -(pipeWidth + 50)
        let moveDistance = startX + abs(endX)
        
        let moveAction = SKAction.moveBy(x: -moveDistance, y: 0, duration: 4.0)
        let removeAction = SKAction.removeFromParent()
        self.run(SKAction.sequence([moveAction, removeAction]))
    }
}
