//
//  NetworkStatusView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 08/07/23.
//

import Foundation
import SwiftUI

struct NetworkStatusView: View {
    var body: some View {
        if !NetworkChecker.isConnected() {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("offline-mode")
                    Spacer()
                }
                .foregroundColor(.white)
                .background(Color.gray)
            }
        }
    }
}
