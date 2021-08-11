import SpriteKit
import TWSpriteKitUtils

class SwitchNodeDemoScene: SKScene {
    override func didMove(to view: SKView) {
        size = view.bounds.size
        backgroundColor = .orange
        
        textureSwitch.touchDownSoundFileName = "touchDown.wav"
        textureSwitch.touchUpSoundFileName = "touchUp.wav"
                
        addChild(switchesContainer)
        switchesContainer.addChild(colorSwitch)
        switchesContainer.addChild(textureSwitch)
        switchesContainer.addChild(textSwitch)
    
        colorSwitch.addClosure(.touchUpInside, target: self) { (scene, control) -> () in
            scene.textureSwitch.enabled = control.selected
            scene.textSwitch.enabled = control.selected
        }
        
        textureSwitch.addClosure(.touchUpInside, target: self) { (scene, control) -> () in
            scene.colorSwitch.enabled = control.selected
            scene.textSwitch.enabled = control.selected
        }
        
        textSwitch.addClosure(.touchUpInside, target: self) { (scene, control) -> () in
            scene.colorSwitch.enabled = control.selected
            scene.textureSwitch.enabled = control.selected
            print(control.selected)
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
            normalColor: .blue,
            selectedColor: .orange
        )
        s.disabledStateColor = .gray
        s.setDisabledStateLabelText("DISABLED")
        s.setNormalStateLabelText("ON")
        s.setSelectedStateLabelText("OFF")
        s.setAllStatesLabelFontSize(20)
        s.setAllStatesLabelFontName("Helvetica")
        s.position = CGPoint(x: 0, y: 40)
        return s
    }()
    
    private lazy var textureSwitch: TWSwitch = {
        let s = TWSwitch(
            normalTexture: SKTexture(imageNamed: "switch_off"),
            selectedTexture: SKTexture(imageNamed: "switch_on")
        )
        s.disabledStateTexture = SKTexture(imageNamed: "switch_d")
        s.highlightedStateSingleTexture = SKTexture(imageNamed: "button_n")
        s.position = CGPoint(x: 0, y: -40)
        return s
    }()
    
    private lazy var textSwitch: TWSwitch = {
        let s = TWSwitch(
            normalText: "ON",
            selectedText: "OFF"
        )
        s.setDisabledStateLabelText("DISABLED")
        s.setHighlightedStateSingleLabelText("HIGHLIGHTED")
        s.setAllStatesLabelFontColor(.black)
        s.position = CGPoint(x: 0, y: -120)
        return s
    }()
}
