//
//  GameScene.swift
//  Crashy Car
//
//  Created by Omar Dalal on 8/17/16.
//  Copyright (c) 2016 AmpeoTech. All rights reserved.
//

import SpriteKit
import UIKit
import iAd

@available(iOS 9.0, *)
class GameScene: SKScene/*, ADBannerViewDelegate*/ {
    
    //SPRITE_NODES
    var startGameBtn: SKSpriteNode!
    var shopBtn: SKSpriteNode!
    var audioBtn: SKSpriteNode!
    var musicBtn: SKSpriteNode!
    var street: SKSpriteNode!
    var rightGround: SKSpriteNode!
    var leftGround: SKSpriteNode!
    var scroller = SKSpriteNode()
    
    //LABEL_NODES
    var startGameBtnTxt = SKLabelNode()
    var shopBtnTxt = SKLabelNode()
    
    //VARS
    var sceneMidX: CGFloat!
    var sceneMidY: CGFloat!
    var linesNum:CGFloat = 0
    var isOnMenuBtn = false
    var isOnAudioBtn = false
    var isOnMusicBtn = false
    var audioOn = true
    var musicOn = true
    var firstTime = true
    var isOnStartBtn = false
    var isOnShopBtn = false
    var adBanner: ADBannerView!
    
    //TEXTURES
    var rightGroundTexture: SKTexture!
    var leftGroundTexture: SKTexture!
    var streetTexture: SKTexture!
    var audioBtnTexture: SKTexture!
    var musicBtnTexture: SKTexture!
    var menuBtnTexture = SKTexture(imageNamed: "menuBtn")
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        sceneMidX = self.frame.midX
        sceneMidY = self.frame.midY
        
//        adBanner = ADBannerView(frame: CGRect.zero)
//        adBanner.center = CGPointMake(sceneMidX, self.frame.maxY-(adBanner.frame.size.width/2))
//        adBanner.delegate = self
//        adBanner.hidden = true
//        self.view?.addSubview(adBanner)
        
        if let audioData = UserDefaults.standard.object(forKey: "audio") as? Bool {
            audioOn = audioData
        }
        if let musicData = UserDefaults.standard.object(forKey: "music") as? Bool {
            musicOn = musicData
        }
        if let timeData = UserDefaults.standard.object(forKey: "firstTime") as? Bool {
            firstTime = timeData
        }
        
        startGameBtn = SKSpriteNode(texture: menuBtnTexture)
        startGameBtn.anchorPoint = CGPoint(x: 0.5, y: 0)
        setMenuBtnSize(startGameBtn)
        startGameBtn.position = CGPoint(x: sceneMidX, y: sceneMidY + 10)
        startGameBtn.zPosition = 2
        self.addChild(startGameBtn)
        
        shopBtn = SKSpriteNode(texture: menuBtnTexture)
        shopBtn.anchorPoint = CGPoint(x: 0.5, y: 1)
        setMenuBtnSize(shopBtn)
        shopBtn.position = CGPoint(x: sceneMidX, y: sceneMidY - 10)
        shopBtn.zPosition = 2
        self.addChild(shopBtn)
        
        startGameBtnTxt.createMenuBtnLbl(startGameBtn, text: "start game",gameOver: false, add: true, scene: self)
        shopBtnTxt.createMenuBtnLbl(shopBtn, text: "shop",gameOver: false, add: true, scene: self)
        
        streetTexture = SKTexture(imageNamed: "street")
        rightGroundTexture = SKTexture(imageNamed: "rightGround")
        leftGroundTexture = SKTexture(imageNamed: "leftGround")
        
        for i in 0...1 {
            street = SKSpriteNode(texture: streetTexture)
            street.anchorPoint = CGPoint(x: 0.5, y: 0)
            street.scaleSprite(self, xScalePlus: 1.19, yScalePlus: 1.19, xScaleNor: 1.05, yScaleNor: 1.05, xScaleMini: 0.9, yScaleMini: 0.9)
            street.position = CGPoint(x: sceneMidX, y: street.frame.size.height*CGFloat(i))
            street.zPosition = -1
            street.run(moveAndReplaceSprite(streetTexture))
            self.addChild(street)
        }
        
        audioBtn = SKSpriteNode(texture: SKTexture(imageNamed: "soundOn"))
        audioBtn.scaleSprite(self, xScalePlus: 0.5, yScalePlus: 0.5, xScaleNor: 0.5, yScaleNor: 0.5, xScaleMini: 0.5, yScaleMini: 0.5)
        audioBtn.position = CGPoint(x: street.frame.minX + 47.5, y: audioBtn.frame.height/1.4)
        audioBtn.zPosition = 1
        self.addChild(audioBtn)
        
        musicBtn = SKSpriteNode(texture: SKTexture(imageNamed: "musicOn"))
        musicBtn.position = CGPoint(x: audioBtn.frame.maxX + 30, y: musicBtn.frame.height)
        musicBtn.zPosition = 1
//        self.addChild(musicBtn)
        
        if firstTime {
            setBtnTextureStr(audioBtn, texture: "soundOn")
            setBtnTextureStr(musicBtn, texture: "musicOn")
            firstTime = false
            UserDefaults.standard.set(firstTime, forKey: "firstTime")
            UserDefaults.standard.synchronize()
        } else {
            if audioOn {
                setBtnTextureStr(audioBtn, texture: "soundOn")
                audioBtnTexture = SKTexture(imageNamed: "soundOn")
                setAudioBtnSize()
            } else {
                setBtnTextureStr(audioBtn, texture: "soundOff")
                audioBtnTexture = SKTexture(imageNamed: "soundOff")
                setAudioBtnSize()
            }
            if musicOn {
                musicBtnTexture = SKTexture(imageNamed: "musicOn")
                setBtnTextureStr(musicBtn, texture: "musicOn")
                musicBtn.size = musicBtnTexture.size()
            } else {
                musicBtnTexture = SKTexture(imageNamed: "musicOff")
                setBtnTextureStr(musicBtn, texture: "musicOff")
                musicBtn.size = musicBtnTexture.size()
            }
        }

        for i in 0...1 {
            rightGround = SKSpriteNode(texture: rightGroundTexture)
            rightGround.anchorPoint = CGPoint(x: 0, y: 0)
            rightGround.position = CGPoint(x: street.frame.maxX, y: rightGround.frame.size.height*CGFloat(i))
            rightGround.zPosition = 0
            rightGround.run(moveAndReplaceSprite(rightGroundTexture))
            self.addChild(rightGround)
            
            leftGround = SKSpriteNode(texture: leftGroundTexture)
            leftGround.anchorPoint = CGPoint(x: 1, y: 0)
            leftGround.position = CGPoint(x: street.frame.minX, y: leftGround.frame.size.height*CGFloat(i))
            leftGround.zPosition = 0
            leftGround.run(moveAndReplaceSprite(leftGroundTexture))
            self.addChild(leftGround)
        }
    }
    
    func setMenuBtnSize(_ btnName: SKSpriteNode) {
        btnName.scaleSprite(self, xScalePlus: 0.6, yScalePlus: 0.6, xScaleNor: 0.525, yScaleNor: 0.525, xScaleMini: 0.45, yScaleMini: 0.45)
    }
    
//    func bannerViewDidLoadAd(banner: ADBannerView!) {
//        banner.hidden = false
//    }
//    
//    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
//        print(error)
//    }
//    
//    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
//        return true
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        for touch in touches {
            let touchLoc = touch.location(in: self)
            if startGameBtn.contains(touchLoc) {
                startGameBtn.setBtnTexture("menuBtnTapped")
                startGameBtnTxt.setLblPos(startGameBtn, amountDown: 10)
                isOnMenuBtn = true
                isOnStartBtn = true
            } else if shopBtn.contains(touchLoc) {
                shopBtn.setBtnTexture("menuBtnTapped")
                shopBtnTxt.setLblPos(shopBtn, amountDown: 10)
                isOnMenuBtn = true
                isOnShopBtn = true
            } else if musicBtn.contains(touchLoc) {
                isOnMusicBtn = true
            } else if audioBtn.contains(touchLoc) {
                isOnAudioBtn = true
                if audioOn {
                    setBtnTextureStr(audioBtn, texture: "soundOnTapped")
                } else {
                    setBtnTextureStr(audioBtn, texture: "soundOffTapped")
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLoc = touch.location(in: self)
            if isOnShopBtn {
                if !shopBtn.contains(touchLoc) {
                    isOnShopBtn = false
                    shopBtn.setBtnTexture("menuBtn")
                    shopBtnTxt.setLblPos(shopBtn, amountDown: 8)
                }
            }
            if isOnStartBtn {
                if !startGameBtn.contains(touchLoc) {
                    isOnStartBtn = false
                    startGameBtn.setBtnTexture("menuBtn")
                    startGameBtnTxt.setLblPos(startGameBtn, amountDown: 8)
                }
            }
            if isOnAudioBtn {
                if !audioBtn.contains(touchLoc) {
                    isOnAudioBtn = false
                    if audioOn {
                        setBtnTextureStr(audioBtn, texture: "soundOn")
                    } else {
                        setBtnTextureStr(audioBtn, texture: "soundOff")
                    }
                }
            }
            if isOnMusicBtn {
                if !musicBtn.contains(touchLoc) {
                    isOnMusicBtn = false
                }
            }
        }
    }
    
    func setAudioBtnSize() {
        audioBtn.scaleSprite(self, xScalePlus: 0.55, yScalePlus: 0.55, xScaleNor: 0.45, yScaleNor: 0.45, xScaleMini: 0.4, yScaleMini: 0.4)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startGameBtn.setBtnTexture("menuBtn")
        shopBtn.setBtnTexture("menuBtn")
        startGameBtnTxt.setLblPos(startGameBtn, amountDown: 8)
        shopBtnTxt.setLblPos(shopBtn, amountDown: 8)
        if isOnMenuBtn {
            playMenuBtnSound(self)
            isOnMenuBtn = false
            playMenuBtnSound(self)
        } else if isOnAudioBtn {
            isOnAudioBtn = false
            if audioOn {
                audioOn = false
                setBtnTextureStr(audioBtn, texture: "soundOff")
                setAudioBtnSize()
                saveAudio()
            } else {
                audioOn = true
                self.run(SKAction.playSoundFileNamed("Click.wav", waitForCompletion: false))
                setBtnTextureStr(audioBtn, texture: "soundOn")
                setAudioBtnSize()
                saveAudio()
            }
        } else if isOnMusicBtn {
            playMenuBtnSound(self)
            isOnMusicBtn = false
            if musicOn {
                musicOn = false
                setBtnTextureStr(musicBtn, texture: "musicOff")
                musicBtnTexture = SKTexture(imageNamed: "musicOff")
                musicBtn.size = musicBtnTexture.size()
                saveMusic()
            } else {
                musicOn = true
                setBtnTextureStr(musicBtn, texture: "musicOn")
                musicBtnTexture = SKTexture(imageNamed: "musicOn")
                musicBtn.size = musicBtnTexture.size()
                saveMusic()
            }
        }
        if isOnShopBtn {
            moveToShop(true)
        } else if isOnStartBtn {
            startGame()
        }
    }
    
    func startGame() {
        let trans = SKTransition.crossFade(withDuration: 0.2)
        let nextScene = gameplayScene(size: self.frame.size)
        nextScene.scaleMode = .aspectFill
        if let carData = UserDefaults.standard.object(forKey: "lastCar") as? CGFloat {
            nextScene.carNum = "car\(convertNumber(carData))"
        } else {
            nextScene.carNum = "car\(1)"
        }
        nextScene.customCamera.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        nextScene.addChild(nextScene.customCamera)
        nextScene.camera = nextScene.customCamera
        let zoomInAction = SKAction.scale(to: 0.5, duration: 0)
        let rotateAction = SKAction.rotate(toAngle: 0.785398, duration: 0)
        nextScene.customCamera.run(zoomInAction)
        nextScene.customCamera.run(rotateAction)
        nextScene.scaleMode = .aspectFill
        self.view?.presentScene(nextScene, transition: trans)
    }
    
    func moveToShop(_ shop: Bool) {
        let trans = SKTransition.crossFade(withDuration: 0.2)
        let nextScene = ShopScene(size: self.frame.size)
        nextScene.scaleMode = .aspectFill
        if shop {
            nextScene.fromShop = true
        } else {
            nextScene.fromShop = false
        }
        self.view?.presentScene(nextScene, transition: trans)
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func moveAndReplaceSprite(_ rightLeftTexture: SKTexture) -> SKAction {
        let moveGround = SKAction.moveBy(x: 0, y: -(rightLeftTexture.size().height), duration: Double(rightLeftTexture.size().height)/100)
        let replaceGround = SKAction.moveBy(x: 0, y: rightLeftTexture.size().height, duration: 0)
        let moveAndReplaceGround = SKAction.repeatForever(SKAction.sequence([moveGround,replaceGround]))
        return moveAndReplaceGround
    }
    
    func setBtnTextureStr(_ btn: SKSpriteNode, texture: String) {
        btn.texture = SKTexture(imageNamed: "\(texture)")
    }
    
    func saveAudio() {
        UserDefaults.standard.set(audioOn, forKey: "audio")
        UserDefaults.standard.synchronize()
    }
    
    func saveMusic() {
        UserDefaults.standard.set(musicOn, forKey: "music")
        UserDefaults.standard.synchronize()
    }
    
    func convertNumber(_ num: CGFloat) -> Int {
        if Int(num) == 30 {
            return 30
        } else {
            return 30-Int(num)
        }
    }
}
