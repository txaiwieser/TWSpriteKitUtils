import SwiftUI
import SpriteKit
struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: buttonNodeDemoView,
                    label: { Text("ButtonNode Demo") }
                )
                
                NavigationLink(
                    destination: switchNodeDemoView,
                    label: { Text("SwitchNode Demo") }
                )
                
                NavigationLink(
                    destination: stackNodeDemoView,
                    label: { Text("StackNode Demo") }
                )
                
                NavigationLink(
                    destination: collectionNodeDemoView,
                    label: { Text("CollectionNode Demo") }
                )
            }
            
            Text("Select an example from the Sidebar")
        }
    }
    
    private var buttonNodeDemoView: some View {
        SpriteView(
            scene: ButtonNodeDemoScene(),
            transition: .crossFade(withDuration: 1)
        )
    }
    
    private var switchNodeDemoView: some View {
        SpriteView(
            scene: SwitchNodeDemoScene(),
            transition: .crossFade(withDuration: 1)
        )
    }
    
    private var stackNodeDemoView: some View {
        SpriteView(
            scene: StackNodeDemoScene(),
            transition: .crossFade(withDuration: 1)
        )
    }
    
    private var collectionNodeDemoView: some View {
        SpriteView(
            scene: CollectionNodeDemoScene(),
            transition: .crossFade(withDuration: 1)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
