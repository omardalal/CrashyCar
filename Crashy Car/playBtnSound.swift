//
//  playSound.swift
//  Crashy Car
//
//  Created by Omar Dalal on 9/6/16.
//  Copyright © 2016 AmpeoTech. All rights reserved.
//

import Foundation
import SpriteKit

func playMenuBtnSound(_ scene: SKScene) {
    func playBtn() {
        scene.run(SKAction.playSoundFileNamed("Click.wav", waitForCompletion: false))
    }
    if let defaults = UserDefaults.standard.object(forKey: "audio") as? Bool {
        if defaults == true {
            playBtn()
        }
    } else {
        playBtn()
    }
}
