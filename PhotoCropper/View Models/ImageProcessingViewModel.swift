//
//  ImageProcessingViewModel.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-15.
//

import Foundation
import SwiftUI

class ImageProcessingViewModel: ObservableObject {

  @Published var progress: CGFloat = 0
  var progressPercentage: String {
    return "\(lround(progress * 100))% processed..."
  }
  
  var image: UIImage
  
  init(image: UIImage) {
    self.image = image
  }
  
  func performUpload() {
    let uploader = ImageUploader.shared
    uploader.delegate = self
    uploader.uploadImage(image: image) { image, error in
      self.progress = 1 // TODO: handle error
    }
  }
}

extension ImageProcessingViewModel: ImageUploaderDelegate {
  func imageUploader(progress: Float) {
    self.progress = CGFloat(progress) * 0.6
  }
}
