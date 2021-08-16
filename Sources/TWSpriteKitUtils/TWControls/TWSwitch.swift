import SpriteKit

public class TWSwitch: SKNode, TWControl {
    // MARK: Public properties
    public var tag: Int?
    public var eventClosures: [ControlEvent: [(TWSwitch) -> Void]] = [:]
    public var state: ControlState = .normal {
        didSet {
            content.updateVisualInterface(toState: state, fromState: oldValue)
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
        content.updateVisualInterface(toState: state, fromState: .normal)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Content {
        case texture(
            base: SKSpriteNode,
            normal: SKTexture,
            highlighted: Either<SKTexture, (SKTexture, SKTexture)>?,
            selected: SKTexture?,
            disabled: SKTexture?
        )
        case shape(
            base: SKNode,
            normal: SKShapeNode,
            highlighted: Either<SKShapeNode, (SKShapeNode, SKShapeNode)>?,
            selected: SKShapeNode?,
            disabled: SKShapeNode?
        )
        case color(
            base: SKSpriteNode,
            normal: SKColor,
            highlighted: Either<SKColor, (SKColor, SKColor)>?,
            selected: SKColor?,
            disabled: SKColor?
        )
        case label(
            base: SKNode,
            normal: SKLabelNode,
            highlighted: Either<SKLabelNode, (SKLabelNode, SKLabelNode)>?,
            selected: SKLabelNode?,
            disabled: SKLabelNode?
        )
        
        var node: SKNode {
            switch self {
            case let .texture(node, _, _, _, _): return node
            case let .shape(node, _, _, _, _): return node
            case let .color(node, _, _, _, _): return node
            case let .label(node, _, _, _, _): return node
            }
        }
        
        func updateVisualInterface(toState: ControlState, fromState: ControlState) {
            switch self {
            case let .texture(base, normal, highlighted, selected, disabled):
                switch toState {
                case .normal:
                    base.texture = normal
                    
                case .highlighted:
                    switch highlighted {
                    case let .a(single):
                        base.texture = single
                    
                    case let .b((fromNormal, fromSelected)):
                        switch fromState {
                        case .selected:
                            base.texture = fromSelected
                        default:
                            base.texture = fromNormal
                        }
                    
                    case .none:
                        base.texture = normal
                    }
                
                case .selected:
                    base.texture = selected ?? normal
                    
                case .disabled:
                    base.texture = disabled ?? normal
                }
                
            case let .shape(_, normal, highlighted, selected, disabled):
                normal.alpha = 0
                highlighted?.all.forEach { $0.alpha = 0 }
                selected?.alpha = 0
                disabled?.alpha = 0
                
                switch toState {
                case .normal:
                    normal.alpha = 1
                    
                case .highlighted:
                    switch highlighted {
                    case let .a(single):
                        single.alpha = 1
                    
                    case let .b((fromNormal, fromSelected)):
                        switch fromState {
                        case .selected:
                            fromSelected.alpha = 1
                        default:
                            fromNormal.alpha = 1
                        }
                        
                    case .none:
                        normal.alpha = 1
                    }
                
                case .selected:
                    selected?.alpha = 1
                    
                case .disabled:
                    if let disabled = disabled {
                        disabled.alpha = 1
                    } else {
                        normal.alpha = 1
                    }
                }
                
            case let .color(base, normal, highlighted, selected, disabled):
                switch toState {
                case .normal:
                    base.color = normal
                    
                case .highlighted:
                    switch highlighted! {
                    case let .a(single):
                        base.color = single
                    
                    case let .b((fromNormal, fromSelected)):
                        switch fromState {
                        case .selected:
                            base.color = fromSelected
                        default:
                            base.color = fromNormal
                        }
                    }
                
                case .selected:
                    base.color = selected ?? normal
                    
                case .disabled:
                    base.color = disabled ?? normal
                }
                
            case let .label(_, normal, highlighted, selected, disabled):
                normal.alpha = 0
                highlighted?.all.forEach { $0.alpha = 0 }
                selected?.alpha = 0
                disabled?.alpha = 0
                
                switch toState {
                case .normal:
                    normal.alpha = 1
                    
                case .highlighted:
                    switch highlighted {
                    case let .a(single):
                        single.alpha = 1
                    
                    case let .b((fromNormal, fromSelected)):
                        switch fromState {
                        case .selected:
                            fromSelected.alpha = 1
                        default:
                            fromNormal.alpha = 1
                        }
                        
                    case .none:
                        normal.alpha = 1
                    }
                
                case .selected:
                    if let selected = selected {
                        selected.alpha = 1
                    } else {
                        normal.alpha = 1
                    }
                    
                case .disabled:
                    if let disabled = disabled {
                        disabled.alpha = 1
                    } else {
                        normal.alpha = 1
                    }
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
        case .normal:
            state = .highlighted(fromSelected: false)
            executeEvent(event: .touchDown)
            
        case .highlighted:
            executeEvent(event: .touchDown)
            
        case .selected:
            state = .highlighted(fromSelected: true)
            executeEvent(event: .touchDown)
            
        case .disabled:
            executeEvent(event: .disabledTouchDown)
        }
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let lastPoint = lastTouchLocation, content.node.contains(lastPoint) {
            switch state {
            case .normal, .highlighted(false):
                state = .selected
                executeEvent(event: .touchUpInside)
                executeEvent(event: .selectionChanged)
            
            case .highlighted(true):
                state = .normal
                executeEvent(event: .touchUpInside)
                executeEvent(event: .selectionChanged)
                
            case .selected:
                executeEvent(event: .touchUpInside)
                
            case .disabled:
                executeEvent(event: .disabledTouchUpInside)
            }
        } else {
            switch state {
            case .normal:
                executeEvent(event: .touchUpOutside)
            
            case let .highlighted(fromSelected):
                state = fromSelected ? .selected : .normal
                executeEvent(event: .touchUpOutside)
                
            case .selected:
                executeEvent(event: .touchUpOutside)
                
            case .disabled:
                executeEvent(event: .disabledTouchUpOutside)
            }
        }
    }

    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch state {
        case .normal:
            executeEvent(event: .touchCanceled)
        
        case let .highlighted(fromSelected):
            state = fromSelected ? .selected : .normal
            executeEvent(event: .touchCanceled)
            
        case .selected:
            executeEvent(event: .touchCanceled)
            
        case .disabled:
            executeEvent(event: .touchCanceled)
        }
    }
}

extension TWSwitch {
    public convenience init(normal: SKLabelNode, highlighted: SKLabelNode?, selected: SKLabelNode?, disabled: SKLabelNode?) {
        self.init(content: .label(normal: normal, highlighted: highlighted.map { .a($0) }, selected: selected, disabled: disabled))
    }
    public convenience init(normal: SKLabelNode, highlighted: (fromNormal: SKLabelNode, fromSelected: SKLabelNode)?, selected: SKLabelNode?, disabled: SKLabelNode?) {
        self.init(content: .label(normal: normal, highlighted: highlighted.map { .b($0) }, selected: selected, disabled: disabled))
    }

    public convenience init(size: CGSize, normal: SKTexture, highlighted: SKTexture?, selected: SKTexture?, disabled: SKTexture?) {
        self.init(content: .texture(size: size, normal: normal, highlighted: highlighted.map { .a($0) }, selected: selected, disabled: disabled))
    }
    public convenience init(size: CGSize, normal: SKTexture, highlighted: (fromNormal: SKTexture, fromSelected: SKTexture)?, selected: SKTexture?, disabled: SKTexture?) {
        self.init(content: .texture(size: size, normal: normal, highlighted: highlighted.map { .b($0) }, selected: selected, disabled: disabled))
    }

    public convenience init(normal: SKShapeNode, highlighted: SKShapeNode?, selected: SKShapeNode?, disabled: SKShapeNode?) {
        self.init(content: .shape(normal: normal, highlighted: highlighted.map { .a($0) }, selected: selected, disabled: disabled))
    }
    public convenience init(normal: SKShapeNode, highlighted: (fromNormal: SKShapeNode, fromSelected: SKShapeNode)?, selected: SKShapeNode?, disabled: SKShapeNode?) {
        self.init(content: .shape(normal: normal, highlighted: highlighted.map { .b($0) }, selected: selected, disabled: disabled))
    }

    public convenience init(size: CGSize, normal: SKColor, highlighted: SKColor?, selected: SKColor?, disabled: SKColor?) {
        self.init(content: .color(size: size, normal: normal, highlighted: highlighted.map { .a($0) }, selected: selected, disabled: disabled))
    }
    public convenience init(size: CGSize, normal: SKColor, highlighted: (fromNormal: SKColor, fromSelected: SKColor)?, selected: SKColor?, disabled: SKColor?) {
        self.init(content: .color(size: size, normal: normal, highlighted: highlighted.map { .b($0) }, selected: selected, disabled: disabled))
    }
}

extension TWSwitch.Content {
    static func texture(size: CGSize, normal: SKTexture, highlighted: Either<SKTexture, (SKTexture, SKTexture)>?, selected: SKTexture?, disabled: SKTexture?) -> Self {
        let base = SKSpriteNode()
        base.size = size
        return .texture(base: base, normal: normal, highlighted: highlighted, selected: selected, disabled: disabled)
    }
    
    static func shape(normal: SKShapeNode, highlighted: Either<SKShapeNode, (SKShapeNode, SKShapeNode)>?, selected: SKShapeNode?, disabled: SKShapeNode?) -> Self {
        let base = SKNode()
        base.addChild(normal)
        highlighted.map { either in either.all.forEach { base.addChild($0) } }
        selected.map { base.addChild($0) }
        disabled.map { base.addChild($0) }
        return .shape(base: base, normal: normal, highlighted: highlighted, selected: selected, disabled: disabled)
    }
    
    static func color(size: CGSize, normal: SKColor, highlighted: Either<SKColor, (SKColor, SKColor)>?, selected: SKColor?, disabled: SKColor?) -> Self {
        let base = SKSpriteNode()
        base.size = size
        return .color(base: base, normal: normal, highlighted: highlighted, selected: selected, disabled: disabled)
    }
    
    static func label(normal: SKLabelNode, highlighted: Either<SKLabelNode, (SKLabelNode, SKLabelNode)>?, selected: SKLabelNode?, disabled: SKLabelNode?) -> Self {
        let base = SKNode()
        base.addChild(normal)
        highlighted.map { either in either.all.forEach { base.addChild($0) } }
        selected.map { base.addChild($0) }
        disabled.map { base.addChild($0) }
        return .label(base: base, normal: normal, highlighted: highlighted, selected: selected, disabled: disabled)
    }
}

extension TWSwitch {
    public enum ControlState {
        case normal
        case highlighted(fromSelected: Bool)
        case selected
        case disabled(isSelected: Bool)
        
        public var isSelected: Bool {
            get {
                switch self {
                case .selected: return false
                default: return true
                }
            }
            set {
                guard isSelected != newValue else { return }
                self = newValue ? .normal : .selected
            }
        }
        
        public var isEnabled: Bool {
            get {
                switch self {
                case .disabled: return false
                default: return true
                }
            }
            set {
                guard isEnabled != newValue else { return }
                if newValue {
                    if case let .disabled(isSelected) = self {
                        self = isSelected ? .selected : .normal
                    } else {
                        self = .normal
                    }
                } else {
                    if case .selected = self {
                        self = .disabled(isSelected: true)
                    } else {
                        self = .disabled(isSelected: false)
                    }
                }
            }
        }
    }
    
    public enum ControlEvent {
        case selectionChanged
        case touchDown
        case touchUpInside
        case touchUpOutside
        case disabledTouchDown
        case disabledTouchUpInside
        case disabledTouchUpOutside
        case touchCanceled
    }
}

enum Either<A, B> {
    case a(A)
    case b(B)
}

extension Either where B == (A, A) {
    var all: [A] {
        switch self {
        case let .a(v):
            return [v]
            
        case let .b(v):
            return [v.0, v.1]
        }
    }
}
