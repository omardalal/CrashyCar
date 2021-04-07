//
//  menuBtnTexture.swift
//  test
//
//  Created by Omar Dalal on 8/17/16.
//  Copyright © 2016 AmpeoTech. All rights reserved.
//

import UIKit
import SpriteKit

extension SKSpriteNode {
    func setBtnTexture(_ textureStr: String) {
        self.texture = SKTexture(imageNamed: textureStr)
    }
}
