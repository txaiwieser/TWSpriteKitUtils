import SpriteKit

public class TWButton: SKNode, TWControl {
    // MARK: Public properties
    public var tag: Int?
    public var eventClosures: [ControlEvent: [(TWButton) -> Void]] = [:]
    public var state: ControlState = .normal {
        didSet {
            content.updateVisualInterface(for: state)
        }
    }
    
    // MARK: Private properties
    private var lastTouchLocation: CGPoint?
    
    private var content: Content
    
    init(content: Content) {
        self.content = content
        super.init()
        addChild(content.node)
        isUserInteractionEnabled = true
        content.node.isUserInteractionEnabled = false
        content.updateVisualInterface(for: state)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Content {
        case texture(base: SKSpriteNode, normal: SKTexture, highlighted: SKTexture?, disabled: SKTexture?)
        case shape(base: SKNode, normal: SKShapeNode, highlighted: SKShapeNode?, disabled: SKShapeNode?)
        case color(base: SKSpriteNode, normal: SKColor, highlighted: SKColor?, disabled: SKColor?)
        case label(base: SKNode, normal: SKLabelNode, highlighted: SKLabelNode?, disabled: SKLabelNode?)
        
        var node: SKNode {
            switch self {
            case let .texture(node, _, _, _): return node
            case let .shape(node, _, _, _): return node
            case let .color(node, _, _, _): return node
            case let .label(node, _, _, _): return node
            }
        }
        
        func updateVisualInterface(for state: ControlState) {
            switch self {
            case let .texture(base, normal, highlighted, disabled):
                switch state {
                case .normal:
                    base.texture = normal
                    
                case .highlighted:
                    base.texture = highlighted ?? normal
                    
                case .disabled:
                    base.texture = disabled ?? normal
                }
                
            case let .shape(_, normal, highlighted, disabled):
                normal.alpha = 0
                highlighted?.alpha = 0
                disabled?.alpha = 0
                
                switch state {
                case .highlighted where highlighted != nil:
                    highlighted?.alpha = 1
                    
                case .disabled where disabled != nil:
                    disabled?.alpha = 1
                
                default:
                    normal.alpha = 1
                }
                
            case let .color(base, normal, highlighted, disabled):
                switch state {
                case .normal:
                    base.color = normal
                    
                case .highlighted:
                    base.color = highlighted ?? normal
                    
                case .disabled:
                    base.color = disabled ?? normal
                }
                
            case let .label(_, normal, highlighted, disabled):
                normal.alpha = 0
                highlighted?.alpha = 0
                disabled?.alpha = 0
                
                switch state {
                case .highlighted where highlighted != nil:
                    highlighted?.alpha = 1
                    
                case .disabled where disabled != nil:
                    disabled?.alpha = 1
                
                default:
                    normal.alpha = 1
                }
            }
        }
    }
    
    // MARK: Sound Properties
    
    public static var defaultSoundEffectsEnabled: Bool = true
    public static var defaultSoundEffects: [ControlEvent: String] = [:] {
        didSet {
            for value in defaultSoundEffects.values {
                SKAction.soundPreLoad(value)
            }
        }
    }
    
    public var soundEffectsEnabled: Bool = true
    public var soundEffects: [ControlEvent: String] = [:] {
        didSet {
            for value in soundEffects.values {
                SKAction.soundPreLoad(value)
            }
        }
    }

    // MARK: Control Events
    
    private func executeEvent(event: ControlEvent) {
        executeClosures(of: event)
        playSound(for: event)
    }
    
    // MARK: UIResponder Methods
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        guard let parent = self.content.node.parent else { return }
        let touchPoint = touch.location(in: parent)

        guard content.node.contains(touchPoint) else { return }
        lastTouchLocation = touchPoint
        
        switch state {
        case .normal, .highlighted:
            state = .highlighted
            executeEvent(event: .touchDown)
        case .disabled:
            executeEvent(event: .disabledTouchDown)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let isPointInsideContent = lastTouchLocation.map { content.node.contains($0) } ?? false
        
        switch state {
        case .normal, .highlighted:
            state = .normal
            executeEvent(event: isPointInsideContent ? .touchUpInside : .touchUpOutside)

        case .disabled:
            executeEvent(event: isPointInsideContent ? .disabledTouchUpInside : .disabledTouchUpOutside)
        }
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch state {
        case .normal, .highlighted:
            state = .normal
            executeEvent(event: .touchCanceled)

        case .disabled:
            executeEvent(event: .touchCanceled)
        }
    }
}

extension TWButton {
    public convenience init(normal: SKLabelNode, highlighted: SKLabelNode? = nil, disabled: SKLabelNode? = nil) {
        self.init(content: .label(normal: normal, highlighted: highlighted, disabled: disabled))
    }

    public convenience init(normal: SKTexture, highlighted: SKTexture? = nil, disabled: SKTexture? = nil) {
        self.init(content: .texture(normal: normal, highlighted: highlighted, disabled: disabled))
    }

    public convenience init(normal: SKShapeNode, highlighted: SKShapeNode? = nil, disabled: SKShapeNode? = nil) {
        self.init(content: .shape(normal: normal, highlighted: highlighted, disabled: disabled))
    }

    public convenience init(size: CGSize, normal: SKColor, highlighted: SKColor? = nil, disabled: SKColor? = nil) {
        self.init(content: .color(size: size, normal: normal, highlighted: highlighted, disabled: disabled))
    }
}

extension TWButton.Content {
    static func texture(normal: SKTexture, highlighted: SKTexture?, disabled: SKTexture?) -> Self {
        let base = SKSpriteNode()
        base.size = normal.size()
        return .texture(base: base, normal: normal, highlighted: highlighted, disabled: disabled)
    }
    static func shape(normal: SKShapeNode, highlighted: SKShapeNode?, disabled: SKShapeNode?) -> Self {
        let base = SKNode()
        base.addChild(normal)
        highlighted.map { base.addChild($0) }
        disabled.map { base.addChild($0) }
        return .shape(base: base, normal: normal, highlighted: highlighted, disabled: disabled)
    }
    static func color(size: CGSize, normal: SKColor, highlighted: SKColor?, disabled: SKColor?) -> Self {
        let base = SKSpriteNode()
        base.size = size
        return .color(base: base, normal: normal, highlighted: highlighted, disabled: disabled)
    }
    static func label(normal: SKLabelNode, highlighted: SKLabelNode?, disabled: SKLabelNode?) -> Self {
        let base = SKNode()
        base.addChild(normal)
        highlighted.map { base.addChild($0) }
        disabled.map { base.addChild($0) }
        return .label(base: base, normal: normal, highlighted: highlighted, disabled: disabled)
    }
}

extension TWButton {
    public enum ControlState {
        case normal
        case highlighted
        case disabled
        
        public var isEnabled: Bool {
            get {
                self != .disabled
            }
            set {
                self = newValue ? .normal : .disabled
            }
        }
    }
    
    public enum ControlEvent {
        case touchDown
        case touchUpInside
        case touchUpOutside
        case disabledTouchDown
        case disabledTouchUpInside
        case disabledTouchUpOutside
        case touchCanceled
    }
}
