//
//  UIImage+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 30/08/2019.
//

import UIKit

public extension UIImage {
    static func systemImage(_ name: String, size: CGFloat, weight: SymbolWeight = .medium, scale: SymbolScale = .default, color: UIColor? = nil) -> UIImage? {
        let config = UIImage.SymbolConfiguration(pointSize: size,
                                                 weight: weight,
                                                 scale: scale)
        
        var newImage = UIImage(systemName: name,
                               withConfiguration: config)
        if let color = color {
            newImage = newImage?.pr_color(color)
        }
        return newImage
    }
    
	func pr_compress(quality: CGFloat = 0.8) -> UIImage? {
		guard let data = pr_compress(forDataQuality: quality) else { return nil }
		return UIImage(data: data)
	}

	func pr_compress(forDataQuality: CGFloat = 0.8) -> Data? {
		return self.jpegData(compressionQuality: forDataQuality)
	}

	func pr_crop(to: CGRect) -> UIImage {
		if to.size.width < self.size.width && to.size.height < self.size.height {
			return self
		}
		if let cgImage = self.cgImage?.cropping(to: to) {
			return UIImage(cgImage: cgImage)
		}
		return self
	}
    
    func pr_resize(for targetSize: CGSize, opaque: Bool = false) -> UIImage {
        
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: targetSize.width * scaleFactor,
            height: targetSize.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }

	func pr_scale(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
		let scale = toHeight / self.size.height
		let newWidth = self.size.width * scale
		let drawRect = CGRect(x: 0, y: 0, width: newWidth, height: toHeight)

		UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
		self.draw(in:drawRect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}

	func pr_scale(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
		let scale = toWidth / self.size.width
		let newHeight = self.size.height * scale
		let drawRect = CGRect(x: 0, y: 0, width: toWidth, height: newHeight)

		UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
		self.draw(in: drawRect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
    
    func pr_scaleWithAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
    
    func pr_resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
            case .scaleAspectFit:
                if aspectRatio > 1 {                            // Landscape image
                    width = dimension
                    height = dimension / aspectRatio
                } else {                                        // Portrait image
                    height = dimension
                    width = dimension * aspectRatio
                }
            default:
                fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        // handle scale
        width = width / scale
        height = height / scale
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }

	func pr_color(_ tintColor: UIColor) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
		let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
		let context = UIGraphicsGetCurrentContext()
		context!.translateBy(x: 0, y: self.size.height)
		context!.scaleBy(x: 1.0, y: -1.0)

		/// - Alpha-mask
		context!.setBlendMode(.normal)
		context?.draw(self.cgImage!, in: rect)

		/// - Tint color, preserves alpha values
		context!.setBlendMode(.sourceIn)
		tintColor.setFill()
		context!.fill(rect)

		let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return coloredImage!
	}
}
