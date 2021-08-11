import SpriteKit

open class TWSwitch: TWControl {

    
    // MARK: Convenience Initializers
    public convenience init(normalText: String, selectedText: String?) {
        self.init(normalText: normalText, selectedText: selectedText, singleHighlightedText: nil, disabledText: nil)
    }
    
    public convenience init(normalTexture: SKTexture, selectedTexture: SKTexture?) {
        self.init(normalTexture: normalTexture, selectedTexture: selectedTexture, singleHighlightedTexture: nil, disabledTexture: nil)
    }
    
    public convenience init(normalShape: SKShapeNode.Definition, selectedShape: SKShapeNode.Definition?) {
        self.init(normalShape: normalShape, selectedShape: selectedShape, singleHighlightedShape: nil, disabledShape: nil)
    }
    
    public convenience init(size: CGSize, normalColor: SKColor, selectedColor: SKColor?) {
        self.init(size: size, normalColor: normalColor, selectedColor: selectedColor, singleHighlightedColor: nil, disabledColor: nil)
    }
    
    fileprivate var selectedStateMemory = false
    // MARK: Switch Methods
    
    open override var selected:Bool {
        get { return super.selected }
        set { super.selected = newValue; self.selectedStateMemory = newValue }
    }
    
    // MARK: TWSwitch Events
    
    internal override func touchDown() {
        self.highlighted = true
        super.touchDown()
    }
    
    internal override func disabledTouchDown() {
        super.disabledTouchDown()
    }
    
    internal override func drag() {
        super.drag()
    }
    
    internal override func dragExit() {
        self.highlighted = false
        super.dragExit()
    }
    
    internal override func dragOutside() {
        super.dragOutside()
    }
    
    internal override func dragEnter() {
        self.highlighted = true
        super.dragEnter()
    }
    
    internal override func dragInside() {
        super.dragInside()
    }
    
    // WARNING: This should not be public ;/
    open override func touchUpInside() {
        selectedStateMemory = !selectedStateMemory
        self.selected = selectedStateMemory
        super.touchUpInside()
    }
    
    internal override func touchUpOutside() {
        super.touchUpOutside()
    }
}
