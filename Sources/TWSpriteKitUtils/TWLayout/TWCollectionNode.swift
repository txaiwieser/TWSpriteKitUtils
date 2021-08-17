import SpriteKit

public class TWCollectionNode: SKSpriteNode {
    public private(set) var fillMode: FillMode
    public private(set) var childNodes: [SKNode] = []
    public var reloadCompletion: (()->())? = nil
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public init(fillMode: FillMode) {
        self.fillMode = fillMode
        super.init(texture: nil, color: .clear, size: .zero)
    }
    
    func reloadCollection() {
        guard childNodes.isEmpty == false else {
            size.height = 0
            return
        }
        
        let linesCount = Int(ceil(CGFloat(childNodes.count)/CGFloat(fillMode.columnsCount)))
        let availableHSize = size.width - fillMode.elementSize.width
        
        let perElementHSpace = availableHSize / CGFloat(fillMode.columnsCount - 1)
        let perElementVSpace = fillMode.elementSize.height
        
        let indexHShift = CGFloat(fillMode.columnsCount) / 2 - 0.5
        let indexVShift = CGFloat(linesCount) / 2 - 0.5
        
        for (index, node) in childNodes.enumerated() {
            let column = index % fillMode.columnsCount
            let line = index / fillMode.columnsCount
            
            node.position.x = (CGFloat(column) - indexHShift) * perElementHSpace
            node.position.y = (-CGFloat(line) + indexVShift) * (perElementVSpace + fillMode.lineSpacing)
        }
        
        size.height = CGFloat(linesCount) * fillMode.elementSize.height + CGFloat(linesCount - 1) * fillMode.lineSpacing
        reloadCompletion?()
    }
    
    public func add(node: SKNode, reload: Bool = false) {
        childNodes.append(node)
        self.addChild(node)
        
        if reload { reloadCollection() }
    }
    
    public func remove(node: SKNode?, reload: Bool = false) {
        if let n = node, let i = childNodes.firstIndex(of: n) {
            n.removeFromParent()
            childNodes.remove(at: i)
        }
        if reload { reloadCollection() }
    }
    
    public struct FillMode {
        let columnsCount: Int
        let lineSpacing: CGFloat
        let elementSize: CGSize
        
        public init(columnsCount: Int, lineSpacing: CGFloat, elementSize: CGSize) {
            self.columnsCount = columnsCount
            self.lineSpacing = lineSpacing
            self.elementSize = elementSize
        }
    }
}


public extension SKNode {
    func removeFromParentCollection(_ reloading: Bool = true) {
        guard let stack = self.parent as? TWCollectionNode else {
            let message = "TWSKUtils ERROR: Node is not in a TWStackNode"
            assertionFailure(message)
            return
        }
        stack.remove(node: self, reload: reloading)
    }
}

