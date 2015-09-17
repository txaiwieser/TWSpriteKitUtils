//
//  TableViewController.swift
//  TWSpriteKitUtils
//
//  Created by Txai Wieser on 9/17/15.
//  Copyright © 2015 Txai Wieser. All rights reserved.
//

import UIKit
import SpriteKit

class TableViewController: UITableViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nvc = segue.destinationViewController as? UINavigationController
        let skView = nvc?.viewControllers.first?.view as? SKView
        
        let transition = SKTransition.crossFadeWithDuration(2)
        
        switch segue.identifier! {
        case "ButtonsSegue":
            skView?.presentScene(ButtonsDemoScene(), transition: transition)
        case "SwitchesSegue":
            skView?.presentScene(SwitchesDemoScene(), transition: transition)
        case "CollectionNodeSegue":
            skView?.presentScene(CollectionNodeDemoScene(), transition: transition)
        case "StackNodeSegue":
            skView?.presentScene(StackNodeDemoScene(), transition: transition)
        default:
            break
        }
    }
    
}
