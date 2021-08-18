import SpriteKit

public final class TWStackNode: SKSpriteNode {
    public private(set) var fillMode: FillMode
    public private(set) var sizingMode: SizingMode
    public private(set) var childNodes: [SKNode] = []

    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public init(fillMode: FillMode, sizingMode: SizingMode, childNodes: [SKNode] = []) {
        self.fillMode = fillMode
        self.sizingMode = sizingMode
        super.init(texture: nil, color: .clear, size: .zero)
        childNodes.forEach { add(node: $0, reload: false) }
        reloadStack()
    }
    
    public func reloadStack() {
        guard childNodes.isEmpty == false else {
            if sizingMode.isFixed == false {
                size = .zero
            }
            return
        }
        guard childNodes.count > 1 else {
            childNodes[0].position = .zero
            if sizingMode.isFixed == false {
                size = childNodes[0].calculateAccumulatedFrame().size
            }
            return
        }
        
        switch fillMode {
        case .vertical:
            switch sizingMode {
            case .fixed:
                let firstElementLength = childNodes.first!.calculateAccumulatedFrame().height
                let lastElementLength = childNodes.last!.calculateAccumulatedFrame().height
                let availableSize = size.height - firstElementLength / 2 - lastElementLength / 2
                let perElementSpace = availableSize / CGFloat(childNodes.count)
                
                let indexShift = CGFloat(childNodes.count) / 2 - 0.5
                for (index, node) in childNodes.enumerated() {
                    node.position.y = -(CGFloat(index) - indexShift) * perElementSpace
                }
                
            case .dynamic(let spacing):
                var accumulatedLength: CGFloat = 0
                for (i, node) in childNodes.enumerated() {
                    let length = node.calculateAccumulatedFrame().height
                    node.position.y = -(accumulatedLength + length / 2)
                    accumulatedLength += length
                    if i != childNodes.count - 1 {
                        accumulatedLength += spacing ?? 0
                    }
                }
                
                childNodes.forEach { $0.position.y += accumulatedLength / 2 }
                size.height = accumulatedLength
            }
            
        case .horizontal:
            switch sizingMode {
            case .fixed:
                let firstElementLength = childNodes.first!.calculateAccumulatedFrame().width
                let lastElementLength = childNodes.last!.calculateAccumulatedFrame().width
                let availableSize = size.width - firstElementLength / 2 - lastElementLength / 2
                let perElementSpace = availableSize / CGFloat(childNodes.count)
                
                let indexShift = CGFloat(childNodes.count) / 2 - 0.5
                for (index, node) in childNodes.enumerated() {
                    node.position.x = (CGFloat(index) - indexShift) * perElementSpace
                }
                
            case .dynamic(let spacing):
                var accumulatedLength: CGFloat = 0
                for (i, node) in childNodes.enumerated() {
                    let length = node.calculateAccumulatedFrame().width
                    node.position.x = accumulatedLength + length / 2
                    accumulatedLength += length
                    if i != childNodes.count - 1 {
                        accumulatedLength += spacing ?? 0
                    }
                }
                
                childNodes.forEach { $0.position.x -= accumulatedLength / 2 }
                size.width = accumulatedLength
            }
        }
        
    }
    
    public func add(node: SKNode, reload: Bool = false) {
        childNodes.append(node)
        addChild(node)
        
        if reload { reloadStack() }
    }
    
    public func remove(node: SKNode?, reload: Bool = false) {
        if let n = node, let i = childNodes.firstIndex(of: n) {
            n.removeFromParent()
            childNodes.remove(at: i)
        }
        if reload { reloadStack() }
    }
    
    public enum FillMode {
        case horizontal
        case vertical
    }
    
    public enum SizingMode {
        case fixed
        case dynamic(spacing: CGFloat? = 8)
        
        var isFixed: Bool {
            switch self {
            case .fixed: return true
            case .dynamic: return false
            }
        }
    }
}

public extension SKNode {
    func removeFromParentStack(_ reloading: Bool = true) {
        guard let stack = self.parent as? TWStackNode else {
            let message = "TWSKUtils ERROR: Node is not in a TWStackNode"
            assertionFailure(message)
            return
        }
        stack.remove(node: self, reload: reloading)
    }
}
