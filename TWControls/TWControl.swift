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

protocol TWControlDelegate: class {
    func controlValueChanged(control:TWControl)
}

class TWControl: SKSpriteNode {

    // MARK: Nested Types
    
    enum TWControlState: Int {
        case Normal = 0
        case Highlighted = 1
        case Selected = 2
        case Disabled = 3
    }
    
    enum TWControlType {
        case Texture
        case Color
        case Label
    }

    
    // Mark: Public Properties
    internal weak var delegate:TWControlDelegate!
    internal var boundsTolerance:CGFloat?
    internal var tag:Int?
    internal var isOn:Bool = false
    internal var enabled:Bool {
        get {
            return self.state != .Disabled
        }
        set {
            if newValue {
                self.state = .Normal
            }
            else {
                self.state = .Disabled
            }
            updateVisualInterface()
        }
    }
    
    internal var selected:Bool {
        get {
            return self.state == .Selected
        }
        set {
            if newValue {
                self.state = .Selected
            }
            else {
                self.state = .Normal
            }
            updateVisualInterface()
        }
    }
    
    internal var highlighted:Bool {
        get {
            return self.state == .Highlighted
        }
        set {
            if newValue {
                self.state = .Highlighted
            }
            else {
                self.state = .Normal
            }
            updateVisualInterface()
        }
    }
    
    
    
    
    // MARK: Customization Properties

    internal static var defaultTouchDownSoundFileName:String?
    internal static var defaultTouchUpSoundFileName:String?
    internal static var defaultDisabledTouchDownFileName:String?
    
    internal var touchDownSoundFileName:String?
    internal var touchUpSoundFileName:String?
    internal var disabledTouchDownFileName:String?
    
    
    // TYPE Color Customizations
    internal var stateDisabledColor:SKColor! { didSet { updateVisualInterface() } }
    internal var stateHighlightedColor:SKColor! { didSet { updateVisualInterface() } }
    internal var stateNormalColor:SKColor! { didSet { updateVisualInterface() } }
    internal var stateSelectedColor:SKColor! { didSet { updateVisualInterface() } }
    
    // TYPE Texture Customizations
    internal var stateDisabledTexture:SKTexture! { didSet { updateVisualInterface() } }
    internal var stateHighlightedTexture:SKTexture! { didSet { updateVisualInterface() } }
    internal var stateNormalTexture:SKTexture! { didSet { updateVisualInterface() } }
    internal var stateSelectedTexture:SKTexture! { didSet { updateVisualInterface() } }
    
    // TEXT Labels Customizations
    
    internal var stateDisabledLabelText:String? {
        didSet {
            if stateDisabledLabelText != nil { stateDisabledLabel.text = stateDisabledLabelText! }
        }
    }
    
    internal var stateHighlightedLabelText:String? {
        didSet {
            if stateHighlightedLabelText != nil { stateHighlightedLabel.text = stateHighlightedLabelText! }
        }
    }
    
    internal var stateNormalLabelText:String? {
        didSet {
            if stateNormalLabelText != nil { stateNormalLabel.text = stateNormalLabelText! }
        }
    }
    
    internal var stateSelectedLabelText:String? {
        didSet {
            if stateSelectedLabelText != nil { stateSelectedLabel.text = stateSelectedLabelText! }
        }
    }
    internal var allStatesLabelText:String! {
        didSet {
            stateDisabledLabelText = allStatesLabelText
            stateHighlightedLabelText = allStatesLabelText
            stateNormalLabelText = allStatesLabelText
            stateSelectedLabelText = allStatesLabelText
        }
    }
   
    internal var stateDisabledFontColor:SKColor! { didSet { stateDisabledLabel.fontColor = stateDisabledFontColor } }
    internal var stateHighlightedFontColor:SKColor! { didSet { stateHighlightedLabel.fontColor = stateHighlightedFontColor } }
    internal var stateNormalFontColor:SKColor! { didSet { stateNormalLabel.fontColor = stateNormalFontColor } }
    internal var stateSelectedFontColor:SKColor! { didSet { stateSelectedLabel.fontColor = stateSelectedFontColor } }
    internal var allStatesFontColor:SKColor! {
        didSet {
            stateDisabledFontColor = allStatesFontColor
            stateHighlightedFontColor = allStatesFontColor
            stateNormalFontColor = allStatesFontColor
            stateSelectedFontColor = allStatesFontColor
        }
    }
    
    internal var allStatesLabelFontSize:CGFloat! {
        didSet {
            stateDisabledLabel.fontSize = allStatesLabelFontSize
            stateHighlightedLabel.fontSize = allStatesLabelFontSize
            stateNormalLabel.fontSize = allStatesLabelFontSize
            stateSelectedLabel.fontSize = allStatesLabelFontSize
        }
    }
    
    internal var allStatesLabelFontName:String! {
        didSet {
            stateDisabledLabel.fontName = allStatesLabelFontName
            stateHighlightedLabel.fontName = allStatesLabelFontName
            stateNormalLabel.fontName = allStatesLabelFontName
            stateSelectedLabel.fontName = allStatesLabelFontName
        }
    }
    
    
    // Labels Direct Access
    internal let stateDisabledLabel:SKLabelNode = {
        let l = SKLabelNode()
        l.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        l.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        return l
    }()
    internal let stateHighlightedLabel:SKLabelNode = {
        let l = SKLabelNode()
        l.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        l.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        return l
    }()
    internal let stateNormalLabel:SKLabelNode = {
        let l = SKLabelNode()
        l.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        l.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        return l
    }()
    internal let stateSelectedLabel:SKLabelNode = {
        let l = SKLabelNode()
        l.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        l.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        return l
    }()
    
    
    
    
    
    
    
    
    // MARK: Private Properties

    private let type:TWControlType
    private var state:TWControlState = .Normal
    private var eventClosures:[(event: UIControlEvents, closure: TWControl -> ())] = []
    private var touch:UITouch?
    private var touchLocationLast:CGPoint?
    private var moved = false

    
    
    
    // MARK: Initializers
    
    init(normalTexture:SKTexture, highlightedTexture:SKTexture, selectedTexture:SKTexture, disabledTexture:SKTexture) {
        type = .Texture
        super.init(texture: normalTexture, color: nil, size: normalTexture.size())
        self.userInteractionEnabled = true

        self.stateDisabledTexture = disabledTexture
        self.stateHighlightedTexture = highlightedTexture
        self.stateNormalTexture = normalTexture
        self.stateSelectedTexture = selectedTexture
        
        self.addChild(self.stateDisabledLabel)
        self.addChild(self.stateHighlightedLabel)
        self.addChild(self.stateNormalLabel)
        self.addChild(self.stateSelectedLabel)
        updateVisualInterface()
    }
    
    init(normalColor:SKColor, highlightedColor:SKColor, selectedColor:SKColor, disabledColor:SKColor, size:CGSize) {
        type = .Color
        super.init(texture: nil, color: normalColor, size: size)
        self.userInteractionEnabled = true

        self.stateDisabledColor = disabledColor
        self.stateHighlightedColor = highlightedColor
        self.stateNormalColor = normalColor
        self.stateSelectedColor = selectedColor
        
        self.addChild(self.stateDisabledLabel)
        self.addChild(self.stateHighlightedLabel)
        self.addChild(self.stateNormalLabel)
        self.addChild(self.stateSelectedLabel)
        updateVisualInterface()
    }

    init(normalText:String, highlightedText:String, selectedText:String, disabledText:String) {
        type = .Label
        super.init(texture: nil, color: SKColor.blackColor(), size: CGSizeZero)
        self.userInteractionEnabled = true
        
        self.stateDisabledLabel.text = disabledText
        self.stateHighlightedLabel.text = highlightedText
        self.stateNormalLabel.text = normalText
        self.stateSelectedLabel.text = selectedText
        
        self.addChild(self.stateDisabledLabel)
        self.addChild(self.stateHighlightedLabel)
        self.addChild(self.stateNormalLabel)
        self.addChild(self.stateSelectedLabel)
        updateVisualInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    
    
    
    // MARK: Control Actions
    
    /**
    * Add a closure to a event action. You should use in your closure only the objects that are on the capture list of the closure (target)!
    Using objects capture automatically by the closure can cause cycle-reference, and your objects will never be deallocate. 
    You have to be VERY CAREFUL!
    */
    func addClosureFor<T: AnyObject>(event: UIControlEvents, target: T, closure: (target:T, sender:TWControl) -> ())
    {
        self.eventClosures.append((event:event , closure: { [weak target] (ctrl: TWControl) -> () in
            if let obj = target {
                closure(target: obj, sender: ctrl)
            }
            return
            }))
    }
    
    private func removeClosuresFor(event:UIControlEvents) {
        assertionFailure("TODO: Implement Remove Target")
    }

    private func executeClosuresOf(event: UIControlEvents) {
        for eventClosure in eventClosures {
            if eventClosure.event == event {
                eventClosure.closure(self)
            }
        }
    }
    
    
    
    
    // MARK: Control Functionality
    
    private func updateVisualInterface() {
        switch type {
            case .Color:
                switch state {
                case .Disabled:
                    self.color = self.stateDisabledColor
                case .Highlighted:
                    self.color = self.stateHighlightedColor
                case .Normal:
                    self.color = self.stateNormalColor
                case .Selected:
                    self.color = self.stateSelectedColor
            }
            case .Texture:
                switch state {
                case .Disabled:
                    self.texture = self.stateDisabledTexture
                    self.size = self.texture!.size()
                case .Highlighted:
                    self.texture = self.stateHighlightedTexture
                    self.size = self.texture!.size()
                case .Normal:
                    self.texture = self.stateNormalTexture
                    self.size = self.texture!.size()
                case .Selected:
                    self.texture = self.stateSelectedTexture
                    self.size = self.texture!.size()
            }
            case .Label:
                break //Doesnt need to do nothing
        }
        stateDisabledLabel.alpha = 0
        stateHighlightedLabel.alpha = 0
        stateNormalLabel.alpha = 0
        stateSelectedLabel.alpha = 0
        
        switch state {
        case .Disabled:
            stateDisabledLabel.alpha = 1
        case .Highlighted:
            stateHighlightedLabel.alpha = 1
        case .Normal:
            stateNormalLabel.alpha = 1
        case .Selected:
            stateSelectedLabel.alpha = 1
        }
    }
    
    // Control Events
    
    internal func touchDown() {
        self.highlighted = true
        playSound(instanceSoundFileName: touchDownSoundFileName, defaultSoundFileName: self.dynamicType.defaultTouchDownSoundFileName)
        executeClosuresOf(.TouchDown)
    }
    
    internal func disabledTouchDown() {
        playSound(instanceSoundFileName: disabledTouchDownFileName, defaultSoundFileName: self.dynamicType.defaultDisabledTouchDownFileName)
    }
    
    internal func drag() {}
    
    internal func dragExit() {
        self.highlighted = false
        executeClosuresOf(.TouchDragExit)
    }

    internal func dragOutside() {
        executeClosuresOf(.TouchDragOutside)
    }
    
    internal func dragEnter() {
        self.highlighted = true
        executeClosuresOf(.TouchDragEnter)
    }
    
    internal func dragInside() {
        executeClosuresOf(.TouchDragInside)
    }

    internal func touchUpInside() {
        self.highlighted = false
        executeClosuresOf(.TouchUpInside)
        playSound(instanceSoundFileName: touchUpSoundFileName, defaultSoundFileName: self.dynamicType.defaultTouchUpSoundFileName)
    }
    
    internal func touchUpOutside() {
        executeClosuresOf(.TouchUpOutside)
        playSound(instanceSoundFileName: touchUpSoundFileName, defaultSoundFileName: self.dynamicType.defaultTouchUpSoundFileName)
    }
    
    
    

    
    // MARK: UIResponder Methods
    
    internal override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchPoint = touch.locationInNode(self.parent)
        
        if self.containsPoint(touchPoint) {
            self.touch = touch
            self.touchLocationLast = touchPoint
            if self.state == .Disabled {
                disabledTouchDown()
            }
            else {
                touchDown()
            }
        }
    }
    
    internal override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if self.state == .Disabled { return }
        
        let touch = touches.first as! UITouch
        let touchPoint = touch.locationInNode(self.parent)
        
        drag()
        
        self.moved = true
        if self.containsPoint(touchPoint) {
            // Inside
            if let lastPoint = self.touchLocationLast where self.containsPoint(lastPoint) {
                // All along
                dragInside()
            }
            else {
                self.dragEnter()
            }
        }
        else {
            // Outside
            if let lastPoint = self.touchLocationLast where self.containsPoint(lastPoint) {
                // Since now
                dragExit()
            }
            else {
                // All along
                dragOutside()
            }
        }
        self.touchLocationLast = touchPoint
    }
    
    
    internal override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if self.state == .Disabled { return }
        
        let touch = touches.first as! UITouch
        let touchPoint = touch.locationInNode(self.parent)

        if self.moved {
            if let lastPoint = self.touchLocationLast where self.containsPoint(lastPoint) {
                // Ended inside
                touchUpInside()
            }
            else {
                // Ended outside
                touchUpOutside()
            }
        }
        else {
            // Needed??
            touchUpInside()
        }
        self.moved = false
    }
    
    
    internal override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        touchesEnded(touches, withEvent: event)
    }
    
    // .............................................................................
    
    
    
    // MARK: Helpers
    
    private func playSound(#instanceSoundFileName:String?, defaultSoundFileName:String?) {
        if let soundFileName = instanceSoundFileName {
            let action = SKAction.playSoundFileNamed(soundFileName, waitForCompletion: true)
            self.runAction(action)
        }
        else if let soundFileName = defaultSoundFileName {
            let action = SKAction.playSoundFileNamed(soundFileName, waitForCompletion: true)
            self.runAction(action)
        }
    }
    
    
    
    
    internal override func containsPoint(p: CGPoint) -> Bool {
        if let bounds = self.boundsTolerance {
            let local = CGPoint(x: p.x - self.position.x, y: p.y - self.position.y)
            
            let width = self.size.width + bounds
            let height = self.size.height + bounds
            
            if (fabs(local.x) <= 0.5*width) && (fabs(local.y) <= 0.5*height) {
                return true
            }
            return false
        }
        else {
            return super.containsPoint(p)
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