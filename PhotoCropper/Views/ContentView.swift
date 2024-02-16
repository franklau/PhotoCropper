//
//  ContentView.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-15.
//

import SwiftUI

struct ContentView: View {
  @StateObject var coordinator = Coordinator()
    var body: some View {
      switch coordinator.rootScreen {
      case .imageCropper:
        ImageCropperView()
          .environmentObject(coordinator)
      case .imageProcessing(let imageProcessingViewModel):
        ImageProcessingView(viewModel: imageProcessingViewModel)
      }
    }
}

#Preview {
    ContentView()
}
