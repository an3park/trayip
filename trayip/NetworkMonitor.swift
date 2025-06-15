import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    @Published var currentIP = "Loading..."
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        startNetworkMonitoring()
        Task {
            await fetchAddr()
        }
    }
    
    private func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("Network is satisfied")
                Task {
                    await self?.fetchAddr()
                }
            } else {
                print("Network not available")
                Task { @MainActor in
                    self?.currentIP = "No Connection"
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func fetchAddr() async {
        await MainActor.run {
            currentIP = "Loading..."
        }
        
        let externalIP = await fetchExternalIP()
        
        await MainActor.run {
            if externalIP != nil {
                currentIP = externalIP!
            } else {
                currentIP = "No IP"
            }
        }
    }
    
    private func fetchExternalIP() async -> String? {
        guard let url = URL(string: "https://ifconfig.me/ip") else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return String(data: data, encoding: .utf8) ?? nil
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
}
