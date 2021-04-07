//
//  scoreNode.swift
//  Crashy Car
//
//  Created by Omar Dalal on 9/3/16.
//  Copyright © 2016 AmpeoTech. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    func setScoreNodeBehaviour(_ scoreCategory: UInt32, carCategory: UInt32, trafficSprite: SKSpriteNode, scene: SKScene, rightOrLeft: Int, rightPlate: CGRect, leftPlate: CGRect) {
        if rightOrLeft == 0 {
            self.position = CGPoint(x: rightPlate.midX, y: trafficSprite.frame.maxY)
        } else {
            self.position = CGPoint(x: leftPlate.midX, y: trafficSprite.frame.maxY)
        }
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = scoreCategory
        self.physicsBody?.contactTestBitMask = carCategory
        self.zPosition = 1
        scene.addChild(self)
        let moveTrafficAction = SKAction.moveBy(x: 0, y: -(self.frame.maxY*2), duration: Double((self.frame.maxY*2)/(0.8831521739*scene.frame.maxY)))
        let removeSpriteAction = SKAction.removeFromParent()
        self.run(SKAction.repeatForever(SKAction.sequence([moveTrafficAction, removeSpriteAction])))
    }
}
