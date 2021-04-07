//
//  setMenuBtnLbl.swift
//  Crashy Car
//
//  Created by Omar Dalal on 8/18/16.
//  Copyright © 2016 AmpeoTech. All rights reserved.
//

import UIKit
import SpriteKit

extension SKLabelNode {
    func createMenuBtnLbl(_ btn: SKSpriteNode, text: String, gameOver: Bool, add: Bool, scene: SKScene) {
        self.fontName = "KenVector Future Thin"
        self.text = text
        self.setLblPos(btn, amountDown: 8)
        self.zPosition = btn.zPosition+1
        if gameOver {
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.fontSize = 26
            } else {
                self.fontSize = 20
            }
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.fontSize = 35
            } else {
                self.fontSize = 25
            }
        }
        if add {
            scene.addChild(self)
        }
    }
}
