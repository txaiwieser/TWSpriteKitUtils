import SpriteKit
import TWSpriteKitUtils

class StackNodeDemoScene: SKScene {
    private var stack: TWStackNode!
    
    override func didMove(to view: SKView) {
        size = view.bounds.size
        backgroundColor = .lightGray
        
        stack = TWStackNode(length: view.frame.size.width * 0.8, fillMode: .vertical)
            
        stack.position = CGPoint(x: view.frame.midX, y: view.frame.midY)
        stack.color = .red
        addChild(stack)
        
        let addButton = TWButton(normalText: "Add", highlightedText: nil)
        addButton.highlightedStateSingleColor = .black
        addButton.normalStateColor = .white
        addButton.position = CGPoint(x: view.frame.midX + 200, y: view.frame.midY + 400)
        addButton.addClosure(.touchUpInside, target: self) { (target, sender) -> () in
            target.addToStack()
        }
        
        let removeButton = TWButton(normalText: "Remove", highlightedText: nil)
        removeButton.highlightedStateSingleColor = .black
        removeButton.normalStateColor = .white
        removeButton.position = CGPoint(x: view.frame.midX - 200, y: view.frame.midY + 400)
        removeButton.addClosure(.touchUpInside, target: self) { (target, sender) -> () in
            target.removeFromStack()
        }
        
        
        addChild(addButton)
        addChild(removeButton)
    }
    
    func addToStack() {
        let color = [SKColor.red, .green, .blue, .cyan, .yellow, .magenta, .orange].randomElement()!
        let node = SKSpriteNode(color: color, size: CGSize(width: 100, height: 100))
        stack.add(node: node, reload: true)
    }
    
    func removeFromStack() {
        let node = stack.subNodes.last
        stack.remove(node: node, reload: true)
    }
}
