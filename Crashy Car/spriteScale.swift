//
//  spriteScale.swift
//  Crashy Car
//
//  Created by Omar Dalal on 12/2/16.
//  Copyright © 2016 AmpeoTech. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    func scaleSprite(_ scene: SKScene, xScalePlus: CGFloat, yScalePlus: CGFloat, xScaleNor: CGFloat, yScaleNor: CGFloat, xScaleMini: CGFloat, yScaleMini: CGFloat) {
        if UIDevice.current.userInterfaceIdiom == .phone && scene.frame.maxX < 375 {
            self.xScale = xScaleMini
            self.yScale = yScaleMini
        }
        if UIDevice.current.userInterfaceIdiom == .phone && (scene.frame.maxX >= 375 && scene.frame.maxX < 414) {
            self.xScale = xScaleNor
            self.yScale = yScaleNor
        }
        if UIDevice.current.userInterfaceIdiom == .phone && scene.frame.maxX >= 414 {
            self.xScale = xScalePlus
            self.yScale = yScalePlus
        }
    }
}
