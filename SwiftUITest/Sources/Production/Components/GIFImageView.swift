//
//  GIFImageView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import SwiftUI
import UIKit

struct GIFImageView: UIViewRepresentable {
    let gifURL: URL

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.startAnimating()
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: gifURL) else { return }

            DispatchQueue.main.async {
                uiView.image = UIImage.gif(data: imageData)
            }
        }
    }
}
extension UIImage {
    class func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let image = UIImage(cgImage: cgImage)
                images.append(image)
            }
        }

        return UIImage.animatedImage(with: images, duration: 0.0)
    }
}
