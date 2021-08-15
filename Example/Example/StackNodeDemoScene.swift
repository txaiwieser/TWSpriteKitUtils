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
        
        let addNormal = SKLabelNode(text: "Add")
        addNormal.color = .white
        let addHighlighted = SKLabelNode(text: "Add")
        addHighlighted.color = .black
        let addButton = TWButton(normal: addNormal, highlighted: addHighlighted, disabled: nil)
        addButton.position = CGPoint(x: view.frame.midX + 200, y: view.frame.midY + 400)
        addButton.addClosure(.touchUpInside) { [unowned self] _ in
            addToStack()
        }
        
        let removeNormal = SKLabelNode(text: "Add")
        removeNormal.color = .white
        let removeHighlighted = SKLabelNode(text: "Add")
        removeHighlighted.color = .black
        
        let removeButton = TWButton(normal: removeNormal, highlighted: removeHighlighted, disabled: nil)
        removeButton.position = CGPoint(x: view.frame.midX - 200, y: view.frame.midY + 400)
        removeButton.addClosure(.touchUpInside) { [unowned self] _ in
            removeFromStack()
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
