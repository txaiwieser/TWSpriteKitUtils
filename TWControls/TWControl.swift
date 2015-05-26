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

class TWControl: SKNode {

    // MARK: Initializers

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /**
    * Initializes a general TWControl of type .Texture with a single highlighted texture possibility
    */
    init(normalTexture:SKTexture, selectedTexture:SKTexture?, singleHighlightedTexture:SKTexture?, disabledTexture:SKTexture?) {
        type = .Texture
        super.init()
        self.generalSprite = SKSpriteNode(texture: normalTexture, color: nil, size: normalTexture.size())
        self.addChild(self.generalSprite)
        self.userInteractionEnabled = true

        self.disabledStateTexture = disabledTexture
        self.highlightedStateSingleTexture = singleHighlightedTexture
        self.normalStateTexture = normalTexture
        self.selectedStateTexture = selectedTexture
        
        updateVisualInterface()
    }
    
    /**
    * Initializes a general TWControl of type .Texture with multiple highlighted textures possibility
    */
    init(normalTexture:SKTexture, selectedTexture:SKTexture?, multiHighlightedTexture:(fromNormal:SKTexture?, fromSelected:SKTexture?), disabledTexture:SKTexture?) {
        type = .Texture
        super.init()
        self.generalSprite = SKSpriteNode(texture: normalTexture, color: nil, size: normalTexture.size())
        self.addChild(self.generalSprite)
        self.userInteractionEnabled = true
        
        self.disabledStateTexture = disabledTexture
        self.highlightedStateMultiTextureFromNormal = multiHighlightedTexture.fromNormal
        self.highlightedStateMultiTextureFromNormal = multiHighlightedTexture.fromSelected
        self.normalStateTexture = normalTexture
        self.selectedStateTexture = selectedTexture
        
        updateVisualInterface()
    }
    
    
    /**
    * Initializes a general TWControl of type .Shape with a single highlighted texture possibility
    */
    init(normalShape:SKShapeNode.Definition, selectedShape:SKShapeNode.Definition?, singleHighlightedShape:SKShapeNode.Definition?, disabledShape:SKShapeNode.Definition?) {
        type = .Shape
        super.init()
        self.generalShape = SKShapeNode(definition: normalShape)
        self.addChild(self.generalShape)
        self.userInteractionEnabled = true
        
        self.disabledStateShapeDef = disabledShape
        self.highlightedStateSingleShapeDef = singleHighlightedShape
        self.normalStateShapeDef = normalShape
        self.selectedStateShapeDef = selectedShape
        
        updateVisualInterface()
    }
    
    /**
    * Initializes a general TWControl of type .Shape with multiple highlighted textures possibility
    */
    init(normalShape:SKShapeNode, selectedShape:SKShapeNode?, multiHighlightedShape:(fromNormal:SKShapeNode?, fromSelected:SKShapeNode?), disabledShape:SKShapeNode?) {
        type = .Shape
        super.init()
        self.generalShape = normalShape
        self.addChild(self.generalShape)
        self.userInteractionEnabled = true
        
        self.disabledStateShapeDef = SKShapeNode.Definition(disabledShape)
        self.highlightedStateMultiShapeFromNormalDef = SKShapeNode.Definition(multiHighlightedShape.fromNormal)
        self.highlightedStateMultiShapeFromNormalDef = SKShapeNode.Definition(multiHighlightedShape.fromSelected)
        self.normalStateShapeDef = SKShapeNode.Definition(normalShape)
        self.selectedStateShapeDef = SKShapeNode.Definition(selectedShape)
        
        updateVisualInterface()
    }
    
    
    /**
    * Initializes a general TWControl of type .Color with a single highlighted color possibility
    */
    init(size:CGSize, normalColor:SKColor, selectedColor:SKColor?, singleHighlightedColor:SKColor?, disabledColor:SKColor?) {
        type = .Color
        super.init()
        self.generalSprite = SKSpriteNode(texture: nil, color: normalColor, size: size)
        self.addChild(self.generalSprite)
        self.userInteractionEnabled = true

        self.disabledStateColor = disabledColor
        self.highlightedStateSingleColor = singleHighlightedColor
        self.normalStateColor = normalColor
        self.selectedStateColor = selectedColor
        
        updateVisualInterface()
    }

    /**
    * Initializes a general TWControl of type .Color with with multiple highlighted color possibility
    */
    init(size:CGSize, normalColor:SKColor, selectedColor:SKColor?, multiHighlightedColor:(fromNormal:SKColor?, fromSelected:SKColor?), disabledColor:SKColor?) {
        type = .Color
        super.init()
        self.generalSprite = SKSpriteNode(texture: nil, color: normalColor, size: size)
        self.addChild(self.generalSprite)
        self.userInteractionEnabled = true
        
        self.disabledStateColor = disabledColor
        self.highlightedStateMultiColorFromNormal = multiHighlightedColor.fromNormal
        self.highlightedStateMultiColorFromSelected = multiHighlightedColor.fromSelected
        self.normalStateColor = normalColor
        self.selectedStateColor = selectedColor
        
        updateVisualInterface()
    }
    
    
    
    
    
    /**
    * Initializes a general TWControl of type .Text with multiple highlighted color possibility
    */
    init(normalText:String, selectedText:String?, singleHighlightedText:String?, disabledText:String?) {
        type = .Label
        super.init()
        self.generalSprite = SKSpriteNode(texture: nil, color: SKColor.blackColor(), size: CGSizeZero)
        self.addChild(self.generalSprite)
        self.userInteractionEnabled = true
        
        setNormalStateLabelText(normalText)
        setSelectedStateLabelText(selectedText)
        setDisabledStateLabelText(disabledText)
        setHighlightedStateSingleLabelText(singleHighlightedText)
        
        updateVisualInterface()
    }
    
    /**
    * Initializes a general TWControl of type .Text with multiple highlighted color possibility
    */
    init(normalText:String, selectedText:String?, multiHighlightedText:(fromNormal:String?, fromSelected:String?), disabledText:String?)  {
        type = .Label
        super.init()
        self.generalSprite = SKSpriteNode(texture: nil, color: SKColor.blackColor(), size: CGSizeZero)
        self.addChild(self.generalSprite)
        self.userInteractionEnabled = true
        
        setNormalStateLabelText(normalText)
        setSelectedStateLabelText(selectedText)
        setDisabledStateLabelText(disabledText)
        setHighlightedStateMultiLabelTextFromNormal(multiHighlightedText.fromNormal)
        setHighlightedStateMultiLabelTextFromSelected(multiHighlightedText.fromSelected)
        
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
    
    internal var size:CGSize { get { return self.calculateAccumulatedFrame().size } }
    internal var boundsTolerance:CGFloat?
    internal var tag:Int?
    internal var enabled:Bool {
        get {
            return self.state != .Disabled
        }
        set {
            if newValue {
                self.state = .Normal
            } else {
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
            } else {
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
            } else {
                self.state = .Normal
            }
            updateVisualInterface()
        }
    }
    
    
    func setGeneralTouchProperties(changes:(node:SKNode)->()) {
        if generalSprite != nil {
            changes(node: generalSprite)
        } else if generalShape != nil {
            changes(node: generalShape)
        }
    }
    
    
    // MARK: General Nodes
    
    private(set) var generalSprite:SKSpriteNode!
    private(set) var generalShape:SKShapeNode!
    
    // MARK: Sound Properties
    
    internal static var defaultTouchDownSoundFileName:String?
    internal static var defaultTouchUpSoundFileName:String?
    internal static var defaultDisabledTouchDownFileName:String?
    
    internal var touchDownSoundFileName:String?
    internal var touchUpSoundFileName:String?
    internal var disabledTouchDownFileName:String?
    
    
    
    // MARK: COLOR Type Customizations
    
    internal var normalStateColor:SKColor! { didSet { updateVisualInterface() } }
    internal var selectedStateColor:SKColor? { didSet { updateVisualInterface() } }
    internal var disabledStateColor:SKColor? { didSet { updateVisualInterface() } }
    internal var highlightedStateSingleColor:SKColor? { didSet { updateVisualInterface() } }
    internal var highlightedStateMultiColorFromNormal:SKColor? { didSet { updateVisualInterface() } }
    internal var highlightedStateMultiColorFromSelected:SKColor? { didSet { updateVisualInterface() } }
    

    
    
    // MARK: TEXTURE Type Customizations

    internal var normalStateTexture:SKTexture! { didSet { updateVisualInterface() } }
    internal var selectedStateTexture:SKTexture? { didSet { updateVisualInterface() } }
    internal var disabledStateTexture:SKTexture? { didSet { updateVisualInterface() } }
    internal var highlightedStateSingleTexture:SKTexture? { didSet { updateVisualInterface() } }
    internal var highlightedStateMultiTextureFromNormal:SKTexture? { didSet { updateVisualInterface() } }
    internal var highlightedStateMultiTextureFromSelected:SKTexture? { didSet { updateVisualInterface() } }
    
    
    // MARK: SHAPE Type Customizations
    
    internal var normalStateShapeDef:SKShapeNode.Definition! { didSet { updateVisualInterface() } }
    internal var selectedStateShapeDef:SKShapeNode.Definition? { didSet { updateVisualInterface() } }
    internal var disabledStateShapeDef:SKShapeNode.Definition? { didSet { updateVisualInterface() } }
    internal var highlightedStateSingleShapeDef:SKShapeNode.Definition? { didSet { updateVisualInterface() } }
    internal var highlightedStateMultiShapeFromNormalDef:SKShapeNode.Definition? { didSet { updateVisualInterface() } }
    internal var highlightedStateMultiShapeFromSelectedDef:SKShapeNode.Definition? { didSet { updateVisualInterface() } }
    
    
    
    
    
    
    
    
    
    
    // MARK: TEXT Type Customizations
    
    private var normalStateLabel:SKLabelNode? { didSet { updateVisualInterface() } }
    private var selectedStateLabel:SKLabelNode? { didSet { updateVisualInterface() } }
    private var disabledStateLabel:SKLabelNode? { didSet { updateVisualInterface() } }
    private var highlightedStateSingleLabel:SKLabelNode? { didSet { updateVisualInterface() } }
    private var highlightedStateMultiLabelFromNormal:SKLabelNode? { didSet { updateVisualInterface() } }
    private var highlightedStateMultiLabelFromSelected:SKLabelNode? { didSet { updateVisualInterface() } }
    
    
    // Labels Text Setters
    
    func setNormalStateLabelText(text:String?) {
        self.setLabelText(&normalStateLabel, text: text, pos: normalStateLabelPosition)
    }
    func setSelectedStateLabelText(text:String?) {
        self.setLabelText(&selectedStateLabel, text: text, pos: selectedStateLabelPosition)
    }
    func setDisabledStateLabelText(text:String?) {
        self.setLabelText(&disabledStateLabel, text: text, pos: disabledStateLabelPosition)
    }
    func setHighlightedStateSingleLabelText(text:String?) {
        self.setLabelText(&highlightedStateSingleLabel, text: text, pos: highlightedStateSingleLabelPosition)
    }
    func setHighlightedStateMultiLabelTextFromNormal(text:String?) {
        self.setLabelText(&highlightedStateMultiLabelFromNormal, text: text, pos: highlightedStateMultiLabelPositionFromNormal)
    }
    func setHighlightedStateMultiLabelTextFromSelected(text:String?) {
        self.setLabelText(&highlightedStateMultiLabelFromSelected, text: text, pos: highlightedStateMultiLabelPositionFromSelected)
    }
    private func setLabelText(inout label:SKLabelNode?, text:String?, pos:CGPoint) {
        if let newText = text {
            if label == nil {
                label = generalLabel()
                label!.position = pos
                self.addChild(label!)
            }
            label!.text = newText
        } else {
            label?.removeFromParent()
            label = nil
        }
    }
    private func generalLabel() -> SKLabelNode {
        let l = SKLabelNode()
        l.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        l.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        return l
    }
    
    
    
    // Labels Font Size Setter

    func setAllStatesLabelFontSize(size:CGFloat) {
        normalStateLabel?.fontSize = size
        selectedStateLabel?.fontSize = size
        disabledStateLabel?.fontSize = size
        highlightedStateSingleLabel?.fontSize = size
        highlightedStateMultiLabelFromNormal?.fontSize = size
        highlightedStateMultiLabelFromSelected?.fontSize = size
    }
    
    // Labels Font Name Setter
    
    func setAllStatesLabelFontName(fontName:String) {
        normalStateLabel?.fontName = fontName
        selectedStateLabel?.fontName = fontName
        disabledStateLabel?.fontName = fontName
        highlightedStateSingleLabel?.fontName = fontName
        highlightedStateMultiLabelFromNormal?.fontName = fontName
        highlightedStateMultiLabelFromSelected?.fontName = fontName
    }
    
    // Labels Font Color Setter

    func setNormalStateLabelFontColor(color:SKColor) {
        normalStateLabel?.fontColor = color
    }
    func setSelectedStateLabelFontColor(color:SKColor) {
        selectedStateLabel?.fontColor = color
    }
    func setDisabledStateLabelFontColor(color:SKColor) {
        disabledStateLabel?.fontColor = color
    }
    func setHighlightedStateSingleLabelFontColor(color:SKColor) {
        highlightedStateSingleLabel?.fontColor = color
    }
    func setHighlightedStateMultiLabelFontColorFromNormal(color:SKColor) {
        highlightedStateMultiLabelFromNormal?.fontColor = color
    }
    func setHighlightedStateMultiLabelFontColorFromSelected(color:SKColor) {
        highlightedStateMultiLabelFromSelected?.fontColor = color
    }
    func setAllStatesLabelFontColor(color:SKColor) {
        setNormalStateLabelFontColor(color)
        setSelectedStateLabelFontColor(color)
        setDisabledStateLabelFontColor(color)
        setHighlightedStateSingleLabelFontColor(color)
        setHighlightedStateMultiLabelFontColorFromNormal(color)
        setHighlightedStateMultiLabelFontColorFromSelected(color)
    }
    
    // Default Control Label Position
    
    internal static var defaultNormalStateLabelPosition = CGPointZero
    internal static var defaultSelectedStateLabelPosition = CGPointZero
    internal static var defaultDisabledStateLabelPosition = CGPointZero
    internal static var defaultHighlightedStateSingleLabelPosition = CGPointZero
    internal static var defaultHighlightedStateMultiLabelPositionFromNormal = CGPointZero
    internal static var defaultHighlightedStateMultiLabelPositionFromSelected = CGPointZero
    internal static func setAllDefaultStatesLabelPosition(pos:CGPoint) {
        defaultNormalStateLabelPosition = pos
        defaultSelectedStateLabelPosition = pos
        defaultDisabledStateLabelPosition = pos
        defaultHighlightedStateSingleLabelPosition = pos
        defaultHighlightedStateMultiLabelPositionFromNormal = pos
        defaultHighlightedStateMultiLabelPositionFromSelected = pos
    }

    
    // Control Instance Label Position
    
    internal var normalStateLabelPosition:CGPoint = defaultNormalStateLabelPosition {
        didSet { normalStateLabel?.position = normalStateLabelPosition }
    }
    internal var selectedStateLabelPosition:CGPoint = defaultSelectedStateLabelPosition {
        didSet { selectedStateLabel?.position = selectedStateLabelPosition }
    }
    internal var disabledStateLabelPosition:CGPoint = defaultDisabledStateLabelPosition {
        didSet { disabledStateLabel?.position = disabledStateLabelPosition }
    }
    internal var highlightedStateSingleLabelPosition:CGPoint = defaultHighlightedStateSingleLabelPosition {
        didSet { highlightedStateSingleLabel?.position = highlightedStateSingleLabelPosition }
    }
    internal var highlightedStateMultiLabelPositionFromNormal:CGPoint = defaultHighlightedStateMultiLabelPositionFromNormal {
        didSet { highlightedStateMultiLabelFromNormal?.position = highlightedStateMultiLabelPositionFromNormal }
    }
    internal var highlightedStateMultiLabelPositionFromSelected:CGPoint = defaultHighlightedStateMultiLabelPositionFromSelected {
        didSet { highlightedStateMultiLabelFromSelected?.position = highlightedStateMultiLabelPositionFromSelected }
    }
    internal func setAllStatesLabelPosition(pos:CGPoint) {
        normalStateLabelPosition = pos
        selectedStateLabelPosition = pos
        disabledStateLabelPosition = pos
        highlightedStateSingleLabelPosition = pos
        highlightedStateMultiLabelPositionFromNormal = pos
        highlightedStateMultiLabelPositionFromSelected = pos
    }

    
    
    
    
    
    

    
    
    
    
    
    // MARK: Private Properties
    
    private let type:TWControlType
    private var state:TWControlState = .Normal { didSet { lastState = oldValue } }
    private var lastState:TWControlState = .Normal
    internal var eventClosures:[(event: ControlEvent, closure: TWControl -> ())] = []
    private var touch:UITouch?
    private var touchLocationLast:CGPoint?
    private var moved = false

    
    // MARK: Control Functionality
    
    private func updateVisualInterface() {
        switch type {
            case .Color:
                updateColorVisualInterface()
            case .Texture:
                updateTextureVisualInterface()
            case .Shape:
                updateShapeVisualInterface()
            case .Label:
                break //Doesnt need to do nothing
        }
        
        updateLabelsVisualInterface()
    }
    
    
    private func updateColorVisualInterface() {
        switch state {
        case .Normal:
            self.generalSprite.color = self.normalStateColor
        case .Selected:
            if let selColor = self.selectedStateColor {
                self.generalSprite.color = selColor
            } else {
                self.generalSprite.color = normalStateColor
            }
        case .Disabled:
            if let disColor = self.disabledStateColor {
                self.generalSprite.color = disColor
            } else {
                self.generalSprite.color = normalStateColor
            }
        case .Highlighted:
            
            if let single = highlightedStateSingleColor {
                self.generalSprite.color = single
            } else {
                if lastState == .Normal {
                    if let fromNormal = self.highlightedStateMultiColorFromNormal {
                        self.generalSprite.color = fromNormal
                    }
                    else if let sel = self.selectedStateColor {
                        self.generalSprite.color = sel
                    }
                    else {
                        self.generalSprite.color = self.normalStateColor
                    }
                }
                else if lastState == .Selected {
                    if let fromSelected = self.highlightedStateMultiColorFromSelected {
                        self.generalSprite.color = fromSelected
                    }
                    else {
                        self.generalSprite.color = self.normalStateColor
                    }
                }
            }
        }
    }

    
    private func updateTextureVisualInterface() {
        switch state {
        case .Normal:
            self.generalSprite.texture = self.normalStateTexture
        case .Selected:
            if let selTex = self.selectedStateTexture {
                self.generalSprite.texture = selTex
            } else {
                self.generalSprite.texture = normalStateTexture
            }
        case .Disabled:
            if let disTex = self.disabledStateTexture {
                self.generalSprite.texture = disTex
            } else {
                self.generalSprite.texture = normalStateTexture
            }
        case .Highlighted:
            
            if let single = highlightedStateSingleTexture {
                self.generalSprite.texture = single
            } else {
                if lastState == .Normal {
                    if let fromNormal = self.highlightedStateMultiTextureFromNormal {
                        self.generalSprite.texture = fromNormal
                    }
                    else if let sel = self.selectedStateTexture {
                        self.generalSprite.texture = sel
                    }
                    else {
                        self.generalSprite.texture = self.normalStateTexture
                    }
                } else if lastState == .Selected {
                    if let fromSelected = self.highlightedStateMultiTextureFromSelected {
                        self.generalSprite.texture = fromSelected
                    }
                    else {
                        self.generalSprite.texture = self.normalStateTexture
                    }
                }
            }
        }
        self.generalSprite.size = self.generalSprite.texture!.size()
    }
    
    
    private func updateShapeVisualInterface() {
        switch state {
        case .Normal:
            self.generalShape.redefine(normalStateShapeDef)
        case .Selected:
            if let selSha = self.selectedStateShapeDef {
                self.generalShape.redefine(selSha)
            } else {
                self.generalShape.redefine(normalStateShapeDef)
            }
        case .Disabled:
            if let disSha = self.disabledStateShapeDef {
                self.generalShape.redefine(disSha)
            } else {
                self.generalShape.redefine(normalStateShapeDef)
            }
        case .Highlighted:
            
            if let single = highlightedStateSingleShapeDef {
                self.generalShape.redefine(single)
            } else {
                if lastState == .Normal {
                    if let fromNormal = self.highlightedStateMultiShapeFromNormalDef {
                        self.generalShape.redefine(fromNormal)
                    }
                    else if let sel = self.selectedStateShapeDef {
                        self.generalShape.redefine(sel)
                    }
                    else {
                        self.generalShape.redefine(self.normalStateShapeDef)
                    }
                } else if lastState == .Selected {
                    if let fromSelected = self.highlightedStateMultiShapeFromSelectedDef {
                        self.generalShape.redefine(fromSelected)
                    }
                    else {
                        self.generalShape.redefine(self.normalStateShapeDef)
                    }
                }
            }
        }
    }
    
    
    private func updateLabelsVisualInterface() {
        // Labels
        normalStateLabel?.alpha = 0
        selectedStateLabel?.alpha = 0
        disabledStateLabel?.alpha = 0
        highlightedStateSingleLabel?.alpha = 0
        highlightedStateMultiLabelFromNormal?.alpha = 0
        highlightedStateMultiLabelFromSelected?.alpha = 0
        
        switch state {
        case .Normal:
            normalStateLabel?.alpha = 1
        case .Selected:
            if let selLabel = self.selectedStateLabel {
                selLabel.alpha = 1
            } else {
                normalStateLabel?.alpha = 1
            }
        case .Disabled:
            if let disLabel = self.disabledStateLabel {
                disLabel.alpha = 1
            } else {
                normalStateLabel?.alpha = 1
            }
        case .Highlighted:
            if let single = highlightedStateSingleLabel {
                single.alpha = 1
            } else {
                if lastState == .Normal {
                    if let fromNormal = self.highlightedStateMultiLabelFromNormal {
                        fromNormal.alpha = 1
                    } else if let selectedLabel = self.selectedStateLabel {
                        selectedLabel.alpha = 1
                    } else {
                        self.normalStateLabel?.alpha = 1
                    }
                } else if lastState == .Selected {
                    if let fromSelected = self.highlightedStateMultiLabelFromSelected {
                        fromSelected.alpha = 1
                    } else {
                        self.normalStateLabel?.alpha = 1
                    }
                }
            }
        }
    }
    
    
    
    // MARK: Control Events
    
    internal func touchDown() {
        playSound(instanceSoundFileName: touchDownSoundFileName, defaultSoundFileName: self.dynamicType.defaultTouchDownSoundFileName)
        executeClosuresOf(.TouchDown)
    }
    
    internal func disabledTouchDown() {
        playSound(instanceSoundFileName: disabledTouchDownFileName, defaultSoundFileName: self.dynamicType.defaultDisabledTouchDownFileName)
    }
    
    internal func drag() {}
    
    internal func dragExit() {
        executeClosuresOf(.TouchDragExit)
    }

    internal func dragOutside() {
        executeClosuresOf(.TouchDragOutside)
    }
    
    internal func dragEnter() {
        executeClosuresOf(.TouchDragEnter)
    }
    
    internal func dragInside() {
        executeClosuresOf(.TouchDragInside)
    }

    internal func touchUpInside() {
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
            } else {
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
            } else {
                self.dragEnter()
            }
        } else {
            // Outside
            if let lastPoint = self.touchLocationLast where self.containsPoint(lastPoint) {
                // Since now
                dragExit()
            } else {
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
            } else {
                // Ended outside
                touchUpOutside()
            }
        } else {
            // Needed??
            touchUpInside()
        }
        self.moved = false
    }
    
    
    internal override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        touchesEnded(touches, withEvent: event)
    }
}