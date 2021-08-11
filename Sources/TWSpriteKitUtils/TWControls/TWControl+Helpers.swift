import SpriteKit

internal extension TWControl {
    func playSound(instanceSoundFileName fileName: String?, defaultSoundFileName: String?) {
        guard TWControl.defaultSoundEffectsEnabled ?? soundEffectsEnabled else { return }
        guard let soundFileName = fileName ?? defaultSoundFileName else { return }
        
        run(.playSoundFileNamed(soundFileName, waitForCompletion: true))
    }
}
