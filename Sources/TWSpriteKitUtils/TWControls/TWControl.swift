import SpriteKit

public protocol TWControl: AnyObject {
    associatedtype ControlEvent: Hashable
    var eventClosures: [ControlEvent: [(Self) -> Void]] { get set }
}

public extension TWControl {
    func addClosure(_ event: ControlEvent, closure: @escaping (_ sender: Self) -> Void) {
        let closures = eventClosures[event] ?? []
        eventClosures[event] = closures + [closure]
    }
    
    func removeClosures(for event: ControlEvent) {
        eventClosures[event] = nil
    }

    internal func executeClosures(of event: ControlEvent) {
        guard let closures = eventClosures[event] else { return }
        for eventClosure in closures {
            eventClosure(self)
        }
    }
}
