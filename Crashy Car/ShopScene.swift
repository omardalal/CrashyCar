//
//  shopScene.swift
//  Crashy Car
//
//  Created by Omar Dalal on 8/19/16.
//  Copyright © 2016 AmpeoTech. All rights reserved.
//

import SpriteKit
import UIKit

@available(iOS 9.0, *)
class ShopScene: SKScene {
    
    //SPRITE_NODES
    var topCoin: SKSpriteNode!
    var bottomCoin: SKSpriteNode!
    var backBtn: SKSpriteNode!
    var carImg: SKSpriteNode!
    var buyBtn: SKSpriteNode!
    var rightBtn: SKSpriteNode!
    var leftBtn: SKSpriteNode!
    var bg: SKSpriteNode!
    var chosenCar: SKSpriteNode!
    
    //LABEL_NODES
    var currentCoins: SKLabelNode!
    var carPrice: SKLabelNode!
    var buyBtnTxt = SKLabelNode()
    
    //VARS
    var recognizer: UISwipeGestureRecognizer!
    var isOnBackBtn = false
    var isOnBuyBtn = false
    var midXScene: CGFloat!
    var midYScene: CGFloat!
    var swipeArea: CGRect!
    var currentCar: Int!
    var carState: String!
    var isOnRightBtn = false
    var btnsEnabled = true
    var isOnLeftBtn = false
    var priceRect: CGRect!
    var purchasedCars = [String]()
    var fromShop: Bool!
    
    //SCROLLER
    weak var scrollView: CustomScrollView!
    let moveableNode = SKNode()
    
    //TEXTURES
    let buyBtnTexture = SKTexture(imageNamed: "menuBtn")
    let buyBtnTappedTexture = SKTexture(imageNamed: "menuBtnTapped")
    let backBtnTexture = SKTexture(imageNamed: "backBtn")
    let backBtnTappedTexture = SKTexture(imageNamed: "backBtnTapped")
    
    override func didMove(to view: SKView) {
        
        self.addChild(moveableNode)
        
        midXScene = self.frame.midX
        midYScene = self.frame.midY
        
        backBtn = SKSpriteNode(texture: backBtnTexture)
        backBtn.scaleSprite(self, xScalePlus: 0.58, yScalePlus: 0.58, xScaleNor: 0.52, yScaleNor: 0.52, xScaleMini: 0.465, yScaleMini: 0.465)
        backBtn.position = CGPoint(x: backBtn.frame.size.width/1.5, y: self.frame.size.height - backBtnTexture.size().height/3)
        backBtn.zPosition = 0
        self.addChild(backBtn)
        
        if let cars = UserDefaults.standard.object(forKey: "purchasedCars") as? [String] {
            purchasedCars = cars
        }
        
        buyBtn = SKSpriteNode(texture: buyBtnTexture)
        buyBtn.scaleSprite(self, xScalePlus: 0.65, yScalePlus: 0.65, xScaleNor: 0.6, yScaleNor: 0.6, xScaleMini: 0.5, yScaleMini: 0.5)
        buyBtn.position = CGPoint(x: midXScene, y: buyBtnTexture.size().height/2)
        buyBtn.zPosition = 0
        self.addChild(buyBtn)
        
        buyBtnTxt.createMenuBtnLbl(buyBtn, text: "buy", gameOver: false, add: true, scene: self)

        currentCoins = SKLabelNode(fontNamed: "KenVector Future Thin")
        currentCoins.position = CGPoint(x: self.frame.maxX-self.frame.maxX/6, y: backBtn.frame.minY + backBtn.frame.height/4)
        scalePrice(currentCoins)
        if UIDevice.current.userInterfaceIdiom == .pad {
            currentCoins.fontSize = 60
        }
        if let userCoins =  UserDefaults.standard.object(forKey: "currentCoins") as? String {
            currentCoins.text = userCoins
        } else {
            currentCoins.text = "150"
            UserDefaults.standard.set("\(currentCoins.text!)", forKey: "currentCoins")
            UserDefaults.standard.synchronize()
        }
        self.addChild(currentCoins)
        
        topCoin = SKSpriteNode(texture: SKTexture(imageNamed: "coin"))
        scaleCoin(topCoin)
        topCoin.position = CGPoint(x: currentCoins.frame.minX-topCoin.frame.width/1.5, y: currentCoins.frame.midY)
        topCoin.zPosition = 0
        self.addChild(topCoin)
        
        bg = SKSpriteNode(texture: SKTexture(imageNamed: "bg"))
        bg.position = CGPoint(x: midXScene, y: midYScene)
        bg.zPosition = -1
        self.addChild(bg)
        
        rightBtn = SKSpriteNode(texture: SKTexture(imageNamed: "rightBtn"))
        rightBtn.scaleSprite(self, xScalePlus: 0.6, yScalePlus: 0.6, xScaleNor: 0.58, yScaleNor: 0.58, xScaleMini: 0.5, yScaleMini: 0.5)
        rightBtn.position = CGPoint(x: self.frame.maxX - rightBtn.frame.size.width/1.5, y: midYScene+rightBtn.frame.size.height/2)
        rightBtn.zPosition = 1
        self.addChild(rightBtn)
        
        leftBtn = SKSpriteNode(texture: SKTexture(imageNamed: "leftBtn"))
        leftBtn.scaleSprite(self, xScalePlus: 0.6, yScalePlus: 0.6, xScaleNor: 0.58, yScaleNor: 0.58, xScaleMini: 0.5, yScaleMini: 0.5)
        leftBtn.position = CGPoint(x: leftBtn.frame.size.width/1.5, y: midYScene+leftBtn.frame.size.height/2)
        leftBtn.zPosition = 1
        self.addChild(leftBtn)
        
        scrollView = CustomScrollView(frame: CGRect(x: 0, y: self.frame.height/4, width: self.frame.size.width, height: self.frame.height/2), moveableNode: moveableNode, scrollDirection: .horizontal)
        scrollView.contentSize = CGSize(width: self.frame.width*30, height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.setContentOffset(CGPoint(x: (30 - 1)*self.frame.width, y: 0.0), animated: true)
        self.view?.addSubview(scrollView)
        currentCar = scrollView.setCarName()
        
        carPrice = SKLabelNode(fontNamed: "KenVector Future Thin")
        scalePrice(carPrice)
        carPrice.text = ""
        if UIDevice.current.userInterfaceIdiom == .pad {
            carPrice.fontSize = 60
        }
        carPrice.zPosition = 1
        self.addChild(carPrice)
        
        bottomCoin = SKSpriteNode(texture: SKTexture(imageNamed: "coin"))
        bottomCoin.zPosition = 3
        scaleCoin(bottomCoin)
        self.addChild(bottomCoin)
        print(self.frame.maxX)
        if UIDevice.current.userInterfaceIdiom == .pad {
            priceRect = CGRect(x: 0, y: buyBtn.frame.maxY, width: self.frame.width, height: (midYScene-161.5)-buyBtn.frame.maxY)
            carPrice.position = CGPoint(x: priceRect.midX+50, y: priceRect.midY)
            bottomCoin.position = CGPoint(x: carPrice.frame.minX-69.5, y: carPrice.frame.midY)
        } else {
            priceRect = CGRect(x: 0, y: buyBtn.frame.maxY, width: self.frame.width, height: (midYScene-80.75)-buyBtn.frame.maxY)
            carPrice.position = CGPoint(x: priceRect.midX+35, y: priceRect.midY)
            bottomCoin.position = CGPoint(x: carPrice.frame.minX-34.75, y: carPrice.frame.midY)
        }
        print(self.frame.maxX)
        
        for i in 1...30 {
            carImg = SKSpriteNode(texture: SKTexture(imageNamed: "car\(i)"))
            carImg.scaleSprite(self, xScalePlus: 0.65, yScalePlus: 0.65, xScaleNor: 0.6, yScaleNor: 0.6, xScaleMini: 0.543, yScaleMini: 0.543)
            carImg.name = "car\(i)"
            if !purchasedCars.contains("car\(currentCar)") {
                carImg.alpha = 0.7
            }
            carImg.position = CGPoint(x: (0.5 * (self.frame.size.width)+(CGFloat(i-30)*(self.frame.size.width))), y: scrollView.frame.midY)
            carImg.zPosition = 1
            moveableNode.addChild(carImg)
        }
        chosenCar = moveableNode.childNode(withName: "car\(currentCar)") as! SKSpriteNode!

        if let shopVar = fromShop {
            if !shopVar {
                moveScrollView("start")
            }
        }
    }
    
    func scaleCoin(_ coin: SKSpriteNode) {
        coin.scaleSprite(self, xScalePlus: 0.5, yScalePlus: 0.5, xScaleNor: 0.48, yScaleNor: 0.48, xScaleMini: 0.4, yScaleMini: 0.4)
    }
    
    func scalePrice(_ priceText: SKLabelNode) {
        priceText.scaleText(self, plus: 41, nor: 37, mini: 33)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLoc = touches.first?.location(in: self) {
            if btnsEnabled {
                if rightBtn.contains(touchLoc) {
                    isOnRightBtn = true
                    rightBtn.texture = SKTexture(imageNamed: "rightBtnTapped")
                }
                if leftBtn.contains(touchLoc) {
                    isOnLeftBtn = true
                    leftBtn.texture = SKTexture(imageNamed: "leftBtnTapped")
                }
            }
            if backBtn.contains(touchLoc) {
                isOnBackBtn = true
                backBtn.texture = backBtnTappedTexture
            } else if buyBtn.contains(touchLoc) {
                isOnBuyBtn = true
                buyBtn.texture = buyBtnTappedTexture
                buyBtnTxt.setLblPos(buyBtn, amountDown: 10)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       for touch in touches {
        let touchLoc = touch.location(in: self)
            if isOnBackBtn {
                if !backBtn.contains(touchLoc) {
                    isOnBackBtn = false
                    backBtn.texture = backBtnTexture
                }
            }
            if isOnBuyBtn {
                if !buyBtn.contains(touchLoc) {
                    isOnBuyBtn = false
                    buyBtn.texture = buyBtnTexture
                    buyBtnTxt.setLblPos(buyBtn, amountDown: 8)
                }
            }
        if isOnRightBtn {
            if !rightBtn.contains(touchLoc) {
                isOnRightBtn = false
                rightBtn.texture = SKTexture(imageNamed: "rightBtn")
            }
        }
        if isOnLeftBtn {
            if !leftBtn.contains(touchLoc) {
                isOnLeftBtn = false
                leftBtn.texture = SKTexture(imageNamed: "leftBtn")
            }
        }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOnLeftBtn {
            playMenuBtnSound(self)
            isOnLeftBtn = false
            moveScrollView("back")
            btnsEnabled = false
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(enableBtns), userInfo: nil, repeats: false)
        }
        if isOnRightBtn {
            playMenuBtnSound(self)
            isOnRightBtn = false
            moveScrollView("forward")
            btnsEnabled = false
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(enableBtns), userInfo: nil, repeats: false)
        }
        if isOnBackBtn {
            playMenuBtnSound(self)
            let nextScene = GameScene(size: self.frame.size)
            scrollView.removeFromSuperview()
            scrollView.isUserInteractionEnabled = false
            scrollView.isHidden = true
            nextScene.scaleMode = .aspectFill
            self.view?.presentScene(nextScene, transition: SKTransition.crossFade(withDuration: 0.2))
        } else if isOnBuyBtn {
            playMenuBtnSound(self)
            if buyBtnTxt.text == "start" {
                let nextScene = gameplayScene(size: self.frame.size)
                nextScene.customCamera.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
                nextScene.addChild(nextScene.customCamera)
                nextScene.camera = nextScene.customCamera
                let zoomInAction = SKAction.scale(to: 0.5, duration: 0)
                let rotateAction = SKAction.rotate(toAngle: 0.785398, duration: 0)
                nextScene.customCamera.run(zoomInAction)
                nextScene.customCamera.run(rotateAction)
                nextScene.scaleMode = .aspectFill
                if let curCar = currentCar {
                    nextScene.carNum = "car\(curCar)"
                }
                UserDefaults.standard.set(scrollView.page, forKey: "lastCar")
                UserDefaults.standard.synchronize()
                scrollView.removeFromSuperview()
                scrollView.isUserInteractionEnabled = false
                scrollView.isHidden = true
                self.view?.presentScene(nextScene, transition: SKTransition.crossFade(withDuration: 0.2))
            } else {
                if let coins = currentCoins.text {
                    if let intCurrentCoins = Int(coins) {
                        if let price = carPrice.text {
                            if let intPrice = Int(price) {
                                if intCurrentCoins >= intPrice {
                                    setCarPriceProp(1)
                                    if let curCar = currentCar {
                                        purchasedCars.append("car\(curCar)")
                                        print(purchasedCars)
                                        if let defaults = UserDefaults.standard.object(forKey: "audio") as? Bool {
                                            if defaults == true {
                                                self.run(SKAction.playSoundFileNamed("cash.wav", waitForCompletion: false))
                                            }
                                        }
                                        UserDefaults.standard.set(purchasedCars, forKey: "purchasedCars")
                                        UserDefaults.standard.synchronize()
                                    }
                                    var userCoins = intCurrentCoins
                                    userCoins -= intPrice
                                    currentCoins.text = "\(userCoins)"
                                    UserDefaults.standard.set(currentCoins.text, forKey: "currentCoins")
                                    UserDefaults.standard.synchronize()
                                }
                            }
                        }
                    }
                }
            }
        }
        leftBtn.texture = SKTexture(imageNamed: "leftBtn")
        rightBtn.texture = SKTexture(imageNamed: "rightBtn")
        backBtn.texture = backBtnTexture
        buyBtn.texture = buyBtnTexture
        isOnBuyBtn = false
        isOnBackBtn = false
        buyBtnTxt.setLblPos(buyBtn, amountDown: 8)
    }
    
    override func update(_ currentTime: TimeInterval) {
        setCarPrice()
    }
    
    func setCarPrice() {
        if let curCar = currentCar {
            chosenCar = moveableNode.childNode(withName: "car\(curCar)") as! SKSpriteNode!
            if scrollView.page == 29 {
                setCarPriceProp(1)
            } else {
                if purchasedCars.contains("car\(curCar)") {
                    setCarPriceProp(1)
                } else {
                    setCarPriceProp(0)
                }
            }
        }
        
    }
    
    func enableBtns() {
        btnsEnabled = true
    }
    
    func setCarPriceProp(_ state: Int) {
        currentCar = scrollView.setCarName()
        if let curCar = currentCar {
            if state == 1 {
                moveableNode.childNode(withName: "car\(curCar)")?.alpha = 1
                buyBtnTxt.text = "start"
                carPrice.text = ""
                bottomCoin.isHidden = true
            } else {
                if scrollView.page == 28 || scrollView.page == 27 || scrollView.page == 26 || scrollView.page == 25 {
                    carPrice.text = "60"
                } else if scrollView.page == 24 || scrollView.page == 23 || scrollView.page == 22 || scrollView.page == 21 || scrollView.page == 20 {
                    carPrice.text = "125"
                } else if scrollView.page == 19 || scrollView.page == 18 || scrollView.page == 17 || scrollView.page == 16 || scrollView.page == 15 {
                    carPrice.text = "190"
                } else if scrollView.page == 14 || scrollView.page == 13 || scrollView.page == 12 || scrollView.page == 11 || scrollView.page == 10 {
                    carPrice.text = "250"
                } else if scrollView.page == 9 || scrollView.page == 8 || scrollView.page == 7 || scrollView.page == 6 || scrollView.page == 5 {
                    carPrice.text = "400"
                } else if scrollView.page == 4 || scrollView.page == 3 || scrollView.page == 2 || scrollView.page == 1 || scrollView.page == 0 {
                    carPrice.text = "520"
                }
                moveableNode.childNode(withName: "car\(curCar)")?.alpha = 0.7
                carPrice.position = CGPoint(x: priceRect.midX+carImg.frame.width/4, y: priceRect.midY)
                buyBtnTxt.text = "buy"
                bottomCoin.isHidden = false
                bottomCoin.position = CGPoint(x: carPrice.frame.minX-carImg.frame.width/2.5, y: carPrice.frame.midY)
            }
        }
    }
    
    func moveScrollView(_ backOrForward: String) {
        if backOrForward == "back" {
            scrollView.scrollRectToVisible(CGRect(x: scrollView.contentOffset.x+self.frame.width, y: 0.0, width: self.frame.width, height: scrollView.frame.height), animated: true)
        } else if backOrForward == "forward" {
                scrollView.scrollRectToVisible(CGRect(x: scrollView.contentOffset.x-self.frame.width, y: 0.0, width: self.frame.width, height: scrollView.frame.height), animated: true)
        } else {
            if let savedCar = UserDefaults.standard.object(forKey: "lastCar") as? CGFloat {
                scrollView.scrollRectToVisible(CGRect(x: self.frame.width*savedCar, y: 0.0, width: self.frame.width, height: scrollView.frame.width), animated: true)
            }
        }
    }
}
