//
//  UIImage+Helpers.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-14.
//

import Foundation
import UIKit

extension UIImage {
  
  // from ChatGPT
  func aspectFilledImage(imageViewSize: CGSize) -> UIImage? {
      let imageSize = size
      
      let aspectWidth = imageViewSize.width / imageSize.width
      let aspectHeight = imageViewSize.height / imageSize.height
      let aspectRatio = max(aspectWidth, aspectHeight)
      
      let scaledWidth = imageSize.width * aspectRatio
      let scaledHeight = imageSize.height * aspectRatio
      let offsetX = (imageViewSize.width - scaledWidth) / 2.0
      let offsetY = (imageViewSize.height - scaledHeight) / 2.0
      
      let renderer = UIGraphicsImageRenderer(size: imageViewSize)
      
      let aspectFilledImage = renderer.image { context in
          draw(in: CGRect(x: offsetX, y: offsetY, width: scaledWidth, height: scaledHeight))
      }
      
      return aspectFilledImage
  }
  
  // from ChatGPT
  func transformImage(scale: CGFloat, rotationAngle: CGFloat) -> UIImage? {
      // Create a context to draw the transformed image
      UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
      defer { UIGraphicsEndImageContext() }

      guard let context = UIGraphicsGetCurrentContext() else { return nil }

      // Apply the transformation to the context
      context.translateBy(x: size.width / 2, y: size.height / 2)
      context.scaleBy(x: scale, y: scale)
      context.rotate(by: rotationAngle)
      context.translateBy(x: -size.width / 2, y: -size.height / 2)

      // Draw the transformed image
      draw(in: CGRect(origin: .zero, size: size))

      // Retrieve the transformed image from the context
      guard let transformedImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }

      return transformedImage
  }
  
  // from ChatGPT
  func cropImageToCircularRegion(circleRadius: CGFloat) -> UIImage? {
      let imageSize = size
      let scale = scale
      
      // Calculate the center of the image
      let centerX = imageSize.width / 2
      let centerY = imageSize.height / 2
      
      // Calculate the bounding box for the circular region
      let circleRect = CGRect(
          x: centerX - circleRadius,
          y: centerY - circleRadius,
          width: circleRadius * 2,
          height: circleRadius * 2
      )
      
      // Create a circular mask
      UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
      defer { UIGraphicsEndImageContext() }
      
      guard let context = UIGraphicsGetCurrentContext() else { return nil }
      context.addEllipse(in: circleRect)
      context.clip()
      
      // Draw the image within the circular mask
      draw(in: CGRect(origin: .zero, size: imageSize))
      
      // Retrieve the cropped image
      guard let croppedImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
      
      return croppedImage
  }
  
  func cropImageTo(sideLength: CGFloat) -> UIImage? {
    guard let cgImage = cgImage else {
      return nil
    }
    
    let widthRatio =   CGFloat(cgImage.width) / CGFloat(size.width)
    let heightRatio = CGFloat(cgImage.height) / CGFloat(size.height)
    
    let width = Int(sideLength * widthRatio)
    let height = Int(sideLength * heightRatio)
    
    let x = cgImage.width / 2 - width / 2
    let y = cgImage.height / 2 - height / 2
    let cropRect = CGRect(x: x, y: y, width: width, height: height)
    
    guard let croppedCGImage = cgImage.cropping(to: cropRect) else {
      return nil
    }
    
    return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
  }
  
}


