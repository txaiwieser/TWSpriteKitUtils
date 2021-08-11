//
//  ButtonsDemoScene.swift
//  TWSpriteKitUtils
//
//  Created by Txai Wieser on 9/17/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import SpriteKit
import TWSpriteKitUtils

class CollectionNodeDemoScene: SKScene {
    private var collection: TWCollectionNode!
        
    override func didMove(to view: SKView) {
        size = view.bounds.size
        backgroundColor = .lightGray
        
        collection = TWCollectionNode(fillMode: TWCollectionNode.FillMode(columns: 3, width: view.frame.size.width*0.8, verticalMargin: 30, objectSize: CGSize(width: 100, height: 100)))
        collection.position = CGPoint(x: (view.frame).midX, y: (view.frame).midY)
        addChild(collection)
        
        let addButton = TWButton(normalText: "Add", highlightedText: nil)
        addButton.highlightedStateSingleColor = .black
        addButton.normalStateColor = .white
        addButton.position = CGPoint(x: (view.frame).midX + 200, y: (view.frame).midY + 400)
        addButton.addClosure(.touchUpInside, target: self) { (target, sender) -> () in
            target.addToCollection()
        }
        
        let removeButton = TWButton(normalText: "Remove", highlightedText: nil)
        removeButton.highlightedStateSingleColor = .black
        removeButton.normalStateColor = .white
        removeButton.position = CGPoint(x: (view.frame).midX - 200, y: (view.frame).midY + 400)
        removeButton.addClosure(.touchUpInside, target: self) { (target, sender) -> () in
            target.removeFromCollection()
        }

        
        addChild(addButton)
        addChild(removeButton)
    }
    
    func addToCollection() {
        let color = [SKColor.red, .green, .blue, .cyan, .yellow, .magenta, .orange].randomElement()!
        let node = SKSpriteNode(color: color, size: CGSize(width: 100, height: 100))
        collection.add(node: node, reload: true)
    }
    
    func removeFromCollection() {
        let node = collection.subNodes.last
        collection.remove(node: node, reload: true)
    }
}
