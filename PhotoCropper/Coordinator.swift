//
//  Coordinator.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-15.
//

import Foundation

enum Screen {
  case imageCropper
  case imageProcessing( ImageProcessingViewModel )
}

class Coordinator: ObservableObject {
  @Published var rootScreen: Screen = .imageCropper
}
