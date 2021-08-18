import SpriteKit

public class TWSwitch: SKNode, TWControl {
    // MARK: Public properties
    public var tag: Int?
    public var eventClosures: [ControlEvent: [(TWSwitch) -> Void]] = [:]
    public var state: ControlState = .init(internalState: .normal, isSelected: false) {
        didSet {
            content.updateVisualInterface(state: state)
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
        content.updateVisualInterface(state: state)
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
        
        func updateVisualInterface(state: ControlState) {
            switch self {
            case let .texture(base, normal, highlighted, selected, disabled):
                switch (state.internalState, state.isSelected) {
                case (.normal, false):
                    base.texture = normal
                
                case (.normal, true):
                    base.texture = selected ?? normal
                    
                case (.highlighted, let isSelected):
                    switch highlighted {
                    case let .a(single):
                        base.texture = single
                    
                    case let .b((fromNormal, fromSelected)):
                        base.texture = isSelected ? fromSelected : fromNormal
                    
                    case .none:
                        base.texture = normal
                    }
                    
                case (.disabled, _):
                    base.texture = disabled ?? normal
                }
                
            case let .shape(_, normal, highlighted, selected, disabled):
                normal.alpha = 0
                highlighted?.all.forEach { $0.alpha = 0 }
                selected?.alpha = 0
                disabled?.alpha = 0
                
                switch (state.internalState, state.isSelected) {
                case (.normal, false):
                    normal.alpha = 1

                case (.normal, true):
                    if let selected = selected {
                        selected.alpha = 1
                    } else {
                        normal.alpha = 1
                    }
                    
                case (.highlighted, let isSelected):
                    switch highlighted {
                    case let .a(single):
                        single.alpha = 1
                    
                    case let .b((fromNormal, fromSelected)):
                        if isSelected {
                            fromSelected.alpha = 1
                        } else {
                            fromNormal.alpha = 1
                        }
                    
                    case .none:
                        normal.alpha = 1
                    }
                    
                case (.disabled, _):
                    if let disabled = disabled {
                        disabled.alpha = 1
                    } else {
                        normal.alpha = 1
                    }
                }
                
            case let .color(base, normal, highlighted, selected, disabled):
                switch (state.internalState, state.isSelected) {
                case (.normal, false):
                    base.color = normal
                
                case (.normal, true):
                    base.color = selected ?? normal
                    
                case (.highlighted, let isSelected):
                    switch highlighted {
                    case let .a(single):
                        base.color = single
                    
                    case let .b((fromNormal, fromSelected)):
                        base.color = isSelected ? fromSelected : fromNormal
                    
                    case .none:
                        base.color = normal
                    }
                    
                case (.disabled, _):
                    base.color = disabled ?? normal
                }
                
            case let .label(_, normal, highlighted, selected, disabled):
                normal.alpha = 0
                highlighted?.all.forEach { $0.alpha = 0 }
                selected?.alpha = 0
                disabled?.alpha = 0
                
                switch (state.internalState, state.isSelected) {
                case (.normal, false):
                    normal.alpha = 1

                case (.normal, true):
                    if let selected = selected {
                        selected.alpha = 1
                    } else {
                        normal.alpha = 1
                    }
                    
                case (.highlighted, let isSelected):
                    switch highlighted {
                    case let .a(single):
                        single.alpha = 1
                    
                    case let .b((fromNormal, fromSelected)):
                        if isSelected {
                            fromSelected.alpha = 1
                        } else {
                            fromNormal.alpha = 1
                        }
                    
                    case .none:
                        normal.alpha = 1
                    }
                    
                case (.disabled, _):
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
        
        switch state.internalState {
        case .normal, .highlighted:
            state.internalState = .highlighted
            executeEvent(event: .touchDown)
            
        case .disabled:
            executeEvent(event: .disabledTouchDown)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let isPointInsideContent = lastTouchLocation.map { content.node.contains($0) } ?? false
        
        switch state.internalState {
        case .normal, .highlighted:
            state.internalState = .normal
            if isPointInsideContent {
                state.isSelected.toggle()
                executeEvent(event: .touchUpInside)
            } else {
                executeEvent(event: .touchUpOutside)
            }
            
        case .disabled:
            executeEvent(event: isPointInsideContent ? .disabledTouchUpInside : .disabledTouchUpOutside)
        }
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch state.internalState {
        case .normal, .highlighted:
            state.internalState = .normal
            executeEvent(event: .touchCanceled)

        case .disabled:
            executeEvent(event: .touchCanceled)
        }
    }
}

extension TWSwitch {
    public convenience init(normal: SKLabelNode, highlighted: SKLabelNode? = nil, selected: SKLabelNode? = nil, disabled: SKLabelNode? = nil) {
        self.init(content: .label(normal: normal, highlighted: highlighted.map { .a($0) }, selected: selected, disabled: disabled))
    }
    public convenience init(normal: SKLabelNode, highlighted: (fromNormal: SKLabelNode, fromSelected: SKLabelNode)? = nil, selected: SKLabelNode? = nil, disabled: SKLabelNode? = nil) {
        self.init(content: .label(normal: normal, highlighted: highlighted.map { .b($0) }, selected: selected, disabled: disabled))
    }

    public convenience init(normal: SKTexture, highlighted: SKTexture? = nil, selected: SKTexture? = nil, disabled: SKTexture? = nil) {
        self.init(content: .texture(normal: normal, highlighted: highlighted.map { .a($0) }, selected: selected, disabled: disabled))
    }
    public convenience init(normal: SKTexture, highlighted: (fromNormal: SKTexture, fromSelected: SKTexture)? = nil, selected: SKTexture? = nil, disabled: SKTexture? = nil) {
        self.init(content: .texture(normal: normal, highlighted: highlighted.map { .b($0) }, selected: selected, disabled: disabled))
    }

    public convenience init(normal: SKShapeNode, highlighted: SKShapeNode? = nil, selected: SKShapeNode? = nil, disabled: SKShapeNode? = nil) {
        self.init(content: .shape(normal: normal, highlighted: highlighted.map { .a($0) }, selected: selected, disabled: disabled))
    }
    public convenience init(normal: SKShapeNode, highlighted: (fromNormal: SKShapeNode, fromSelected: SKShapeNode)? = nil, selected: SKShapeNode? = nil, disabled: SKShapeNode? = nil) {
        self.init(content: .shape(normal: normal, highlighted: highlighted.map { .b($0) }, selected: selected, disabled: disabled))
    }

    public convenience init(size: CGSize, normal: SKColor, highlighted: SKColor? = nil, selected: SKColor? = nil, disabled: SKColor? = nil) {
        self.init(content: .color(size: size, normal: normal, highlighted: highlighted.map { .a($0) }, selected: selected, disabled: disabled))
    }
    public convenience init(size: CGSize, normal: SKColor, highlighted: (fromNormal: SKColor, fromSelected: SKColor)? = nil, selected: SKColor? = nil, disabled: SKColor? = nil) {
        self.init(content: .color(size: size, normal: normal, highlighted: highlighted.map { .b($0) }, selected: selected, disabled: disabled))
    }
}

extension TWSwitch.Content {
    static func texture(normal: SKTexture, highlighted: Either<SKTexture, (SKTexture, SKTexture)>?, selected: SKTexture?, disabled: SKTexture?) -> Self {
        let base = SKSpriteNode()
        base.size = normal.size()
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
    public struct ControlState {
        var internalState: InternalState
        public var isSelected: Bool
        
        enum InternalState {
            case normal
            case highlighted
            case disabled
        }
        
        public var isEnabled: Bool {
            get {
                switch internalState {
                case .disabled: return false
                default: return true
                }
            }
            set {
                guard isEnabled != newValue else { return }
                internalState = newValue ? .normal : .disabled
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
