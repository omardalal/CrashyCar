//
//  traffic.swift
//  Crashy Car
//
//  Created by Omar Dalal on 9/3/16.
//  Copyright © 2016 AmpeoTech. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    func setTrafficBehaviour(_ carCategory: UInt32, trafficCategory: UInt32,pos: CGPoint, scene: SKScene) {
        var moveTrafficAction = SKAction()
        self.scaleSprite(scene, xScalePlus: 0.36, yScalePlus: 0.36, xScaleNor: 0.33, yScaleNor: 0.33, xScaleMini: 0.3, yScaleMini: 0.3)
        self.zPosition = 2.1
        self.position = pos
        moveTrafficAction = SKAction.moveBy(x: 0, y: -(self.frame.maxY*2), duration: Double((self.frame.maxY*2)/(0.8831521739*scene.frame.maxY)))
        let removeSpriteAction = SKAction.removeFromParent()
        self.run(SKAction.repeatForever(SKAction.sequence([moveTrafficAction, removeSpriteAction])))
        self.zRotation = CGFloat(M_PI)
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width-8, height: self.size.height-8))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = trafficCategory
        self.physicsBody?.contactTestBitMask = carCategory
        scene.addChild(self)
    }
}
