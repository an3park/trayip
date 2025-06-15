import SwiftUI

@main
struct MyApp: App {
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        MenuBarExtra(networkMonitor.currentIP) {
            Button("Refresh IP") {
                Task {
                    await networkMonitor.fetchAddr()
                }
            }
            
            Divider()
            
            Button("Quit", role: .destructive) {
                exit(0)
            }
            .keyboardShortcut("q")
        }
    }
}
