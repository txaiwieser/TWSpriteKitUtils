//
//  TWButton.swift
//
//  The MIT License (MIT)
//
//  Created by Txai Wieser on 25/02/15.
//  Copyright (c) 2015 Txai Wieser.
//
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//
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
                if self.highlighted { newValue.color = self.highlightedStateFontColor }
                else { newValue.color = self.normalStateFontColor }

            }
        }
    }
    
    override var highlighted:Bool {
        set {
            super.highlighted = newValue
            if newValue { self.icon?.color = self.highlightedStateFontColor }
            else { self.icon?.color = self.normalStateFontColor }
        }
        get {
            return super.highlighted
        }
    }
}
