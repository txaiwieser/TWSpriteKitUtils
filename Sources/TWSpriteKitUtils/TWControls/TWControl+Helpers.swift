import SpriteKit

extension SKNode {
    func playSound(
        soundEffectsEnabled: Bool,
        soundFileName: String?,
        defaultSoundFileName: String?,
        defaultSoundEffectsEnabled: Bool
    ) {
        guard soundEffectsEnabled else { return }
        var soundFileName = soundFileName
        if soundFileName == nil {
            guard defaultSoundEffectsEnabled else { return }
            soundFileName = defaultSoundFileName
        }
        guard let soundFileName = soundFileName else { return }
        run(.playSoundFileNamed(soundFileName, waitForCompletion: true))
    }
}

extension SKAction {
    static func soundPreLoad(_ named: String) {
        _ = SKAction.playSoundFileNamed(named, waitForCompletion: true)
    }
}

extension TWButton {
    func playSound(for event: ControlEvent) {
        playSound(
            soundEffectsEnabled: soundEffectsEnabled,
            soundFileName: soundEffects[event],
            defaultSoundFileName: TWButton.defaultSoundEffects[event],
            defaultSoundEffectsEnabled: TWButton.defaultSoundEffectsEnabled
        )
    }
}

extension TWSwitch {
    func playSound(for event: ControlEvent) {
        playSound(
            soundEffectsEnabled: soundEffectsEnabled,
            soundFileName: soundEffects[event],
            defaultSoundFileName: TWSwitch.defaultSoundEffects[event],
            defaultSoundEffectsEnabled: TWSwitch.defaultSoundEffectsEnabled
        )
    }
}
