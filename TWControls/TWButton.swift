//
//  TWButton.swift
//  SKControl Demo
//
//  Created by Txai Wieser on 25/02/15.
//  Copyright (c) 2015 Txai Wieser. All rights reserved.
//

import SpriteKit

class TWButton: TWControl {
    
    // MARK: Initializers
    init(normalText: String, highlightedText: String) {
        super.init(normalText: normalText, highlightedText: highlightedText, selectedText: normalText, disabledText: normalText)
    }
    
    init(normalTexture: SKTexture, highlightedTexture: SKTexture) {
        super.init(normalTexture: normalTexture, highlightedTexture: highlightedTexture, selectedTexture: normalTexture, disabledTexture: normalTexture)
    }
    
    init(normalColor: SKColor, highlightedColor: SKColor, size:CGSize) {
        super.init(normalColor: normalColor, highlightedColor: highlightedColor, selectedColor: normalColor, disabledColor: normalColor, size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: Button Methods
    
    var icon:SKSpriteNode? {
        willSet {
            if let oldValue = icon where oldValue.parent == self {
                oldValue.removeFromParent()
            }
        }
        didSet {
            if let newValue = icon {
                self.addChild(newValue)
                newValue.colorBlendFactor = 1
                if self.highlighted { newValue.color = self.stateHighlightedFontColor }
                else { newValue.color = self.stateNormalFontColor }

            }
        }
    }
    
    override var highlighted:Bool {
        set {
            super.highlighted = newValue
            if newValue { self.icon?.color = self.stateHighlightedFontColor }
            else { self.icon?.color = self.stateNormalFontColor }
        }
        get {
            return super.highlighted
        }
    }
}
