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
    let switchesContainer = SKSpriteNode(color: SKColor.lightGrayColor(), size: CGSize(width: 220, height: 320))
    
    let colorSwitch:TWSwitch = {
        let s = TWSwitch(normalColor: SKColor.blueColor(), selectedColor: SKColor.yellowColor(), size: CGSize(width: 150, height: 60))
        s.stateDisabledColor = SKColor.grayColor()
        return s
        }()
    
    let textureSwitch:TWSwitch = {
        let s = TWSwitch(normalTexture: SKTexture(imageNamed: "switch_off"), selectedTexture: SKTexture(imageNamed: "switch_on"))
        s.stateDisabledTexture = SKTexture(imageNamed: "switch_d")
        return s
        }()
    
    let textSwitch:TWSwitch = {
        let s = TWSwitch(normalText: "ON", selectedText: "OFF")
        s.stateDisabledLabelText = "DISABLED"
        return s
        }()
    
    
    // BUTTONS
    let buttonsContainer = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 220, height: 320))
    
    let colorButton:TWButton = {
        let b = TWButton(normalColor: SKColor.purpleColor(), highlightedColor: SKColor.greenColor(), size: CGSize(width: 150, height: 60))
        b.stateDisabledColor = SKColor.grayColor()
        return b
        }()
    
    let textureButton:TWButton = {
        let b = TWButton(normalTexture: SKTexture(imageNamed: "button_n"), highlightedTexture: SKTexture(imageNamed: "button_h"))
        b.stateDisabledTexture = SKTexture(imageNamed: "button_d")
        return b
        }()
    
    let textButton:TWButton = {
        let b = TWButton(normalText: "PLAY", highlightedText: "PRESSED")
        b.stateDisabledLabelText = "DISABLED"
        return b
        }()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        

        
        self.addChild(switchesContainer)
        switchesContainer.addChild(colorSwitch)
        switchesContainer.addChild(textureSwitch)
        switchesContainer.addChild(textSwitch)
        
        self.addChild(buttonsContainer)
        buttonsContainer.addChild(colorButton)
        buttonsContainer.addChild(textureButton)
        buttonsContainer.addChild(textButton)
        
        switchesContainer.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetHeight(self.frame) - switchesContainer.size.height/2 - 30)
        colorSwitch.position = CGPoint(x: 0, y: 150)
        textureSwitch.position = CGPoint(x: 0, y: 0)
        textSwitch.position = CGPoint(x: 0, y: -150)
        
        buttonsContainer.position = CGPoint(x: CGRectGetMidX(self.frame), y: buttonsContainer.size.height/2 + 30)
        colorButton.position = CGPoint(x: 0, y: 150)
        textureButton.position = CGPoint(x: 0, y: 0)
        textButton.position = CGPoint(x: 0, y: -150)
        
        
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
