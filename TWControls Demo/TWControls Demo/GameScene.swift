//
//  GameScene.swift
//  TWControls Demo
//
//  Created by Txai Wieser on 28/02/15.
//  Copyright (c) 2015 Txai Wieser. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // SWITCHES
    lazy var switchesContainer:SKSpriteNode = {
        let n = SKSpriteNode(color: SKColor.whiteColor(), size: CGSize(width: 220, height: 320))
        n.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetHeight(self.frame) - n.size.height/2 - 30)

        let l = SKLabelNode(text: "Switches")
        l.fontName = "Helvetica"
        l.fontColor = SKColor.blackColor()
        l.position = CGPoint(x: 0, y: n.size.height/2-l.frame.height - 10)
        n.addChild(l)
        return n
    }()
    
    let colorSwitch:TWSwitch = {
        let s = TWSwitch(normalColor: SKColor.blueColor(), selectedColor: SKColor.orangeColor(), size: CGSize(width: 102, height: 40))
        s.stateDisabledLabelText = "DISABLED"
        s.stateNormalLabelText = "ON"
        s.stateHighlightedLabelText = "ON"
        s.stateSelectedLabelText = "OFF"
        s.allStatesLabelFontSize = 20
        s.allStatesLabelFontName = "Helvetica"
        s.stateDisabledColor = SKColor.grayColor()
        s.position = CGPoint(x: 0, y: 40)
        return s
        }()
    
    let textureSwitch:TWSwitch = {
        let s = TWSwitch(normalTexture: SKTexture(imageNamed: "switch_off"), selectedTexture: SKTexture(imageNamed: "switch_on"))
        s.stateDisabledTexture = SKTexture(imageNamed: "switch_d")
        s.position = CGPoint(x: 0, y: -40)
        return s
        }()
    
    let textSwitch:TWSwitch = {
        let s = TWSwitch(normalText: "ON", selectedText: "OFF")
        s.stateDisabledLabelText = "DISABLED"
        s.allStatesFontColor = SKColor.blackColor()
        s.position = CGPoint(x: 0, y: -120)
        return s
        }()
    
    
    // BUTTONS
    lazy var buttonsContainer:SKSpriteNode = {
        let n = SKSpriteNode(color: SKColor.whiteColor(), size: CGSize(width: 220, height: 320))
        n.position = CGPoint(x: CGRectGetMidX(self.frame), y: n.size.height/2 + 30)
        
        let l = SKLabelNode(text: "Buttons")
        l.fontName = "Helvetica"
        l.fontColor = SKColor.blackColor()
        l.position = CGPoint(x: 0, y: n.size.height/2-l.frame.height - 10)
        n.addChild(l)
        return n
    }()
    
    let colorButton:TWButton = {
        let b = TWButton(normalColor: SKColor.purpleColor(), highlightedColor: SKColor.greenColor(), size: CGSize(width: 102, height: 40))
        b.stateDisabledColor = SKColor.grayColor()
        b.stateDisabledLabelText = "DISABLED"
        b.stateNormalLabelText = "PLAY"
        b.stateHighlightedLabelText = "PRESSED"
        b.allStatesLabelFontSize = 20
        b.allStatesLabelFontName = "Helvetica"
        b.position = CGPoint(x: 0, y: 40)
        return b
        }()
    
    let textureButton:TWButton = {
        let b = TWButton(normalTexture: SKTexture(imageNamed: "button_n"), highlightedTexture: SKTexture(imageNamed: "button_h"))
        b.stateDisabledTexture = SKTexture(imageNamed: "button_d")
        b.position = CGPoint(x: 0, y: -40)
        return b
        }()
    
    let textButton:TWButton = {
        let b = TWButton(normalText: "PLAY", highlightedText: "PRESSED")
        b.stateDisabledLabelText = "DISABLED"
        b.allStatesFontColor = SKColor.blackColor()
        b.position = CGPoint(x: 0, y: -120)
        return b
        }()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        TWControl.defaultTouchDownSoundFileName = "touchDownDefault.wav"
        TWControl.defaultTouchUpSoundFileName = "touchUpDefault.wav"
        
        textureButton.touchDownSoundFileName = "touchDown.wav"
        textureButton.touchUpSoundFileName = "touchUp.wav"
        
        textureSwitch.touchDownSoundFileName = "touchDown.wav"
        textureSwitch.touchUpSoundFileName = "touchUp.wav"
        
        self.backgroundColor = SKColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 1)
        
        self.addChild(switchesContainer)
        switchesContainer.addChild(colorSwitch)
        switchesContainer.addChild(textureSwitch)
        switchesContainer.addChild(textSwitch)
        
        self.addChild(buttonsContainer)
        buttonsContainer.addChild(colorButton)
        buttonsContainer.addChild(textureButton)
        buttonsContainer.addChild(textButton)
        
        
        colorSwitch.addClosureFor(.TouchUpInside, target: self) { (scene, control) -> () in
            scene.textureSwitch.enabled = control.isOn
            scene.textSwitch.enabled = control.isOn
        }
        
        textureSwitch.addClosureFor(.TouchUpInside, target: self) { (scene, control) -> () in
            scene.colorSwitch.enabled = control.isOn
            scene.textSwitch.enabled = control.isOn
        }
        
        textSwitch.addClosureFor(.TouchUpInside, target: self) { (scene, control) -> () in
            scene.colorSwitch.enabled = control.isOn
            scene.textureSwitch.enabled = control.isOn
        }
        
        colorButton.addClosureFor(.TouchUpInside, target: self) { (scene, control) -> () in
            scene.textureButton.enabled = !scene.textureButton.enabled
            scene.textButton.enabled = !scene.textButton.enabled
        }
        
        textureButton.addClosureFor(.TouchUpInside, target: self) { (scene, control) -> () in
            scene.colorButton.enabled = !scene.colorButton.enabled
            scene.textButton.enabled = !scene.textButton.enabled
        }
        
        textButton.addClosureFor(.TouchUpInside, target: self) { (scene, control) -> () in
            scene.colorButton.enabled = !scene.colorButton.enabled
            scene.textureButton.enabled = !scene.textureButton.enabled
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
