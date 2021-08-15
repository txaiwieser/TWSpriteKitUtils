import SpriteKit

internal extension TWControl {
    func playSound(instanceSoundFileName fileName: String?, defaultSoundFileName: String?) {
        guard TWControl.defaultSoundEffectsEnabled ?? soundEffectsEnabled else { return }
        guard let soundFileName = fileName ?? defaultSoundFileName else { return }
        
        run(.playSoundFileNamed(soundFileName, waitForCompletion: true))
    }
}

internal extension TWButton {
    func playSound(instanceSoundFileName fileName: String?, defaultSoundFileName: String?) {
        guard soundEffectsEnabled else { return }
        var soundFileName = fileName
        if soundFileName == nil {
            guard TWButton.defaultSoundEffectsEnabled else { return }
            soundFileName = defaultSoundFileName
        }
        guard let soundFileName = soundFileName else { return }
        run(.playSoundFileNamed(soundFileName, waitForCompletion: true))
    }
    
    func playSound(for event: ControlEvent) {
        playSound(instanceSoundFileName: soundEffects[event], defaultSoundFileName: TWButton.defaultSoundEffects[event])

    }
}

internal extension SKAction {
    static func soundPreLoad(_ named: String) {
        _ = SKAction.playSoundFileNamed(named, waitForCompletion: true)
    }
}
