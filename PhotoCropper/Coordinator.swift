//
//  Coordinator.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-15.
//

import Foundation
import UIKit

enum Screen {
  case profile
  case imageCropper(UIImage)
  case imageProcessingProgress( ImageProcessingViewModel )
}

class Coordinator: ObservableObject {
  @Published var rootScreen: Screen = .profile
}
