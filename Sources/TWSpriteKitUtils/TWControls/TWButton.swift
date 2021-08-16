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
        guard state != .disabled else {
            executeEvent(event: .disabledTouchDown)
            return
        }
        state = .highlighted
        executeEvent(event: .touchDown)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let lastPoint = lastTouchLocation, content.node.contains(lastPoint) {
            guard state != .disabled else {
                executeEvent(event: .disabledTouchUpInside)
                return
            }
            state = .normal
            executeEvent(event: .touchUpInside)
        } else {
            guard state != .disabled else {
                executeEvent(event: .disabledTouchUpOutside)
                return
            }
            state = .normal
            executeEvent(event: .touchUpOutside)
        }
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state != .disabled { state = .normal }
        executeEvent(event: .touchCanceled)
    }
}

extension TWButton {
    public convenience init(normal: SKLabelNode, highlighted: SKLabelNode?, disabled: SKLabelNode?) {
        self.init(content: .label(normal: normal, highlighted: highlighted, disabled: disabled))
    }

    public convenience init(size: CGSize, normal: SKTexture, highlighted: SKTexture?, disabled: SKTexture?) {
        self.init(content: .texture(size: size, normal: normal, highlighted: highlighted, disabled: disabled))
    }

    public convenience init(normal: SKShapeNode, highlighted: SKShapeNode?, disabled: SKShapeNode?) {
        self.init(content: .shape(normal: normal, highlighted: highlighted, disabled: disabled))
    }

    public convenience init(size: CGSize, normal: SKColor, highlighted: SKColor?, disabled: SKColor?) {
        self.init(content: .color(size: size, normal: normal, highlighted: highlighted, disabled: disabled))
    }
}

extension TWButton.Content {
    static func texture(size: CGSize, normal: SKTexture, highlighted: SKTexture?, disabled: SKTexture?) -> Self {
        let base = SKSpriteNode()
        base.size = size
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
