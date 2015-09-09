//
//  File.swift
//  Repel
//
//  Created by Txai Wieser on 7/22/15.
//
//

import SpriteKit

public class TWCollectionNode:SKSpriteNode {
    private(set) var fillMode:FillMode
    private(set) var subNodes:[SKNode] = []
    
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public init(fillMode: FillMode) {
        self.fillMode = fillMode
        super.init(texture: nil, color: SKColor.clearColor(), size: CGSize(width: fillMode.width, height: 0))
    }
    
    
    public func reloadCollection() {
        let elements = subNodes.count
        let columns = fillMode.columns
        
        let xDiv = (fillMode.width - CGFloat(fillMode.columns)*fillMode.objectSize.width) / CGFloat(fillMode.columns-1)
        let lines = Int(ceil(CGFloat(elements)/CGFloat(columns)))
        var accumulatedHeight = CGFloat(0)
        for lineIndex in 0..<lines {
            let resta = elements - lineIndex*columns
            let distance = fillMode.objectSize.height + fillMode.verticalMargin
            for columnIdex in 0..<min(columns, resta) {
                let xPos = (-size.width/2 + fillMode.objectSize.width/2) + CGFloat(columnIdex)*(fillMode.objectSize.width+xDiv)
                let yPos = -CGFloat(lineIndex)*distance - fillMode.objectSize.height/2
                subNodes[lineIndex*columns + columnIdex].position = CGPoint(x: xPos, y: yPos)
            }
            accumulatedHeight += distance
        }
        subNodes.forEach { $0.position.y += accumulatedHeight/2 - self.fillMode.verticalMargin/2 }
        self.size.height = accumulatedHeight - self.fillMode.verticalMargin
    }
    
    public func addNode(node: SKNode, reload:Bool = false) {
        subNodes.append(node)
        self.addChild(node)
        
        if reload {
            self.reloadCollection()
        }
    }
    
    func removeNode(node: SKNode, reload:Bool = false) {
        if let ind = subNodes.indexOf(node) {
            subNodes.removeAtIndex(ind)
        }
        
        if reload {
            self.reloadCollection()
        }
    }
    
    public struct FillMode {
        let columns:Int
        let width:CGFloat
        let verticalMargin:CGFloat
        let objectSize:CGSize
        
        public init(columns: Int, width: CGFloat, verticalMargin: CGFloat, objectSize: CGSize) {
            self.columns = columns
            self.width = width
            self.verticalMargin = verticalMargin
            self.objectSize = objectSize
        }
    }
}


public extension SKNode {
    public func removeNodeFromCollection(withRefresh:Bool = true) {
        if let collection = self.parent as? TWCollectionNode {
            collection.removeNode(self)
            if withRefresh {
                collection.reloadCollection()
            }
        } else {
            assertionFailure("Node is not in a TWCollectionNode")
        }
    }
}