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
        
        collection = TWCollectionNode(fillMode: .init(columnsCount: 3, lineSpacing: 30, elementSize: CGSize(width: 100, height: 100)))
        collection.size.width = view.frame.size.width * 0.8
        collection.position = CGPoint(x: (view.frame).midX, y: (view.frame).midY)
        collection.color = .brown
        addChild(collection)
        
        let normalLabelAdd = SKLabelNode(text: "Add")
        normalLabelAdd.color = .white
        let highlightedLabelAdd = SKLabelNode(text: "Add")
        highlightedLabelAdd.color = .black
        
        let addButton = TWButton(normal: normalLabelAdd, highlighted: highlightedLabelAdd, disabled: nil)
        addButton.position = CGPoint(x: (view.frame).midX + 150, y: (view.frame).midY + 150)
        addButton.addClosure(.touchUpInside) { [unowned self] _ in
            addToCollection()
        }
        
        let normalLabelRemove = SKLabelNode(text: "Remove")
        normalLabelRemove.color = .white
        let highlightedLabelRemove = SKLabelNode(text: "Remove")
        highlightedLabelRemove.color = .black
        
        
        let removeButton = TWButton(normal: normalLabelRemove, highlighted: highlightedLabelRemove, disabled: nil)
        removeButton.position = CGPoint(x: (view.frame).midX - 150, y: (view.frame).midY + 150)
        removeButton.addClosure(.touchUpInside) { [unowned self] _ in
            removeFromCollection()
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
        let node = collection.childNodes.last
        collection.remove(node: node, reload: true)
    }
}
