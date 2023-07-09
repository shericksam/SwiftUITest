//
//  ErrorView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 08/07/23.
//

import SwiftUI

struct ErrorView: View {
    var errorMessage: String?
    var retryAction: (() -> Void)? = nil

    var body: some View {
        VStack {
            Text(errorMessage ?? "error-message")
                .font(.title)
                .foregroundColor(.red)
                .padding()
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text("try-again")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
