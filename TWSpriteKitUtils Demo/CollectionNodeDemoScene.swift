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
    var collection:TWCollectionNode!
        
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor.lightGrayColor()
        
        collection = TWCollectionNode(fillMode: TWCollectionNode.FillMode(columns: 3, width: view.frame.size.width*0.8, verticalMargin: 30, objectSize: CGSize(width: 100, height: 100)))
        collection.position = CGPoint(x: CGRectGetMidX(view.frame), y: CGRectGetMidY(view.frame))
        collection.color = SKColor.blueColor()
        addChild(collection)
        
        let addButton = TWButton(normalText: "Add", highlightedText: nil)
        addButton.highlightedStateSingleColor = SKColor.blackColor()
        addButton.normalStateColor = SKColor.whiteColor()
        addButton.position = CGPoint(x: CGRectGetMidX(view.frame) + 200, y: CGRectGetMidY(view.frame) + 400)
        addButton.addClosure(.TouchUpInside, target: self) { (target, sender) -> () in
            target.addToCollection()
        }
        
        let removeButton = TWButton(normalText: "Remove", highlightedText: nil)
        removeButton.highlightedStateSingleColor = SKColor.blackColor()
        removeButton.normalStateColor = SKColor.whiteColor()
        removeButton.position = CGPoint(x: CGRectGetMidX(view.frame) - 200, y: CGRectGetMidY(view.frame) + 400)
        removeButton.addClosure(.TouchUpInside, target: self) { (target, sender) -> () in
            target.removeFromCollection()
        }

        
        addChild(addButton)
        addChild(removeButton)
    }
    
    func addToCollection() {
        func randomColor() -> SKColor {
            let colors = [SKColor.redColor(), SKColor.greenColor(), SKColor.blueColor(), SKColor.cyanColor(), SKColor.yellowColor(), SKColor.magentaColor(), SKColor.orangeColor()]
            return colors[Int(arc4random_uniform(UInt32(colors.count)))]
        }
        
        let node = SKSpriteNode(color: randomColor(), size: CGSize(width: 100, height: 100))
        collection.addNode(node, reload: true)
    }
    
    func removeFromCollection() {
        let node = collection.subNodes.last
        collection.removeNode(node, reload: true)
    }
}
