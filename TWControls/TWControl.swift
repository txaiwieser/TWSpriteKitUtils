//
//  TWControl.swift
//  
//
//  Created by Txai Wieser on 24/02/15.
//
//

import SpriteKit



enum TWControlState: Int {
    case Normal = 0
    case Highlighted = 1
    case Selected = 2
    case Disabled = 3
}

protocol TWControlDelegate: class {
    func controlValueChanged(control:TWControl)
}

enum TWControlType {
    case Texture
    case Color
    case Label
}

class TWControl: SKSpriteNode {

    // Mark: Public properties
    internal weak var delegate:TWControlDelegate!
    internal var tag:Int?
    internal var isOn:Bool = false
    internal var enabled:Bool {
        get {
            return self.state != .Disabled
        }
        set {
            if newValue {
                self.state = .Normal
                self.userInteractionEnabled = true
            }
            else {
                self.state = .Disabled
                self.userInteractionEnabled = false
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
    
    internal var boundsTolerance:CGFloat?
    
    
    
    
    
    // Mark: Customization properties

    // TYPE Color customizations
    internal var stateDisabledColor:SKColor! { didSet { updateVisualInterface() } }
    internal var stateHighlightedColor:SKColor! { didSet { updateVisualInterface() } }
    internal var stateNormalColor:SKColor! { didSet { updateVisualInterface() } }
    internal var stateSelectedColor:SKColor! { didSet { updateVisualInterface() } }
    
    // TYPE Texture customizations
    internal var stateDisabledTexture:SKTexture! { didSet { updateVisualInterface() } }
    internal var stateHighlightedTexture:SKTexture! { didSet { updateVisualInterface() } }
    internal var stateNormalTexture:SKTexture! { didSet { updateVisualInterface() } }
    internal var stateSelectedTexture:SKTexture! { didSet { updateVisualInterface() } }
    
    
    // Labels customizations
    internal let stateDisabledLabel = SKLabelNode()
    internal let stateHighlightedLabel = SKLabelNode()
    internal let stateNormalLabel = SKLabelNode()
    internal let stateSelectedLabel = SKLabelNode()
    
    
    internal var stateDisabledLabelText:String? {
        didSet {
            if stateDisabledLabelText != nil { stateDisabledLabel.text = stateDisabledLabelText! }
            updateVisualInterface()
        }
    }
    
    internal var stateHighlightedLabelText:String? {
        didSet {
            if stateHighlightedLabelText != nil { stateHighlightedLabel.text = stateHighlightedLabelText! }
            updateVisualInterface()
        }
    }
    
    internal var stateNormalLabelText:String? {
        didSet {
            if stateNormalLabelText != nil { stateNormalLabel.text = stateNormalLabelText! }
            updateVisualInterface()
        }
    }
    
    internal var stateSelectedLabelText:String? {
        didSet {
            if stateSelectedLabelText != nil { stateSelectedLabel.text = stateSelectedLabelText! }
            updateVisualInterface()
        }
    }
    
    static let co = UIColor.whiteColor()
    
    internal var stateDisabledFontColor:SKColor = co { didSet { updateVisualInterface() } }
    internal var stateHighlightedFontColor:SKColor = co { didSet { updateVisualInterface() } }
    internal var stateNormalFontColor:SKColor = co { didSet { updateVisualInterface() } }
    internal var stateSelectedFontColor:SKColor = co { didSet { updateVisualInterface() } }
    
    
    // Mark: Private properties

    private let type:TWControlType
    private var state:TWControlState = .Normal
    private var eventClosures:[(event: UIControlEvents, closure: TWControl -> ())] = []
    private var touch:UITouch?
    private var touchLocationLast:CGPoint?
    private var moved = false

    
    
    
    
    // Mark: Initializers
    
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

    
    
    
    func addClosureFor<T: AnyObject>(event: UIControlEvents, target: T, closure: (T, TWControl) -> ())
    {
        self.eventClosures.append((event:event , closure: { [weak target] (ctrl: TWControl) -> () in
            if let obj = target {
                closure(obj, ctrl)
            }
            return
            }))
    }
    
    func removeClosuresFor(event:UIControlEvents) {
        assertionFailure("TODO: Implement Remove Target")
    }

    func executeClosuresOf(event: UIControlEvents) {
        for eventClosure in eventClosures {
            if eventClosure.event == event {
                eventClosure.closure(self)
            }
        }
    }
    
    func updateVisualInterface() {
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
                case .Highlighted:
                    self.texture = self.stateHighlightedTexture
                case .Normal:
                    self.texture = self.stateNormalTexture
                case .Selected:
                    self.texture = self.stateSelectedTexture
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
    
    // soiudfnaisjdnvpasjdvnps kjsdnlkjsdnflksjdnflksjdnflskdjfnlskdjfn
    
    func touchDown() {
        self.highlighted = true
        executeClosuresOf(.TouchDown)
    }
    
    func drag() {}
    
    func dragExit() {
        self.highlighted = false
        executeClosuresOf(.TouchDragExit)
    }

    func dragOutside() {
        executeClosuresOf(.TouchDragOutside)
    }
    
    func dragEnter() {
        self.highlighted = true
        executeClosuresOf(.TouchDragEnter)
    }
    
    func dragInside() {
        executeClosuresOf(.TouchDragInside)
    }

    func touchUpInside() {
        self.highlighted = false
        executeClosuresOf(.TouchUpInside)
    }
    
    func touchUpOutside() {
        executeClosuresOf(.TouchUpOutside)
    }
    
    
    
    
    
    
    
    
    // UIResponder Methods
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let touchPoint = touch.locationInNode(self.parent)
        
        if self.containsPoint(touchPoint) {
            self.touch = touch
            self.touchLocationLast = touchPoint
            touchDown()
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
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
    
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
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
    
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        touchesEnded(touches, withEvent: event)
    }
    
    // .............................................................................
    
    
    
    
    
    // Helpers
    
    override func containsPoint(p: CGPoint) -> Bool {
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
    
    // .............................................................................
}




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