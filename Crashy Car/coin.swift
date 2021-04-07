//
//  coin.swift
//  Crashy Car
//
//  Created by Omar Dalal on 9/9/16.
//  Copyright © 2016 AmpeoTech. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    func initCoin(_ scoreNode: SKSpriteNode, randomInt: UInt32, scene: SKScene) {
        self.texture = SKTexture(imageNamed: "coin")
        self.position = CGPoint(x: scoreNode.frame.midX, y: scoreNode.frame.midY)
        self.zPosition = 2
        if randomInt == 1 {
            scene.addChild(self)
        }
        let moveTrafficAction = SKAction.moveBy(x: 0, y: -(self.frame.maxY*2), duration: Double(self.frame.maxY*2/600))
        let removeSpriteAction = SKAction.removeFromParent()
        self.run(SKAction.repeatForever(SKAction.sequence([moveTrafficAction, removeSpriteAction])))
    }
}
