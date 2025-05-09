import SwiftUI

@main
struct AutoTextIOSApp: App {
    @StateObject private var shortcutManager = ShortcutManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(shortcutManager)
        }
    }
} 