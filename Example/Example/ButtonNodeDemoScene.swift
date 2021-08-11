import SpriteKit
import TWSpriteKitUtils

class ButtonNodeDemoScene: SKScene {
    override func didMove(to view: SKView) {
        size = view.bounds.size
        backgroundColor = .orange
        
        TWControl.defaultTouchDownSoundFileName = "touchDownDefault.wav"
        TWControl.defaultTouchUpSoundFileName = "touchUpDefault.wav"
        TWControl.defaultDisabledTouchDownFileName = "touchDown_disabled.wav"
        
        addChild(colorButton)
        addChild(textureButton)
        addChild(textButton)
        
        colorButton.addClosure(.touchUpInside, target: self) { (scene, control) -> () in
            scene.textureButton.enabled.toggle()
            scene.textButton.enabled.toggle()
        }
        
        textureButton.addClosure(.touchUpInside, target: self) { (scene, control) -> () in
            scene.colorButton.enabled.toggle()
            scene.textButton.enabled.toggle()
        }
        
        textButton.addClosure(.touchUpInside, target: self) { (scene, control) -> () in
            scene.colorButton.enabled.toggle()
            scene.textureButton.enabled.toggle()
        }
    }
    
    private lazy var colorButton: TWButton = {
        let b = TWButton(
            size: CGSize(width: 102, height: 40),
            normalColor: .purple,
            highlightedColor: nil
        )
        b.disabledStateColor = .gray
        b.setDisabledStateLabelText("DISABLED")
        b.setNormalStateLabelText("PLAY")
        b.setHighlightedStateSingleLabelText("PRESSED")
        b.setAllStatesLabelFontSize(20)
        b.setAllStatesLabelFontName("Helvetica")
        b.position = CGPoint(x: size.width/2, y: size.height/2 + 200)
        return b
    }()
    
    private lazy var textureButton: TWButton = {
        let b = TWButton(
            normalTexture: SKTexture(imageNamed: "button_n"),
            highlightedTexture: SKTexture(imageNamed: "button_h")
        )
        b.disabledStateTexture = SKTexture(imageNamed: "button_d")
        b.touchDownSoundFileName = "touchDown.wav"
        b.touchUpSoundFileName = "touchUp.wav"
        b.position = CGPoint(x: size.width/2, y: size.height/2 + 0)
        return b
    }()
    
    private lazy var textButton:TWButton = {
        let b = TWButton(normalText: "PLAY", highlightedText: "PRESSED")
        b.setDisabledStateLabelText("DISABLED")
        b.setAllStatesLabelFontColor(.black)
        b.position = CGPoint(x: size.width/2, y: size.height/2 + -200)
        return b
    }()
}
