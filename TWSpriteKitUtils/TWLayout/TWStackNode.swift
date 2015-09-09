//
//  File.swift
//  Repel
//
//  Created by Txai Wieser on 7/22/15.
//
//

import SpriteKit


public class TWStackNode:SKSpriteNode {
    private(set) var fillMode:FillMode = FillMode.Vertical
    private(set) var subNodes:[SKNode] = []
    public var automaticSpacing = false
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public init(lenght: CGFloat, fillMode:FillMode = .Vertical) {
        self.fillMode = fillMode
        super.init(texture: nil, color: SKColor.clearColor(), size: fillMode.size(lenght))
    }
    
    public init(size: CGSize, fillMode:FillMode = .Vertical) {
        self.fillMode = fillMode
        self.automaticSpacing = true
        super.init(texture: nil, color: SKColor.clearColor(), size: size)
    }
    
    public func reloadStack() {
        var accumulatedLenght = CGFloat(0)
        
        switch fillMode {
        case .Vertical:
            if automaticSpacing == false {
                for node in subNodes {
                    let f = node.calculateAccumulatedFrame()
                    let ff =  f.maxY
                    let fff = ff - f.size.height/2
                    
                    node.position.y = -(accumulatedLenght + f.size.height/2) - fff
                    accumulatedLenght += f.size.height
                }
                subNodes.forEach { $0.position.y += accumulatedLenght/2 }
                self.size.height = accumulatedLenght
            } else {
                for (index, node) in subNodes.enumerate() {
                    let firstMargin = subNodes.first!.calculateAccumulatedFrame().height/2
                    let lastMargin = subNodes.last!.calculateAccumulatedFrame().height/2
                    node.position.y = -CGFloat(index)*(size.height - firstMargin - lastMargin)/CGFloat(subNodes.count-1) + self.size.height/2
                    node.position.y -= firstMargin
                }
            }
            
        case .Horizontal:
            if automaticSpacing == false {
                for node in subNodes {
                    let f = node.calculateAccumulatedFrame()
                    let ff =  f.minX
                    let fff = ff + f.size.width/2
                    
                    node.position.x = (accumulatedLenght + f.size.width/2) - fff
                    accumulatedLenght += f.size.width
                }
                subNodes.forEach { $0.position.x -= accumulatedLenght/2 }
                self.size.width = accumulatedLenght
            } else {
                for (index, node) in subNodes.enumerate() {
                    let firstMargin = subNodes.first!.calculateAccumulatedFrame().width/2
                    let lastMargin = subNodes.last!.calculateAccumulatedFrame().width/2
                    node.position.x = CGFloat(index)*(size.width - firstMargin - lastMargin)/CGFloat(subNodes.count-1) - self.size.width/2
                    node.position.x += firstMargin
                }
            }
        }
        
    }
    
    public func addNode(node: SKNode, reload:Bool = false) {
        subNodes.append(node)
        self.addChild(node)
        
        if reload {
            self.reloadStack()
        }
    }
    
    public func removeNode(node: SKNode, reload:Bool = false) {
        if let ind = subNodes.indexOf(node) {
            subNodes.removeAtIndex(ind)
        }
        
        if reload {
            self.reloadStack()
        }
    }
    
    public enum FillMode {
        case Horizontal
        case Vertical
        
        func size(lenght:CGFloat) -> CGSize {
            switch self {
            case .Horizontal:
                return CGSize(width: lenght, height: 2)
            case .Vertical:
                return CGSize(width: 2, height: lenght)
            }
        }
        
        func lenght(size:CGSize) -> CGFloat {
            switch self {
            case .Horizontal:
                return size.width
            case .Vertical:
                return size.height
            }
        }
    }
}