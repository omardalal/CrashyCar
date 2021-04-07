//
//  scaleText.swift
//  Crashy Car
//
//  Created by Omar Dalal on 12/7/16.
//  Copyright © 2016 AmpeoTech. All rights reserved.
//

import Foundation
import SpriteKit

extension SKLabelNode {
    func scaleText(_ scene: SKScene, plus: CGFloat, nor: CGFloat, mini: CGFloat) {
        if UIDevice.current.userInterfaceIdiom == .phone && scene.frame.maxX < 375 {
            self.fontSize = mini
        }
        if UIDevice.current.userInterfaceIdiom == .phone && (scene.frame.maxX >= 375 && scene.frame.maxX < 414) {
            self.fontSize = nor
        }
        if UIDevice.current.userInterfaceIdiom == .phone && scene.frame.maxX >= 414 {
            self.fontSize = plus            
        }
    }
}
