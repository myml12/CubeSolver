import SwiftUI

struct ContentView: View {
    
    @State private var colorString: String = ""
    @State private var tabselection: Int = 0
    
    var body: some View {
        
        TabView(selection: $tabselection) {
            
            MainView(colorString: $colorString, tabselection: $tabselection)
                .tabItem {
                    Image(systemName: "scanner")
                    Text("Scan")
                }
                .tag(0)
            
            CubeView(colorString: $colorString, tabselection: $tabselection)
                .tabItem {
                    Image(systemName: "square")
                    Text("Figure")
                }
                .tag(2)
            
            SendView(colorString: $colorString, tabselection: $tabselection)
                .tabItem {
                    Image(systemName: "arrowtriangle.right.fill")
                    Text("Send")
                }
                .tag(1)
            
        }
    }
}
