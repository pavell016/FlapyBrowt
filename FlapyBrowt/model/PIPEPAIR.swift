

import SpriteKit

class PipePair: SKNode {
    
    func setup(gapSize: CGFloat, pipeWidth: CGFloat = 80, screenWidth: CGFloat) {
        //Configuración de dimensiones
        let pipeHeight: CGFloat = 1000
        let pipeSize = CGSize(width: pipeWidth, height: pipeHeight)
        let pipeColor = SKColor.green
        
        //tubería inferior
        let bottomPipe = SKShapeNode(rectOf: pipeSize)
        bottomPipe.fillColor = pipeColor
        bottomPipe.strokeColor = .black
        bottomPipe.position = CGPoint(x: 0, y: -(gapSize / 2) - (pipeHeight / 2))
        
        //tubería superior
        let topPipe = SKShapeNode(rectOf: pipeSize)
        topPipe.fillColor = pipeColor
        topPipe.strokeColor = .black
        topPipe.position = CGPoint(x: 0, y: (gapSize / 2) + (pipeHeight / 2))
        
        // 4. Físicas
        [bottomPipe, topPipe].forEach { pipe in
            pipe.physicsBody = SKPhysicsBody(rectangleOf: pipeSize)
            pipe.physicsBody?.isDynamic = false
            self.addChild(pipe)
        }
        
        let distanceToMove = screenWidth + pipeWidth + 100
        let moveAction = SKAction.moveBy(x: -distanceToMove, y: 0, duration: 4.0)
        let removeAction = SKAction.removeFromParent()
        
        self.run(SKAction.sequence([moveAction, removeAction]))
    }
}

