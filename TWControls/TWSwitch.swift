//
//  TWSwitch.swift
//  SKControl Demo
//
//  Created by Txai Wieser on 25/02/15.
//  Copyright (c) 2015 Txai Wieser. All rights reserved.
//

import SpriteKit

class TWSwitch: TWControl {

    
    
    // MARK: Initializers
    init(normalText: String, selectedText: String) {
        super.init(normalText: normalText, highlightedText: normalText, selectedText: selectedText, disabledText: normalText)
    }
    
    init(normalTexture: SKTexture, selectedTexture: SKTexture) {
        super.init(normalTexture: normalTexture, highlightedTexture: normalTexture, selectedTexture: selectedTexture, disabledTexture: normalTexture)
    }
    
    init(normalColor: SKColor, selectedColor: SKColor, size:CGSize) {
        super.init(normalColor: normalColor, highlightedColor: normalColor, selectedColor: selectedColor, disabledColor: normalColor, size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: Switch Methods
    
    override func touchUpInside() {
        
        super.touchUpInside()

        // Toggle Switch's selection state:
        self.isOn = !self.isOn
        
        // Display it using Control's "selected" state:
        self.selected = self.isOn
        
        
        self.delegate?.controlValueChanged(self)
    }
}