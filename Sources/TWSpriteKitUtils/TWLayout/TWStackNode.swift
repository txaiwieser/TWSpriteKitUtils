//
//  File.swift
//  Repel
//
//  Created by Txai Wieser on 7/22/15.
//
//

import SpriteKit


open class TWStackNode: SKSpriteNode {
    open private(set) var fillMode: FillMode = FillMode.vertical
    open private(set) var subNodes: [SKNode] = []
    public let automaticSpacing: Bool
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public init(length: CGFloat, fillMode: FillMode) {
        self.fillMode = fillMode
        self.automaticSpacing = false
        super.init(texture: nil, color: .clear, size: fillMode.size(length))
    }
    
    public init(size: CGSize, fillMode: FillMode) {
        self.fillMode = fillMode
        self.automaticSpacing = true
        super.init(texture: nil, color: .clear, size: size)
    }
    
    open func reloadStack() {
        var accumulatedLength = CGFloat(0)
        
        switch fillMode {
        case .vertical:
            if automaticSpacing {
                let firstMargin = subNodes.first!.calculateAccumulatedFrame().height/2
                let lastMargin = subNodes.last!.calculateAccumulatedFrame().height/2

                for (index, node) in subNodes.enumerated() {
                    node.position.y = -CGFloat(index)*(size.height - firstMargin - lastMargin)/CGFloat(subNodes.count-1) + self.size.height/2
                    node.position.y -= firstMargin
                }
            } else {
                for node in subNodes {
                    let f = node.calculateAccumulatedFrame()
                    let ff =  f.maxY
                    _ = ff - f.size.height/2
                    
                    node.position.y = -(accumulatedLength + f.size.height/2)// - fff
                    accumulatedLength += f.size.height
                }
                subNodes.forEach { $0.position.y += accumulatedLength/2 }
                self.size.height = accumulatedLength
            }
            
        case .horizontal:
            if automaticSpacing {
                for (index, node) in subNodes.enumerated() {
                    let firstMargin = subNodes.first!.calculateAccumulatedFrame().width/2
                    let lastMargin = subNodes.last!.calculateAccumulatedFrame().width/2
                    node.position.x = CGFloat(index)*(size.width - firstMargin - lastMargin)/CGFloat(subNodes.count-1) - self.size.width/2
                    node.position.x += firstMargin
                }
            } else  {
                for node in subNodes {
                    let f = node.calculateAccumulatedFrame()
                    let ff =  f.minX
                    let fff = ff + f.size.width/2
                    
                    node.position.x = (accumulatedLength + f.size.width/2) - fff
                    accumulatedLength += f.size.width
                }
                subNodes.forEach { $0.position.x -= accumulatedLength/2 }
                self.size.width = accumulatedLength
            }
        }
        
    }
    
    open func add(node: SKNode, reload: Bool = false) {
        subNodes.append(node)
        self.addChild(node)
        
        if reload {
            self.reloadStack()
        }
    }
    
    open func remove(node: SKNode?, reload: Bool = false) {
        if let n = node {
            n.removeFromParent()
            if let ind = subNodes.firstIndex(of: n) {
                subNodes.remove(at: ind)
            }
        
            if reload {
                self.reloadStack()
            }
        }
    }
    
    public enum FillMode {
        case horizontal
        case vertical
        
        func size(_ length: CGFloat) -> CGSize {
            switch self {
            case .horizontal:
                return CGSize(width: length, height: 2)
            case .vertical:
                return CGSize(width: 2, height: length)
            }
        }
        
        func length(_ size: CGSize) -> CGFloat {
            switch self {
            case .horizontal:
                return size.width
            case .vertical:
                return size.height
            }
        }
    }
}

public extension SKNode {
    func removeNodeFromStack(_ withRefresh: Bool = true) {
        if let stack = self.parent as? TWStackNode {
            stack.remove(node: self, reload: withRefresh)
        } else {
            let message = "TWSKUtils ERROR: Node is not in a TWStackNode"
            assertionFailure(message)
        }
    }
}
