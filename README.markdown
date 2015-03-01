# SwiftGraphics

## **IMPORTANT**

All development happens on the [develop][develop] branch. Code is merged back on master branch sometimes.

[develop]: https://github.com/txaidw/TWControls/tree/develop

This project requires Swift 1.2 and Xcode 6.3.

## Easy to use SpriteKit controls

* TWControl: A base class with handlers for UIControlEvents.
* TWButton: Subclass of TWControl that implements a complete button for SpriteKit.
* TWSwitch: Subclass of TWControl that implements a complete switch for SpriteKit.

![Demonstration](demo.png)

## What's included

For now we have 3 types of controls:

* Color: A simple colored rectangle;
* Texture: Controls with textures;
* Text: Controls only with labels;

**Color and Texture control types can have text labels too.

## Usage

You can set up a TWButton using one of the following initializers:

    init(normalText: String, highlightedText: String)
    init(normalTexture: SKTexture, highlightedTexture: SKTexture) 
    init(normalColor: SKColor, highlightedColor: SKColor, size:CGSize) 

You can set up a TWSwitch using one of the following initializers:
	    
	init(normalText: String, selectedText: String)
    init(normalTexture: SKTexture, selectedTexture: SKTexture)
    init(normalColor: SKColor, selectedColor: SKColor, size:CGSize)

Or you can set up any of them using the complete methods found on TWControl:

    init(normalTexture:SKTexture, highlightedTexture:SKTexture, selectedTexture:SKTexture, disabledTexture:SKTexture)
    init(normalColor:SKColor, highlightedColor:SKColor, selectedColor:SKColor, disabledColor:SKColor, size:CGSize)
    init(normalText:String, highlightedText:String, selectedText:String, disabledText:String)


You can customize the controls using the following properties:

    // TYPE Color Customizations
    internal var stateDisabledColor:SKColor!
    internal var stateHighlightedColor:SKColor!
    internal var stateNormalColor:SKColor!
    internal var stateSelectedColor:SKColor!
    
    // TYPE Texture Customizations
    internal var stateDisabledTexture:SKTexture!
    internal var stateHighlightedTexture:SKTexture!
    internal var stateNormalTexture:SKTexture!
    internal var stateSelectedTexture:SKTexture!
    
    // TEXT Labels Customizations

    
    internal var allStatesLabelText:String!
    internal var allStatesFontColor:SKColor!
    internal var allStatesLabelFontSize:CGFloat!
    internal var allStatesLabelFontName:String!

	internal var stateDisabledLabelText:String?
    internal var stateHighlightedLabelText:String?
    internal var stateNormalLabelText:String?
    internal var stateSelectedLabelText:String?

    internal var stateDisabledFontColor:SKColor!
    internal var stateHighlightedFontColor:SKColor!
    internal var stateNormalFontColor:SKColor!
    internal var stateSelectedFontColor:SKColor!


    // Labels Direct Access - Change properties directly from SKLabelNode
    internal let stateDisabledLabel:SKLabelNode
    internal let stateHighlightedLabel:SKLabelNode
    internal let stateNormalLabel:SKLabelNode
    internal let stateSelectedLabel:SKLabelNode



## Help Wanted

TWControls is really simple implementation. I made while learning Swift. If you can improve, please do it.

Your help will be greatly appreciated. Please star, fork and submit pull requests.

You can help by using TWControls in your projects and discovering its shortcomings.


## In Progress

Here are some things that I still want to implement:

* Support for audio effects


## License

See LICENSE for more information
