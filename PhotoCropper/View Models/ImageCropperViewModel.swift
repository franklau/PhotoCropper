//
//  ImageCropperViewModel.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-18.
//

import Foundation
import SwiftUI

class ImageCropperViewModel: ObservableObject {
  var originalImage: UIImage
  var noBackgroundImage: UIImage?
  
  init(originalImage: UIImage, noBackgroundImage: UIImage? = nil) {
    self.originalImage = originalImage
    self.noBackgroundImage = noBackgroundImage
  }
  
  func getNoBackgroundImage() -> UIImage {
    if noBackgroundImage != nil { return noBackgroundImage! }
    return originalImage.removeBackground(returnResult: .finalImage)!
  }
}
