import SpriteKit

public enum TWControlEvent {
    case touchDown
    case touchUpInside
    case touchUpOutside
    case touchCancel
    case touchDragExit
    case touchDragOutside
    case touchDragEnter
    case touchDragInside
    case valueChanged
    case disabledTouchDown
}

internal enum TWControlType {
    case texture
    case shape
    case color
    case label
}

internal enum TWControlState {
    case normal
    case highlighted
    case selected
    case disabled
}

internal class TWShapeNode: SKShapeNode {
    weak var control: TWControl?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        control?.touchesBegan(touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        control?.touchesMoved(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        control?.touchesEnded(touches, with: event)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        control?.touchesCancelled(touches, with: event)
    }
}

internal class TWSpriteNode: SKSpriteNode {
    weak var control: TWControl?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        control?.touchesBegan(touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        control?.touchesMoved(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        control?.touchesEnded(touches, with: event)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        control?.touchesCancelled(touches, with: event)
    }
}

public extension SKShapeNode {
    convenience init(definition: Definition) {
        self.init()
        self.redefine(definition)
    }
    
    func redefine(_ definition: Definition) {
        self.path = definition.path
        self.strokeColor = definition.strokeColor
        self.fillColor = definition.fillColor
        self.lineWidth = definition.lineWidth
        self.glowWidth = definition.glowWidth
        self.fillTexture = definition.fillTexture
    }
    
    func definition() -> Definition {
        var shapeDef = Definition(path: self.path!)
        shapeDef.path = self.path!
        shapeDef.strokeColor = self.strokeColor
        shapeDef.fillColor = self.fillColor
        shapeDef.lineWidth = self.lineWidth
        shapeDef.glowWidth = self.glowWidth
        shapeDef.fillTexture = self.fillTexture
        return shapeDef
    }
    
    // MARK: Shape Definition - Description
    struct Definition {
        var path: CGPath
        var strokeColor: UIColor = .white
        var fillColor: UIColor = .clear
        var lineWidth: CGFloat = 1.0
        var glowWidth: CGFloat = 0.0
        var fillTexture: SKTexture? = nil
        
        public init(path: CGPath) {
            self.path = path
        }
        
        public init(path: CGPath, color: SKColor) {
            self.path = path
            self.fillColor = color
            self.strokeColor = color
        }
        
        public init(_ node: SKShapeNode) {
            self = node.definition()
        }
        
        public init?(_ node: SKShapeNode?) {
            guard let shape = node else { return nil }
            self.init(shape)
        }
    }
}
