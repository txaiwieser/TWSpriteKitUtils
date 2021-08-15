import SpriteKit
import TWSpriteKitUtils

class ButtonNodeDemoScene: SKScene {
    override func didMove(to view: SKView) {
        size = view.bounds.size
        backgroundColor = .white
        
        TWButton.defaultSoundEffects[.touchDown] = "touchDownDefault.wav"
        TWButton.defaultSoundEffects[.touchUpInside] = "touchUpDefault.wav"
        TWButton.defaultSoundEffects[.disabledTouchDown] = "touchDown_disabled.wav"
        
        addChild(colorButton)
        addChild(textureButton)
        addChild(textButton)
        
        colorButton.addClosure(.touchUpInside) { [unowned self] _ in
            textureButton.state.isEnabled.toggle()
            textButton.state.isEnabled.toggle()
        }
        
        textureButton.addClosure(.touchUpInside) { [unowned self] _ in
            colorButton.state.isEnabled.toggle()
            textButton.state.isEnabled.toggle()
        }
        
        textButton.addClosure(.touchUpInside) { [unowned self] _ in
            colorButton.state.isEnabled.toggle()
            textureButton.state.isEnabled.toggle()
        }
    }
    
    private lazy var colorButton: TWButton = {
        let b = TWButton(
            size: CGSize(width: 102, height: 40),
            normal: .blue,
            highlighted: .yellow,
            disabled: .gray
        )
        b.position = CGPoint(x: size.width/2, y: size.height/2 + 100)
        return b
    }()
    
    private lazy var textureButton: TWButton = {
        let b = TWButton(
            size: CGSize(width: 102, height: 40),
            normal: SKTexture(imageNamed: "button_n"),
            highlighted: SKTexture(imageNamed: "button_h"),
            disabled: SKTexture(imageNamed: "button_d")
        )
        b.soundEffects[.touchDown] = "touchDown.wav"
        b.soundEffects[.touchUpInside] = "touchUp.wav"
        b.position = CGPoint(x: size.width/2, y: size.height/2 + 0)
        return b
    }()
    
    private lazy var textButton: TWButton = {
        let playLabel = SKLabelNode(text: "PLAY")
        playLabel.fontColor = .black
        let pressedLabel = SKLabelNode(text: "PRESSED")
        pressedLabel.fontColor = .gray
        let disabledLabel = SKLabelNode(text: "DISABLED")
        disabledLabel.fontColor = .lightGray
        
        let b = TWButton(normal: playLabel, highlighted: pressedLabel, disabled: disabledLabel)
        b.position = CGPoint(x: size.width/2, y: size.height/2 + -100)
        return b
    }()
}
