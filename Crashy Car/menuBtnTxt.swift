//
//  menuBtnTxt.swift
//  Crashy Car
//
//  Created by Omar Dalal on 8/18/16.
//  Copyright © 2016 AmpeoTech. All rights reserved.
//

import UIKit
import SpriteKit

extension SKLabelNode {
    func setLblPos(_ btn: SKSpriteNode, amountDown: CGFloat) {
        self.position = CGPoint(x: btn.frame.midX, y: btn.frame.midY-amountDown)
    }
}
