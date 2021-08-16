import SpriteKit
import TWSpriteKitUtils

class SwitchNodeDemoScene: SKScene {
    override func didMove(to view: SKView) {
        size = view.bounds.size
        backgroundColor = .orange
        
        TWSwitch.defaultSoundEffects[.touchDown] = "touchDownDefault.wav"
        TWSwitch.defaultSoundEffects[.touchUpInside] = "touchUpDefault.wav"
        TWSwitch.defaultSoundEffects[.disabledTouchDown] = "touchDown_disabled.wav"
                
        addChild(switchesContainer)
        switchesContainer.addChild(colorSwitch)
        switchesContainer.addChild(textureSwitch)
        switchesContainer.addChild(textSwitch)
    
        colorSwitch.addClosure(.touchUpInside) { [unowned self] control in
            textureSwitch.state.isEnabled = control.state.isSelected
            textSwitch.state.isEnabled = control.state.isSelected
        }
        
        textureSwitch.addClosure(.touchUpInside) { [unowned self] control in
            colorSwitch.state.isEnabled = control.state.isSelected
            textSwitch.state.isEnabled = control.state.isSelected
        }
        
        textSwitch.addClosure(.touchUpInside) { [unowned self] control in
            colorSwitch.state.isEnabled = control.state.isSelected
            textureSwitch.state.isEnabled = control.state.isSelected
        }
    }
    
    private lazy var switchesContainer: SKSpriteNode = {
        let n = SKSpriteNode(
            color: .white,
            size: CGSize(width: 220, height: 320)
        )
        n.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        let l = SKLabelNode(text: "Switches")
        l.fontName = "Helvetica"
        l.fontColor = .black
        l.position = CGPoint(x: 0, y: n.size.height/2-l.frame.height - 10)
        n.addChild(l)
        return n
    }()
    
    private lazy var colorSwitch: TWSwitch = {
        let s = TWSwitch(
            size: CGSize(width: 102, height: 40),
            normal: .blue,
            highlighted: .yellow,
            selected: .green,
            disabled: .gray
        )
        s.position = CGPoint(x: 0, y: 40)
        return s
    }()
    
    private lazy var textureSwitch: TWSwitch = {
        let s = TWSwitch(
            size: CGSize(width: 102, height: 40),
            normal: SKTexture(imageNamed: "switch_off"),
            highlighted: SKTexture(imageNamed: "button_n"),
            selected: SKTexture(imageNamed: "switch_on"),
            disabled: SKTexture(imageNamed: "switch_d")
        )
        s.soundEffects[.touchDown] = "touchDown.wav"
        s.soundEffects[.touchUpInside] = "touchUp.wav"
        s.position = CGPoint(x: 0, y: -40)
        return s
    }()
    
    private lazy var textSwitch: TWSwitch = {
        let normalLabel = SKLabelNode(text: "OFF")
        normalLabel.fontColor = .black
        let selectedLabel = SKLabelNode(text: "ON")
        selectedLabel.fontColor = .green
        let pressedLabel = SKLabelNode(text: "PRESSED")
        pressedLabel.fontColor = .gray
        let disabledLabel = SKLabelNode(text: "DISABLED")
        disabledLabel.fontColor = .lightGray
        
        let s = TWSwitch(normal: normalLabel, highlighted: pressedLabel, selected: selectedLabel, disabled: disabledLabel)
        s.position = CGPoint(x: 0, y: -120)
        return s
    }()
}
