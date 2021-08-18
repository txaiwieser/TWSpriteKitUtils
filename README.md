# SpriteKit Utils - Buttons, Switches, Stacks and Collections for SpriteKit!

## Easy to use SpriteKit controls

* TWButton: A SKSpriteNode subclass that implements commom button funcionalities (similar to UIKit's UIButton).
* TWSwitch: A SKSpriteNode subclass that implements commom switch funcionalities (similar to UIKit's UISwitch).
* TWStack: A SKSpriteNode subclass that implements commom stack funcionalities (similar to UIKit's UIStackView).
* TWCollection: A SKSpriteNode subclass that implements commom collection funcionalities (similar to UIKit's UICollectionView).

![Demonstration](https://github.com/txaidw/TWControls/blob/master/demo.gif)

Here's a full init code snippet:

## TWButton
```swift
let colorButton = TWButton(
    size: CGSize(width: 102, height: 40),
    normal: .blue,
    highlighted: .yellow,
    disabled: .gray
)

colorButton.addClosure(.touchUpInside) { [unowned self] _ in
    // Action
}
```

## TWSwitch
```swift
let colorSwitch = TWSwitch(
    size: CGSize(width: 102, height: 40),
    normal: .blue,
    highlighted: .yellow,
    selected: .green,
    disabled: .gray
)

colorSwitch.addClosure(.selectionChanged) { [unowned self] _ in
    // Action
}
```

## TWStackNode
```swift
let stackNode = TWStackNode(
    fillMode: .vertical,
    sizingMode: .dynamic(spacing: 8)
)
```

## TWCollectionNode
```swift
let collectionNode = TWCollectionNode(
    fillMode: .init(
	columnsCount: 3,
	lineSpacing: 30,
	elementSize: CGSize(width: 100, height: 100)
    )
)
```

## License

See LICENSE for more information

