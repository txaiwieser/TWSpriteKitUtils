//
//  TWControl+NestedTypes.swift
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

extension TWControl {
    
    // MARK: Nested Types
    enum ControlEvent {
        
        case TouchDown // on all touch downs
        case TouchUpInside
        case TouchUpOutside
        case TouchCancel
        case TouchDragExit
        case TouchDragOutside
        case TouchDragEnter
        case TouchDragInside
        case ValueChanged // sliders, etc.
    }
    
    enum TWControlState {
        case Normal
        case Highlighted
        case Selected
        case Disabled
    }
    
    enum TWControlType {
        case Texture
        case Color
        case Label
    }
    
    
    // MARK: Helpers
    
    internal func playSound(#instanceSoundFileName:String?, defaultSoundFileName:String?) {
        if let soundFileName = instanceSoundFileName {
            let action = SKAction.playSoundFileNamed(soundFileName, waitForCompletion: true)
            self.runAction(action)
        }
        else if let soundFileName = defaultSoundFileName {
            let action = SKAction.playSoundFileNamed(soundFileName, waitForCompletion: true)
            self.runAction(action)
        }
    }
}


// MARK: Array Extension
extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerate(self) {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.removeAtIndex(index!)
        }
    }
}