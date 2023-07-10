//
//  GIFImageView.swift
//  SwiftUITest
//
//  Created by Erick Samuel Guerrero Arreola on 09/07/23.
//

import SwiftUI
import UIKit

struct GIFImageViewRep: UIViewRepresentable {
    let gifURL: URL

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.startAnimating()
        imageView.image = nil
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

struct GIFImageView: View {
    @State private var imageData: Data?

    let gifURL: URL
    let defaultImage: UIImage? = UIImage(named: "error404")

    var body: some View {
        Group {
            if let imageData = imageData,
               let gifImage = UIImage.gif(data: imageData) {
                Image(uiImage: gifImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if let defaultImage = defaultImage {
                Image(uiImage: defaultImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Color.gray
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: gifURL) else {
                return
            }

            DispatchQueue.main.async {
                self.imageData = imageData
            }
        }
    }
}
