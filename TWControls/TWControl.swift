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

class TWControl: SKSpriteNode {

    // MARK: Initializers

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /**
    * Initializes a general TWControl of type .Texture
    */
    init(normalTexture:SKTexture, highlightedTexture:SKTexture, selectedTexture:SKTexture, disabledTexture:SKTexture) {
        type = .Texture
        super.init(texture: normalTexture, color: nil, size: normalTexture.size())
        self.userInteractionEnabled = true

        self.disabledStateTexture = disabledTexture
        self.highlightedStateTexture = highlightedTexture
        self.normalStateTexture = normalTexture
        self.selectedStateTexture = selectedTexture
        
        self.addChild(self.disabledStateLabel)
        self.addChild(self.highlightedStateLabel)
        self.addChild(self.normalStateLabel)
        self.addChild(self.selectedStateLabel)
        updateVisualInterface()
    }
    
    /**
    * Initializes a general TWControl of type .Color
    */
    init(normalColor:SKColor, highlightedColor:SKColor, selectedColor:SKColor, disabledColor:SKColor, size:CGSize) {
        type = .Color
        super.init(texture: nil, color: normalColor, size: size)
        self.userInteractionEnabled = true

        self.disabledStateColor = disabledColor
        self.highlightedStateColor = highlightedColor
        self.normalStateColor = normalColor
        self.selectedStateColor = selectedColor
        
        self.addChild(self.disabledStateLabel)
        self.addChild(self.highlightedStateLabel)
        self.addChild(self.normalStateLabel)
        self.addChild(self.selectedStateLabel)
        updateVisualInterface()
    }

    /**
    * Initializes a general TWControl of type .Text
    */
    init(normalText:String, highlightedText:String, selectedText:String, disabledText:String) {
        type = .Label
        super.init(texture: nil, color: SKColor.blackColor(), size: CGSizeZero)
        self.userInteractionEnabled = true
        
        self.disabledStateLabel.text = disabledText
        self.highlightedStateLabel.text = highlightedText
        self.normalStateLabel.text = normalText
        self.selectedStateLabel.text = selectedText
        
        self.addChild(self.disabledStateLabel)
        self.addChild(self.highlightedStateLabel)
        self.addChild(self.normalStateLabel)
        self.addChild(self.selectedStateLabel)
        updateVisualInterface()
    }
    

    
    // MARK: Control Actions
    
    /**
    * Add a closure to a event action. You should use in your closure only the objects that are on the capture list of the closure (target)!
    Using objects capture automatically by the closure can cause cycle-reference, and your objects will never be deallocate. 
    You have to be CAREFUL with this! Just pass your object to the function and use inside the closure.
    */
    func addClosure<T: AnyObject>(event: ControlEvent, target: T, closure: (target:T, sender:TWControl) -> ()) {
        self.eventClosures.append((event:event , closure: { [weak target] (ctrl: TWControl) -> () in
            if let obj = target {
                closure(target: obj, sender: ctrl)
            }
            return
            }))
    }
    
    /**
    * Removes all closure from a specific event.
    */
    func removeClosuresFor(event:ControlEvent) {
        assertionFailure("TODO: Implement Remove Target")
    }

    private func executeClosuresOf(event: ControlEvent) {
        for eventClosure in eventClosures {
            if eventClosure.event == event {
                eventClosure.closure(self)
            }
        }
    }
    
    
    
    
    
    
    // MARK: Public Properties
    
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
    internal var disabledStateColor:SKColor! { didSet { updateVisualInterface() } }
    internal var highlightedStateColor:SKColor! { didSet { updateVisualInterface() } }
    internal var normalStateColor:SKColor! { didSet { updateVisualInterface() } }
    internal var selectedStateColor:SKColor! { didSet { updateVisualInterface() } }
    
    // TYPE Texture Customizations
    internal var disabledStateTexture:SKTexture! { didSet { updateVisualInterface() } }
    internal var highlightedStateTexture:SKTexture! { didSet { updateVisualInterface() } }
    internal var normalStateTexture:SKTexture! { didSet { updateVisualInterface() } }
    internal var selectedStateTexture:SKTexture! { didSet { updateVisualInterface() } }
    
    // TEXT Labels Customizations
    
    internal var disabledStateLabelText:String? {
        didSet {
            if disabledStateLabelText != nil { disabledStateLabel.text = disabledStateLabelText! }
        }
    }
    
    internal var highlightedStateLabelText:String? {
        didSet {
            if highlightedStateLabelText != nil { highlightedStateLabel.text = highlightedStateLabelText! }
        }
    }
    
    internal var normalStateLabelText:String? {
        didSet {
            if normalStateLabelText != nil { normalStateLabel.text = normalStateLabelText! }
        }
    }
    
    internal var selectedStateLabelText:String? {
        didSet {
            if selectedStateLabelText != nil { selectedStateLabel.text = selectedStateLabelText! }
        }
    }
    internal var allStatesLabelText:String! {
        didSet {
            disabledStateLabelText = allStatesLabelText
            highlightedStateLabelText = allStatesLabelText
            normalStateLabelText = allStatesLabelText
            selectedStateLabelText = allStatesLabelText
        }
    }
    
    internal var disabledStateFontColor:SKColor! { didSet { disabledStateLabel.fontColor = disabledStateFontColor } }
    internal var highlightedStateFontColor:SKColor! { didSet { highlightedStateLabel.fontColor = highlightedStateFontColor } }
    internal var normalStateFontColor:SKColor! { didSet { normalStateLabel.fontColor = normalStateFontColor } }
    internal var selectedStateFontColor:SKColor! { didSet { selectedStateLabel.fontColor = selectedStateFontColor } }
    internal var allStatesFontColor:SKColor! {
        didSet {
            disabledStateFontColor = allStatesFontColor
            highlightedStateFontColor = allStatesFontColor
            normalStateFontColor = allStatesFontColor
            selectedStateFontColor = allStatesFontColor
        }
    }
    
    internal var allStatesLabelFontSize:CGFloat! {
        didSet {
            disabledStateLabel.fontSize = allStatesLabelFontSize
            highlightedStateLabel.fontSize = allStatesLabelFontSize
            normalStateLabel.fontSize = allStatesLabelFontSize
            selectedStateLabel.fontSize = allStatesLabelFontSize
        }
    }
    
    internal var allStatesLabelFontName:String! {
        didSet {
            disabledStateLabel.fontName = allStatesLabelFontName
            highlightedStateLabel.fontName = allStatesLabelFontName
            normalStateLabel.fontName = allStatesLabelFontName
            selectedStateLabel.fontName = allStatesLabelFontName
        }
    }
    
    
    
    internal static var defaultNormalLabelPosition = CGPointZero
    internal static var defaultSelectedLabelPosition = CGPointZero
    internal static var defaultHighlightedLabelPosition = CGPointZero
    internal static var defaultDisabledLabelPosition = CGPointZero
    internal static func setAllDefaultStatesLabelPosition(pos:CGPoint) {
        defaultNormalLabelPosition = pos
        defaultSelectedLabelPosition = pos
        defaultHighlightedLabelPosition = pos
        defaultDisabledLabelPosition = pos
    }
    
    internal var normalLabelPosition:CGPoint = defaultNormalLabelPosition { didSet { normalStateLabel.position = normalLabelPosition } }
    internal var selectedLabelPosition:CGPoint = defaultSelectedLabelPosition { didSet { selectedStateLabel.position = selectedLabelPosition } }
    internal var highlightedLabelPosition:CGPoint = defaultHighlightedLabelPosition { didSet { highlightedStateLabel.position = highlightedLabelPosition } }
    internal var disabledLabelPosition:CGPoint = defaultDisabledLabelPosition { didSet { disabledStateLabel.position = disabledLabelPosition } }
    internal func setAllStatesLabelPosition(pos:CGPoint) {
        normalLabelPosition = pos
        disabledLabelPosition = pos
        highlightedLabelPosition = pos
        selectedLabelPosition = pos
    }
    
    
    // MARK: Labels Direct Access
    
    lazy internal var normalStateLabel:SKLabelNode = {
        let l = SKLabelNode()
        l.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        l.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        l.position = self.normalLabelPosition
        return l
        }()
    lazy internal var selectedStateLabel:SKLabelNode = {
        let l = SKLabelNode()
        l.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        l.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        l.position = self.selectedLabelPosition
        return l
        }()
    lazy internal var highlightedStateLabel:SKLabelNode = {
        let l = SKLabelNode()
        l.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        l.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        l.position = self.highlightedLabelPosition
        return l
        }()
    lazy internal var disabledStateLabel:SKLabelNode = {
        let l = SKLabelNode()
        l.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        l.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        l.position = self.disabledLabelPosition
        return l
        }()
    
    
    
    
    
    
    
    
    // MARK: Private Properties
    
    private let type:TWControlType
    private var state:TWControlState = .Normal
    private var eventClosures:[(event: ControlEvent, closure: TWControl -> ())] = []
    private var touch:UITouch?
    private var touchLocationLast:CGPoint?
    private var moved = false

    
    // MARK: Control Functionality
    
    private func updateVisualInterface() {
        switch type {
            case .Color:
                switch state {
                case .Disabled:
                    self.color = self.disabledStateColor
                case .Highlighted:
                    self.color = self.highlightedStateColor
                case .Normal:
                    self.color = self.normalStateColor
                case .Selected:
                    self.color = self.selectedStateColor
            }
            case .Texture:
                switch state {
                case .Disabled:
                    self.texture = self.disabledStateTexture
                    self.size = self.texture!.size()
                case .Highlighted:
                    self.texture = self.highlightedStateTexture
                    self.size = self.texture!.size()
                case .Normal:
                    self.texture = self.normalStateTexture
                    self.size = self.texture!.size()
                case .Selected:
                    self.texture = self.selectedStateTexture
                    self.size = self.texture!.size()
            }
            case .Label:
                break //Doesnt need to do nothing
        }
        disabledStateLabel.alpha = 0
        highlightedStateLabel.alpha = 0
        normalStateLabel.alpha = 0
        selectedStateLabel.alpha = 0
        
        switch state {
        case .Disabled:
            disabledStateLabel.alpha = 1
        case .Highlighted:
            highlightedStateLabel.alpha = 1
        case .Normal:
            normalStateLabel.alpha = 1
        case .Selected:
            selectedStateLabel.alpha = 1
        }
    }
    
    
    
    
    
    
    // MARK: Control Events
    
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