//
//  gameplayScene.swift
//  Crashy Car
//
//  Created by Omar Dalal on 8/22/16.
//  Copyright © 2016 AmpeoTech. All rights reserved.
//

import UIKit
import SpriteKit

@available(iOS 9.0, *)
class gameplayScene: SKScene, SKPhysicsContactDelegate {
    
    //SPRITE_NODES
    var street: SKSpriteNode!
    var leftGround: SKSpriteNode!
    var rightGround: SKSpriteNode!
    var userCar: SKSpriteNode!
    var pauseBtn: SKSpriteNode!
    var coin: SKSpriteNode!
    var trafficOne: SKSpriteNode!
    var trafficTwo: SKSpriteNode!
    var trafficThree: SKSpriteNode!
    var tapToStart: SKSpriteNode!
    var scoreNodeOne: SKSpriteNode!
    var scoreNodeTwo: SKSpriteNode!
    var scoreNodeThree: SKSpriteNode!
    var pauseLayer: SKSpriteNode!
    var gameOverDisplay: SKSpriteNode!
    var menuBtn = SKSpriteNode()
    var restartBtn = SKSpriteNode()
//    var shareBtn: SKSpriteNode!
    var resumeBtn: SKSpriteNode!
    var gameOverRestartBtn: SKSpriteNode!
    var gameOverMenuBtn: SKSpriteNode!
    var touchToPlay: SKSpriteNode!
    
    //POSITIONING_PLATES__CGRECT
    var street_plate: CGRect!
    var left_side_plate: CGRect!
    var right_side_plate: CGRect!
    
    //LABEL_NODES
    var score: SKLabelNode!
    var pausedTimerLbl: SKLabelNode!
    var menuBtnLbl = SKLabelNode()
    var restartBtnLbl = SKLabelNode()
    var gameOverScore: SKLabelNode!
    var highScoreLbl: SKLabelNode!
    var resumeBtnLbl = SKLabelNode()
    var gameOverMenuLbl = SKLabelNode()
    var gameOverRestartLbl = SKLabelNode()
    var earnedCoins: SKLabelNode!
    
    //TEXTURES
    var rightGroundTexture: SKTexture!
    var leftGroundTexture: SKTexture!
    var streetTexture: SKTexture!
    
    //VARS
    var sceneMidX: CGFloat!
    var sceneMidY: CGFloat!
    var carNum: String!
    var isOnPauseBtn = false
    var gameStarted = false
    var rightOrLeft: UInt32!
    var carCurrentSide: Int!
    var randomCarOne: UInt32!
    var randomCarTwo: UInt32!
    var randomCarThree: UInt32!
    var gamePaused = false
    var timerIsGoing = false
    var isOnMenuBtn = false
    var isOnRestartBtn = false
    var isOnResumeBtn = false
    var gameIsOver = false
    var isOnGameOverMenuBtn = false
    var isOnGameOverRestartBtn = false
    var btnsShown = false
    var timersVal = 1.0
    var randomNum: UInt32!
    var randomCoin: UInt32!
    var earnedCoinsInt = 0
    
    //POSITIONS
    var trafficOnePos: CGPoint!
    var trafficTwoPos: CGPoint!
    var trafficThreePos: CGPoint!
    var scoreNodeOnePos: Int!
    var scoreNodeTwoPos: Int!
    var scoreNodeThreePos: Int!
    
    //PHYSICS_CONTACT_VARS_UINT32
    var trafficGroup:UInt32 = 1
    var userCarGroup: UInt32 = 2
    var scoreGroup:UInt32 = 0
    
    //TIMERS
    var pauseCountdownTimer: Timer!
    var randomiseTimersTimer: Timer!
    var customCamera = SKCameraNode()
    
    override func didMove(to view: SKView) {
        initScene()
        
        customCamera.run(SKAction.scale(to: 1, duration: 1))
        customCamera.run(SKAction.rotate(toAngle: 0, duration: 1))
    }
    
    func initScene() {
        sceneMidX = self.frame.midX
        sceneMidY = self.frame.midY
        
        rightOrLeft = arc4random_uniform(2)
        physicsWorld.contactDelegate = self
        
        streetTexture = SKTexture(imageNamed: "street")
        rightGroundTexture = SKTexture(imageNamed: "rightGround")
        leftGroundTexture = SKTexture(imageNamed: "leftGround")
        
        street_plate = CGRect(x: sceneMidX-(streetTexture.size().width/2), y: sceneMidY-(streetTexture.size().height/2), width: streetTexture.size().width, height: streetTexture.size().height)
        left_side_plate = CGRect(x: street_plate.minX, y: 0, width: street_plate.midX-street_plate.minX, height: self.frame.height)
        right_side_plate = CGRect(x: street_plate.midX, y: 0, width: street_plate.maxX-street_plate.midX, height: self.frame.height)
        
        randomiseVars()
        
        pauseLayer = SKSpriteNode(color: UIColor.black, size: self.size)
        pauseLayer.position = CGPoint(x: sceneMidX, y: sceneMidY)
        pauseLayer.zPosition = 6
        pauseLayer.alpha = 0.75
        
        gameOverDisplay = SKSpriteNode(texture: SKTexture(imageNamed: "scoreDisplay"))
        gameOverDisplay.scaleSprite(self, xScalePlus: 0.6, yScalePlus: 0.6, xScaleNor: 0.55, yScaleNor: 0.55, xScaleMini: 0.5, yScaleMini: 0.5)
        gameOverDisplay.position = CGPoint(x: -sceneMidX, y: self.frame.maxY-(self.frame.height/3))
        gameOverDisplay.zPosition = 7
        
        restartBtn = SKSpriteNode(texture: SKTexture(imageNamed: "menuBtn"))
        setPauseBtnSize(restartBtn)
        setPausePos(3)
        restartBtn.zPosition = 8
        restartBtnLbl.createMenuBtnLbl(restartBtn, text: "restart", gameOver: false, add: false, scene: self)
        
        menuBtn = SKSpriteNode(texture: SKTexture(imageNamed: "menuBtn"))
        setPauseBtnSize(menuBtn)
        setPausePos(2)
        menuBtn.zPosition = 8
        menuBtnLbl.createMenuBtnLbl(menuBtn, text: "main menu", gameOver: false, add: false, scene: self)
        
        gameOverRestartBtn = SKSpriteNode(texture: SKTexture(imageNamed: "gameOverBtn"))
        scaleLostBtn(gameOverRestartBtn)
        gameOverRestartBtn.position = CGPoint(x: -sceneMidX, y: gameOverDisplay.frame.minY - gameOverRestartBtn.frame.height)
        gameOverRestartBtn.zPosition = 8
        gameOverRestartLbl.createMenuBtnLbl(gameOverRestartBtn, text: "restart", gameOver: true, add: false, scene: self)
        
        gameOverMenuBtn = SKSpriteNode(texture: SKTexture(imageNamed: "gameOverBtn"))
        scaleLostBtn(gameOverMenuBtn)
        gameOverMenuBtn.position = CGPoint(x: -sceneMidX, y: gameOverRestartBtn.frame.minY - gameOverMenuBtn.frame.height)
        gameOverMenuBtn.zPosition = 8
        gameOverMenuLbl.createMenuBtnLbl(gameOverMenuBtn, text: "main menu", gameOver: true, add: false, scene: self)

        resumeBtn = SKSpriteNode(texture: SKTexture(imageNamed: "menuBtn"))
        setPauseBtnSize(resumeBtn)
        setPausePos(1)
        resumeBtn.zPosition = 8
        resumeBtnLbl.createMenuBtnLbl(resumeBtn, text: "resume", gameOver: false, add: false, scene: self)
        
        pausedTimerLbl = SKLabelNode(fontNamed: "KenVector Future Thin")
        pausedTimerLbl.text = "3"
        if UIDevice.current.userInterfaceIdiom == .pad {
            pausedTimerLbl.fontSize = 180
        }
        pausedTimerLbl.scaleText(self, plus: 160, nor: 135, mini: 110)
        pausedTimerLbl.position = CGPoint(x: sceneMidX, y: sceneMidY)
        pausedTimerLbl.zPosition = 6
        
        initUserCar()
        
        pauseBtn = SKSpriteNode(texture: SKTexture(imageNamed: "pauseBtn"))
        pauseBtn.scaleSprite(self, xScalePlus: 0.58, yScalePlus: 0.58, xScaleNor: 0.52, yScaleNor: 0.52, xScaleMini: 0.465, yScaleMini: 0.465)
        pauseBtn.position = CGPoint(x: pauseBtn.frame.size.width/1.5, y: self.frame.size.height - pauseBtn.frame.size.height/1.5)
        pauseBtn.zPosition = 2.5
        
        score = SKLabelNode(fontNamed: "KenVector Future Thin")
        score.scaleText(self, plus: 50, nor: 45, mini: 40)
        score.zPosition = 5
        score.text = "0"
        if UIDevice.current.userInterfaceIdiom == .pad {
            score.fontSize = 50
        }
        score.position = CGPoint(x: left_side_plate.midX, y: self.frame.maxY-self.frame.maxY/10)
        self.addChild(score)
        
        coin = SKSpriteNode(texture: SKTexture(imageNamed: "coin"))
        coin.zPosition = 7
        coin.scaleSprite(self, xScalePlus: 0.4, yScalePlus: 0.4, xScaleNor: 0.35, yScaleNor: 0.35, xScaleMini: 0.3, yScaleMini: 0.3)
        coin.position = CGPoint(x: sceneMidX - 20, y: gameOverDisplay.frame.maxY+coin.frame.height/1.5)
        
        touchToPlay = SKSpriteNode(texture: SKTexture(imageNamed: "touchToPlay"))
        touchToPlay.scaleSprite(self, xScalePlus: 0.75, yScalePlus: 0.75, xScaleNor: 0.7, yScaleNor: 0.7, xScaleMini: 0.65, yScaleMini: 0.65)
        touchToPlay.position = CGPoint(x: userCar.frame.maxX+(touchToPlay.frame.width*0.5), y: userCar.frame.maxY)
        touchToPlay.zPosition = 5
        self.addChild(touchToPlay)
        
        initGroundStreet()
        
    }
    
    func setPauseBtnSize(_ btnName: SKSpriteNode) {
        btnName.scaleSprite(self, xScalePlus: 0.6, yScalePlus: 0.6, xScaleNor: 0.525, yScaleNor: 0.525, xScaleMini: 0.45, yScaleMini: 0.45)
    }
    
    func scaleLostBtn(_ btn: SKSpriteNode) {
        btn.scaleSprite(self, xScalePlus: 0.6, yScalePlus: 0.6, xScaleNor: 0.55, yScaleNor: 0.55, xScaleMini: 0.5, yScaleMini: 0.5)
    }
    
    func setPausePos(_ btnToSet: Int) {
        if btnToSet == 1 {
            resumeBtn.position = CGPoint(x: -sceneMidX, y: restartBtn.frame.maxY + resumeBtn.frame.height)
        } else if btnToSet == 2 {
            menuBtn.position = CGPoint(x: -sceneMidX, y: restartBtn.frame.minY - menuBtn.frame.height)
        } else if btnToSet == 3 {
            restartBtn.position = CGPoint(x: -sceneMidX, y: ((self.frame.maxY-(self.frame.height/4))-gameOverDisplay.frame.height/2) - restartBtn.frame.height)
        } else {
            menuBtnLbl.setLblPos(menuBtn, amountDown: 8)
            restartBtnLbl.setLblPos(restartBtn, amountDown: 8)
            resumeBtnLbl.setLblPos(resumeBtn, amountDown: 8)
            resumeBtn.position = CGPoint(x: -sceneMidX, y: restartBtn.frame.maxY + resumeBtn.frame.height)
            restartBtn.position = CGPoint(x: -sceneMidX, y: ((self.frame.maxY-(self.frame.height/4))-gameOverDisplay.frame.height/2) - restartBtn.frame.height)
            menuBtn.position = CGPoint(x: -sceneMidX, y: restartBtn.frame.minY - menuBtn.frame.height)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLoc = touch.location(in: self)
                if btnsShown {
                    if menuBtn.contains(touchLoc) {
                        isOnMenuBtn = true
                        menuBtn.texture = SKTexture(imageNamed: "menuBtnTapped")
                        menuBtnLbl.setLblPos(menuBtn, amountDown: 10)
                    }
                    if restartBtn.contains(touchLoc) {
                        isOnRestartBtn = true
                        restartBtn.texture = SKTexture(imageNamed: "menuBtnTapped")
                        restartBtnLbl.setLblPos(restartBtn, amountDown: 10)
                    }
                    if resumeBtn.contains(touchLoc) {
                        isOnResumeBtn = true
                        resumeBtn.texture = SKTexture(imageNamed: "menuBtnTapped")
                        resumeBtnLbl.setLblPos(resumeBtn, amountDown: 10)
                    }
                }
            if gameIsOver {
                if gameOverMenuBtn.contains(touchLoc) {
                    isOnGameOverMenuBtn = true
                    gameOverMenuBtn.texture = SKTexture(imageNamed: "gameOverBtnTapped")
                    gameOverMenuLbl.setLblPos(gameOverMenuBtn, amountDown: 10)
                }
                if gameOverRestartBtn.contains(touchLoc) {
                    isOnGameOverRestartBtn = true
                    gameOverRestartBtn.texture = SKTexture(imageNamed: "gameOverBtnTapped")
                    gameOverRestartLbl.setLblPos(gameOverRestartBtn, amountDown: 10)
                }
            }
            if !gameIsOver && !gamePaused {
                if gameStarted {
                    if pauseBtn.contains(touchLoc) {
                        playMenuBtnSound(self)
                        gamePaused = true
                        pauseGame()
                    }
                }
            }
            if !gameIsOver {
                gameTouched()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLoc = touch.location(in: self)
            if isOnPauseBtn {
                if !pauseBtn.contains(touchLoc) {
                    isOnPauseBtn = false
                    pauseBtn.texture = SKTexture(imageNamed: "pauseBtn")
                }
            }
            if isOnMenuBtn {
                if !menuBtn.contains(touchLoc) {
                    isOnMenuBtn = false
                    menuBtn.texture = SKTexture(imageNamed: "menuBtn")
                    menuBtnLbl.setLblPos(menuBtn, amountDown: 8)
                }
            }
            if isOnRestartBtn {
                if !restartBtn.contains(touchLoc) {
                    isOnRestartBtn = false
                    restartBtn.texture = SKTexture(imageNamed: "menuBtn")
                    restartBtnLbl.setLblPos(restartBtn, amountDown: 8)
                }
            }
            if isOnResumeBtn {
                if !resumeBtn.contains(touchLoc) {
                    isOnResumeBtn = false
                    resumeBtn.texture = SKTexture(imageNamed: "menuBtn")
                    resumeBtnLbl.setLblPos(resumeBtn, amountDown: 8)
                }
            }
            if isOnGameOverMenuBtn {
                if !gameOverMenuBtn.contains(touchLoc) {
                    isOnGameOverMenuBtn = false
                    gameOverMenuBtn.texture = SKTexture(imageNamed: "gameOverBtn")
                    gameOverMenuLbl.setLblPos(gameOverMenuBtn, amountDown: 8)
                }
            }
            if isOnGameOverRestartBtn {
                if !gameOverRestartBtn.contains(touchLoc) {
                    isOnGameOverRestartBtn = false
                    gameOverRestartBtn.texture = SKTexture(imageNamed: "gameOverBtn")
                    gameOverRestartLbl.setLblPos(gameOverRestartBtn, amountDown: 8)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if btnsShown {
            if isOnMenuBtn {
                goToMenu()
                playMenuBtnSound(self)
            }
            if isOnRestartBtn {
                restart()
                playMenuBtnSound(self)
            }
            if isOnResumeBtn {
                continueGame()
                playMenuBtnSound(self)
            }
        }
        if gameIsOver {
            if isOnGameOverRestartBtn {
                restart()
                playMenuBtnSound(self)
            }
            if isOnGameOverMenuBtn {
                goToMenu()
                playMenuBtnSound(self)
            }
        }
        isOnResumeBtn = false
        resumeBtn.texture = SKTexture(imageNamed: "menuBtn")
        isOnPauseBtn = false
        pauseBtn.texture = SKTexture(imageNamed: "pauseBtn")
        isOnMenuBtn = false
        menuBtn.texture = SKTexture(imageNamed: "menuBtn")
        isOnRestartBtn = false
        restartBtn.texture = SKTexture(imageNamed: "menuBtn")
        menuBtnLbl.setLblPos(menuBtn, amountDown: 8)
        restartBtnLbl.setLblPos(restartBtn, amountDown: 8)
        resumeBtnLbl.setLblPos(resumeBtn, amountDown: 8)
        isOnGameOverMenuBtn = false
        gameOverMenuBtn.texture = SKTexture(imageNamed: "gameOverBtn")
        gameOverMenuLbl.setLblPos(gameOverMenuBtn, amountDown: 8)
        isOnGameOverRestartBtn = false
        gameOverRestartBtn.texture = SKTexture(imageNamed: "gameOverBtn")
        gameOverRestartLbl.setLblPos(gameOverRestartBtn, amountDown: 8)
        
    }

    override func update(_ currentTime: TimeInterval) {
        if trafficThree != nil {
            if !gameIsOver && !gamePaused {
                if (trafficThree.frame.midY < self.frame.maxY-(self.frame.maxY/4)) && (trafficThree.frame.minY > 0){
                    randomiseVars()
                    generateTraffic()
                }
            }
        }
    }

    func restart() {
        playMenuBtnSound(self)
        let currentCar = carNum
        self.removeAllActions()
        self.removeAllChildren()
        let nextScene = gameplayScene(size: self.size)
        nextScene.scaleMode = .aspectFill
        nextScene.carNum = currentCar
        self.view?.presentScene(nextScene, transition: SKTransition.crossFade(withDuration: 0.2))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == userCarGroup && contact.bodyB.categoryBitMask == scoreGroup) || (contact.bodyA.categoryBitMask == scoreGroup && contact.bodyB.categoryBitMask == userCarGroup) {
            if let intScore = Int(score.text!) {
                var currentScore = intScore
                currentScore+=1
                playAudio("point.wav")
                score.text = "\(currentScore)"
            }
        } else if !gameIsOver {
            if (contact.bodyA.categoryBitMask == userCarGroup && contact.bodyB.categoryBitMask == trafficGroup) || (contact.bodyA.categoryBitMask == trafficGroup && contact.bodyB.categoryBitMask == userCarGroup) {
                playAudio("crash.wav")
                gameOver()
            }
        }
    }
    
    func randomiseVars() {
        randomCarOne = arc4random_uniform(30)
        randomCarTwo = arc4random_uniform(30)
        randomCarThree = arc4random_uniform(30)
        randomNum = arc4random_uniform(5)
        randomCoin = arc4random_uniform(2)
    }
    
    func initGroundStreet() {
        for i in 0...1 {
            street = SKSpriteNode(texture: streetTexture)
            street.anchorPoint = CGPoint(x: 0.5, y: 0)
            street.scaleSprite(self, xScalePlus: 1.19, yScalePlus: 1, xScaleNor: 1.05, yScaleNor: 1, xScaleMini: 0.9, yScaleMini: 1)
            street.name = "street\(i)"
            street.position = CGPoint(x: sceneMidX, y: street.frame.size.height*CGFloat(i))
            street.run(moveAndReplaceSprite(streetTexture, speed: 400))
            street.speed = 0
            street.zPosition = 2
            self.addChild(street)
            
            rightGround = SKSpriteNode(texture: rightGroundTexture)
            rightGround.anchorPoint = CGPoint(x: 0, y: 0)
            rightGround.name = "rightGround\(i)"
            rightGround.position = CGPoint(x: street.frame.maxX, y: rightGround.frame.size.height*CGFloat(i))
            rightGround.run(moveAndReplaceSprite(rightGroundTexture, speed: 400))
            rightGround.speed = 0
            rightGround.zPosition = -1
            self.addChild(rightGround)
            
            leftGround = SKSpriteNode(texture: leftGroundTexture)
            leftGround.anchorPoint = CGPoint(x: 1, y: 0)
            leftGround.name = "leftGround\(i)"
            leftGround.position = CGPoint(x: street.frame.minX, y: leftGround.frame.size.height*CGFloat(i))
            leftGround.run(moveAndReplaceSprite(leftGroundTexture, speed: 400))
            leftGround.speed = 0
            leftGround.zPosition = -1
            self.addChild(leftGround)
        }
    }
    
    func setRandomArrangement(_ randomNum: UInt32) {
        let carT = SKTexture(imageNamed: "car1")
        var divideBy: CGFloat!
        var gapLength: CGFloat!
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            divideBy = 1
//            gapLength = 3
//        } else {
            divideBy = 3.5
            gapLength = 3.5
//        }
        switch randomNum {
        case 0:
            if trafficThree != nil {
                trafficOnePos = CGPoint(x: left_side_plate.midX, y: trafficThree.frame.maxY + self.frame.maxY/gapLength)
            } else {
                trafficOnePos = CGPoint(x: left_side_plate.midX, y: self.size.height*2)
            }
            trafficTwoPos = CGPoint(x: right_side_plate.midX, y: (trafficOnePos.y+(carT.size().height/2))+(carT.size().height/divideBy))
            if UIDevice.current.userInterfaceIdiom == .pad {
                trafficThreePos = CGPoint(x: left_side_plate.midX, y: trafficTwoPos.y+(carT.size().height/2)+(carT.size().height/divideBy))
            } else {
                trafficThreePos = CGPoint(x: left_side_plate.midX, y: trafficTwoPos.y+(carT.size().height/2)+(carT.size().height/3.5))
            }
            scoreNodeOnePos = 0
            scoreNodeTwoPos = 1
            scoreNodeThreePos = 0
        case 1:
            if trafficThree != nil {
                trafficOnePos = CGPoint(x: right_side_plate.midX, y: trafficThree.frame.maxY + self.frame.maxY/gapLength)
            } else {
                trafficOnePos = CGPoint(x: right_side_plate.midX, y: self.size.height*2)
            }
            if UIDevice.current.userInterfaceIdiom == .pad {
                trafficTwoPos = CGPoint(x: left_side_plate.midX, y: (trafficOnePos.y+(carT.size().height/2))+(carT.size().height))
            } else {
                trafficTwoPos = CGPoint(x: left_side_plate.midX, y: (trafficOnePos.y+(carT.size().height/2))+(carT.size().height/3))
            }
            trafficThreePos = CGPoint(x: left_side_plate.midX, y: trafficTwoPos.y+(carT.size().height/2)+(carT.size().height/divideBy))
            scoreNodeOnePos = 1
            scoreNodeTwoPos = 0
            scoreNodeThreePos = 0
        case 2:
            if trafficThree != nil {
                trafficOnePos = CGPoint(x: right_side_plate.midX, y: trafficThree.frame.maxY + self.frame.maxY/gapLength)
            } else {
                trafficOnePos = CGPoint(x: right_side_plate.midX, y: self.size.height*2)
            }
            trafficTwoPos = CGPoint(x: left_side_plate.midX, y: (trafficOnePos.y+(carT.size().height/2))+(carT.size().height/divideBy))
            trafficThreePos = CGPoint(x: right_side_plate.midX, y: trafficTwoPos.y+(carT.size().height/2)+(carT.size().height/divideBy))
            scoreNodeOnePos = 1
            scoreNodeTwoPos = 0
            scoreNodeThreePos = 1
        case 3:
            if trafficThree != nil {
                trafficOnePos = CGPoint(x: right_side_plate.midX, y: trafficThree.frame.maxY + self.frame.maxY/gapLength)
            } else {
                trafficOnePos = CGPoint(x: right_side_plate.midX, y: self.size.height*2)
            }
            trafficTwoPos = CGPoint(x: right_side_plate.midX, y: (trafficOnePos.y+(carT.size().height/2))+(carT.size().height/divideBy))
            trafficThreePos = CGPoint(x: left_side_plate.midX, y: trafficTwoPos.y+(carT.size().height/2)+(carT.size().height))
            scoreNodeOnePos = 1
            scoreNodeTwoPos = 1
            scoreNodeThreePos = 0
        case 4:
            if trafficThree != nil {
                trafficOnePos = CGPoint(x: left_side_plate.midX, y: trafficThree.frame.maxY + self.frame.maxY/gapLength)
            } else {
                trafficOnePos = CGPoint(x: left_side_plate.midX, y: self.size.height*2)
            }
            trafficTwoPos = CGPoint(x: left_side_plate.midX, y: (trafficOnePos.y+(carT.size().height/2))+(carT.size().height/divideBy))
            trafficThreePos = CGPoint(x: right_side_plate.midX, y: trafficTwoPos.y+(carT.size().height/2)+(carT.size().height/divideBy))
            scoreNodeOnePos = 0
            scoreNodeTwoPos = 0
            scoreNodeThreePos = 1
        default:
            if trafficThree != nil {
                trafficOnePos = CGPoint(x: right_side_plate.midX, y: trafficThree.frame.maxY + self.frame.maxY/gapLength)
            } else {
                trafficOnePos = CGPoint(x: right_side_plate.midX, y: self.size.height*2)
            }
            trafficTwoPos = CGPoint(x: right_side_plate.midX, y: (trafficOnePos.y+(carT.size().height/2))+(carT.size().height/divideBy))
            trafficThreePos = CGPoint(x: left_side_plate.midX, y: trafficTwoPos.y+(carT.size().height/2)+(carT.size().height/divideBy))
            scoreNodeOnePos = 1
            scoreNodeTwoPos = 1
            scoreNodeThreePos = 0
        }
    }
    
    func moveGroundStreet() {
        for i in 0...1 {
            self.childNode(withName: "street\(i)")?.speed = 1
        }
        
        for i in 0...1 {
            self.childNode(withName: "leftGround\(i)")?.speed = 1
            self.childNode(withName: "rightGround\(i)")?.speed = 1
        }
    }
    
    func continueGame() {
        setPausePos(0)
        playMenuBtnSound(self)
        if !timerIsGoing {
            timerIsGoing = true
            pauseCountdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(pauseCountdownMinusOne), userInfo: nil, repeats: true)
            self.removeChildren(in: [menuBtn, resumeBtn, restartBtn, menuBtnLbl, restartBtnLbl, resumeBtnLbl])
            btnsShown = false
            self.addChild(pausedTimerLbl)
        }
    }
    
    func pauseCountdownMinusOne() {
        if pausedTimerLbl.text != "1" {
            if let intCountdown = Int(pausedTimerLbl.text!) {
                var countdownVal = intCountdown
                countdownVal-=1
                pausedTimerLbl.text  = "\(countdownVal)"
            }
        } else {
            resumeBtnLbl.setLblPos(resumeBtn, amountDown: 8)
            restartBtnLbl.setLblPos(restartBtn, amountDown: 8)
            menuBtnLbl.setLblPos(menuBtn, amountDown: 8)
            pauseCountdownTimer.invalidate()
            timerIsGoing = false
            isOnPauseBtn = false
            pauseBtn.texture = SKTexture(imageNamed: "pauseBtn")
            gamePaused = false
            pauseOrStartSprites(false)
            self.removeChildren(in: [pauseLayer])
            self.removeChildren(in: [pausedTimerLbl])
            pausedTimerLbl.text = "3"
            self.addChild(pauseBtn)
        }
    }
    
    func pauseGame() {
        self.removeChildren(in: [pauseBtn])
        pauseBtn.texture = SKTexture(imageNamed: "pauseBtnTapped")
        gamePaused = true
        pauseOrStartSprites(true)
        self.addChild(pauseLayer)
        self.addChild(resumeBtn)
        self.addChild(restartBtn)
        self.addChild(menuBtn)
        self.addChild(resumeBtnLbl)
        self.addChild(restartBtnLbl)
        self.addChild(menuBtnLbl)
        btnsShown = true
        animateLblEntrance(resumeBtnLbl)
        resumeBtn.run(SKAction.moveTo(x: sceneMidX+75, duration: 0), completion: {
            self.resumeBtn.run(SKAction.moveTo(x: self.sceneMidX-20, duration: 0.075), completion: {
                self.resumeBtn.run(SKAction.moveTo(x: self.sceneMidX, duration: 0.05), completion: {
                    self.animateLblEntrance(self.restartBtnLbl)
                    self.restartBtn.run(SKAction.moveTo(x: self.sceneMidX+75, duration: 0.3), completion: {
                        self.restartBtn.run(SKAction.moveTo(x: self.sceneMidX-20, duration: 0.075), completion: {
                            self.restartBtn.run(SKAction.moveTo(x: self.sceneMidX, duration: 0.05), completion: {
                                self.animateLblEntrance(self.menuBtnLbl)
                                self.menuBtn.run(SKAction.moveTo(x: self.sceneMidX+75, duration: 0.3), completion: {
                                    self.menuBtn.run(SKAction.moveTo(x: self.sceneMidX-20, duration: 0.075), completion: {
                                        self.menuBtn.run(SKAction.moveTo(x: self.sceneMidX, duration: 0.05))
                                    }) 
                                }) 
                            }) 
                        }) 
                    }) 
                }) 
            }) 
        }) 
    }
    
    func moveAndReplaceSprite(_ texture: SKTexture, speed: Double) -> SKAction {
        var speedVal = speed
        if UIDevice.current.userInterfaceIdiom == .pad {
            speedVal*=1.5
        }
        let moveSprite = SKAction.moveBy(x: 0, y: -(texture.size().height), duration: Double(texture.size().height)/speedVal)
        let replaceSprite = SKAction.moveBy(x: 0, y: texture.size().height, duration: 0)
        let moveAndReplaceSprite = SKAction.repeatForever(SKAction.sequence([moveSprite,replaceSprite]))
        return moveAndReplaceSprite
    }
    
    func pauseOrStartSprites(_ paused: Bool) {
        for i in 0...1 {
            self.childNode(withName: "street\(i)")?.isPaused = paused
            self.childNode(withName: "rightGround\(i)")?.isPaused = paused
            self.childNode(withName: "leftGround\(i)")?.isPaused = paused
        }
        userCar.isPaused = paused
        trafficOne.isPaused = paused
        trafficTwo.isPaused = paused
        trafficThree.isPaused = paused
        scoreNodeOne.isPaused = paused
        scoreNodeTwo.isPaused = paused
        scoreNodeThree.isPaused = paused
    }
    
    func gameTouched() {
        if !gameStarted {
            gameStarted = true
            self.addChild(pauseBtn)
            self.removeChildren(in: [touchToPlay])
            generateTraffic()
            moveGroundStreet()
        }
        if carCurrentSide == 0 {
            //LEFT <--
            userCar.run(SKAction.move(to: CGPoint(x: right_side_plate.midX, y: self.frame.height/4), duration: 0.25))
            carCurrentSide = 1
        } else {
            //RIGHT -->
            userCar.run(SKAction.move(to: CGPoint(x: left_side_plate.midX, y: self.frame.height/4), duration: 0.25))
            carCurrentSide = 0
        }
    }
    
    func playTrafficSound() {
        playAudio("traffic1")
    }
    
    var lastTime: Bool!
    func addOne() {
        if let score = gameOverScore.text {
            if let intScore = Int(score) {
                if earnedCoinsInt != intScore/2 && earnedCoinsInt != intScore {
                    earnedCoinsInt += 1
                    earnedCoins.text = "+\(earnedCoinsInt)"
                    coin.position = CGPoint(x: earnedCoins.frame.minX-25, y: gameOverDisplay.frame.maxY+coin.frame.height/1.75)
                    if earnedCoinsInt == intScore/2 || earnedCoinsInt == intScore {
                        lastTime = true
                    } else {
                        lastTime = false
                    }
                } else if earnedCoinsInt == intScore/2 || earnedCoinsInt == intScore {
                    if lastTime != nil {
                        if lastTime == true {
                            if let currCoins = UserDefaults.standard.object(forKey: "currentCoins") as? String {
                                if let intCurrCoins = Int(currCoins) {
                                    let coinsToSave = intCurrCoins+earnedCoinsInt
                                    UserDefaults.standard.set("\(coinsToSave)", forKey: "currentCoins")
                                    UserDefaults.standard.synchronize()
                                    lastTime = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func playAudio(_ fileName: String) {
        if let defaults = UserDefaults.standard.object(forKey: "audio") as? Bool {
            if defaults == true {
                self.run(SKAction.playSoundFileNamed(fileName, waitForCompletion: false))
            }
        }
    }
    
    func gameOver() {
        self.addChild(pauseLayer)
        gamePaused = false
        gameStarted = false
        gameIsOver = true
        self.removeChildren(in: [pauseBtn, score])

        self.addChild(coin)
        
        earnedCoins = SKLabelNode(fontNamed: "KenVector Future Thin")
        earnedCoins.text = "+\(earnedCoinsInt)"
        earnedCoins.scaleText(self, plus: 43, nor: 38, mini: 30)
        earnedCoins.position = CGPoint(x: coin.frame.maxX + 35, y: coin.position.y-coin.frame.height/2)
        earnedCoins.zPosition = 7
        self.addChild(earnedCoins)
        
        pauseOrStartSprites(true)
        
        self.addChild(gameOverDisplay)
        
        gameOverScore = SKLabelNode(fontNamed: "KenVector Future Thin")
        if UIDevice.current.userInterfaceIdiom == .pad {
            gameOverScore.fontSize = 70
        }
        gameOverScore.scaleText(self, plus: 70, nor: 65, mini: 50)
        gameOverScore.text = score.text
        gameOverScore.position = CGPoint(x: gameOverDisplay.frame.midX, y: gameOverDisplay.frame.maxY-(gameOverDisplay.frame.height/2.5))
        gameOverScore.zPosition = 8
        self.addChild(gameOverScore)
        
        Timer.scheduledTimer(timeInterval: 0.07, target: self, selector: #selector(addOne), userInfo: nil, repeats: true)
        
        highScoreLbl = SKLabelNode(fontNamed: "KenVector Future Thin")
        if UIDevice.current.userInterfaceIdiom == .pad {
            highScoreLbl.fontSize = 22
        }
        highScoreLbl.scaleText(self, plus: 21, nor: 18.5, mini: 16)
        
        if let highScore = UserDefaults.standard.object(forKey: "highScore") as? Int {
            if let currentScore = Int(score.text!) {
                if currentScore > highScore {
                    highScoreLbl.text = "high score: \(currentScore)"
                    UserDefaults.standard.set(currentScore, forKey: "highScore")
                    UserDefaults.standard.synchronize()
                } else {
                    highScoreLbl.text = "high score: \(highScore)"
                    UserDefaults.standard.set(highScore, forKey: "highScore")
                    UserDefaults.standard.synchronize()
                }
            }
        } else {
            if let currentScore = Int(score.text!) {
                highScoreLbl.text = "high score: \(currentScore)"
                UserDefaults.standard.set(currentScore, forKey: "highScore")
                UserDefaults.standard.synchronize()
            }
        }
        highScoreLbl.position = CGPoint(x: gameOverDisplay.frame.midX, y: gameOverScore.frame.minY - gameOverDisplay.frame.height/5)
        highScoreLbl.zPosition = 8
        self.addChild(highScoreLbl)
        
//        shareBtn = SKSpriteNode(texture: SKTexture(imageNamed: "shareBtn"))
//        shareBtn.scaleSprite(self, xScalePlus: 0.5, yScalePlus: 0.5, xScaleNor: 0.45, yScaleNor: 0.45, xScaleMini: 0.4, yScaleMini: 0.4)
//        shareBtn.position = CGPointMake(gameOverDisplay.frame.midX, highScoreLbl.frame.minY-shareBtn.frame.height/1.5)
//        shareBtn.zPosition = 8
//        self.addChild(shareBtn)
        self.addChild(gameOverMenuBtn)
        self.addChild(gameOverRestartLbl)
        self.addChild(gameOverMenuLbl)
        self.addChild(gameOverRestartBtn)
        btnsShown = false
        
        gameOverDisplay.run(SKAction.moveTo(x: sceneMidX+75, duration: 0.3), completion: {
            self.gameOverDisplay.run(SKAction.moveTo(x: self.sceneMidX-20, duration: 0.075), completion: {
                self.gameOverDisplay.run(SKAction.moveTo(x: self.sceneMidX, duration: 0.05), completion: {
                    self.animateLblEntrance(self.gameOverRestartLbl)
                    self.gameOverRestartBtn.run(SKAction.moveTo(x: self.sceneMidX+75, duration: 0.3), completion: {
                        self.gameOverRestartBtn.run(SKAction.moveTo(x: self.sceneMidX-20, duration: 0.075), completion: {
                            self.gameOverRestartBtn.run(SKAction.moveTo(x: self.sceneMidX, duration: 0.05), completion: {
                                self.animateLblEntrance(self.gameOverMenuLbl)
                                self.gameOverMenuBtn.run(SKAction.moveTo(x: self.sceneMidX+75, duration: 0.3), completion: {
                                    self.gameOverMenuBtn.run(SKAction.moveTo(x: self.sceneMidX-20, duration: 0.075), completion: {
                                        self.gameOverMenuBtn.run(SKAction.moveTo(x: self.sceneMidX, duration: 0.05))
                                    }) 
                                }) 
                            }) 
                        }) 
                    }) 
                }) 
            }) 
        }) 
//        animateSpriteEntrance(shareBtn)
        animateLblEntrance(highScoreLbl)
        animateLblEntrance(gameOverScore)
    }
    
    func animateSpriteEntrance(_ sprite: SKSpriteNode) {
        sprite.run(SKAction.moveTo(x: sceneMidX+75, duration: 0.3), completion: {
            sprite.run(SKAction.moveTo(x: self.sceneMidX-20, duration: 0.075), completion: {
                sprite.run(SKAction.moveTo(x: self.sceneMidX, duration: 0.05))
            }) 
        }) 
    }
    
    func animateLblEntrance(_ lbl: SKLabelNode) {
        lbl.run(SKAction.moveTo(x: sceneMidX+75, duration: 0.3), completion: {
            lbl.run(SKAction.moveTo(x: self.sceneMidX-20, duration: 0.075), completion: {
                lbl.run(SKAction.moveTo(x: self.sceneMidX, duration: 0.05))
            }) 
        }) 
    }
    
    func generateTraffic() {
        setRandomArrangement(randomNum)
        trafficOne = SKSpriteNode(texture: SKTexture(imageNamed: "car\(randomCarOne+1)"))
        scoreNodeOne = SKSpriteNode(color: UIColor.clear, size: CGSize(width: right_side_plate.width, height: trafficOne.size.height/2))
        trafficTwo = SKSpriteNode(texture: SKTexture(imageNamed: "car\(randomCarTwo+1)"))
        scoreNodeTwo = SKSpriteNode(color: UIColor.clear, size: CGSize(width: right_side_plate.width, height: trafficTwo.size.height/2))
        trafficThree = SKSpriteNode(texture: SKTexture(imageNamed: "car\(randomCarThree+1)"))
        scoreNodeThree = SKSpriteNode(color: UIColor.clear, size: CGSize(width: right_side_plate.width, height: trafficThree.size.height/2))
        
        trafficOne.setTrafficBehaviour(userCarGroup, trafficCategory: trafficGroup, pos: trafficOnePos, scene: self)
        trafficTwo.setTrafficBehaviour(userCarGroup, trafficCategory: trafficGroup, pos: trafficTwoPos, scene: self)
        trafficThree.setTrafficBehaviour(userCarGroup, trafficCategory: trafficGroup, pos: trafficThreePos, scene: self)
        scoreNodeOne.setScoreNodeBehaviour(scoreGroup, carCategory: userCarGroup, trafficSprite: trafficOne, scene: self, rightOrLeft: scoreNodeOnePos, rightPlate: right_side_plate, leftPlate: left_side_plate)
        scoreNodeTwo.setScoreNodeBehaviour(scoreGroup, carCategory: userCarGroup, trafficSprite: trafficTwo, scene: self, rightOrLeft: scoreNodeTwoPos, rightPlate: right_side_plate, leftPlate: left_side_plate)
        scoreNodeThree.setScoreNodeBehaviour(scoreGroup, carCategory: userCarGroup, trafficSprite: trafficThree, scene: self, rightOrLeft: scoreNodeThreePos, rightPlate: right_side_plate, leftPlate: left_side_plate)
    }
    
    func initUserCar() {
        userCar = SKSpriteNode(texture: SKTexture(imageNamed: carNum))
        userCar.scaleSprite(self, xScalePlus: 0.36, yScalePlus: 0.36, xScaleNor: 0.33, yScaleNor: 0.33, xScaleMini: 0.3, yScaleMini: 0.3)
        if rightOrLeft == 0 {
            //LEFT <--
            userCar.position = CGPoint(x: left_side_plate.midX, y: self.frame.height/4)
            carCurrentSide = 0
        } else {
            //RIGHT -->
            userCar.position = CGPoint(x: right_side_plate.midX, y: self.frame.height/4)
            carCurrentSide = 1
        }
        userCar.zPosition = 3
        userCar.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: userCar.size.width-8, height: userCar.size.height-8))
        userCar.physicsBody?.affectedByGravity = false
        userCar.physicsBody?.categoryBitMask = userCarGroup
        userCar.physicsBody?.contactTestBitMask = scoreGroup
        userCar.physicsBody?.contactTestBitMask = trafficGroup
        self.addChild(userCar)
    }
    
    func goToMenu() {
        let nextScene = GameScene(size: self.frame.size)
        nextScene.scaleMode = .aspectFill
        self.view?.presentScene(nextScene, transition: SKTransition.crossFade(withDuration: 0.2))
    }
}
