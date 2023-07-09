//
//  NetworkStatusView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 08/07/23.
//

import Foundation
import SwiftUI

struct NetworkStatusView: View {
    @State private var isConnected = NetworkChecker.isConnected()

    var body: some View {
        HStack {
            Spacer()
            if !isConnected {
                Text("offline-mode")
            }
            Spacer()
        }
        .foregroundColor(.white)
        .background(Color.gray)
        .onAppear {
            isConnected = NetworkChecker.isConnected()
        }
        .onReceive(NotificationCenter.default.publisher(for: .reachabilityChanged)) { _ in
            isConnected = NetworkChecker.isConnected()
        }
    }
}

extension Notification.Name {
    static let reachabilityChanged = Notification.Name("reachabilityChanged")
}
