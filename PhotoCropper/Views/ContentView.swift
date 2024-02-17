//
//  ContentView.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-15.
//

import SwiftUI

struct ContentView: View {
  @StateObject var coordinator = Coordinator()
  @StateObject var profileImageViewModel = ProfileImageViewModel()
  
  init() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(cgColor: Color.utilityGray50.cgColor!)
    
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
  }
  
    var body: some View {
      switch coordinator.rootScreen {
      case .profile:
        ProfileView()
          .environmentObject(profileImageViewModel)
          .environmentObject(coordinator)
      case .imageCropper(let image):
        ImageCropperView(image: image)
          .environmentObject(profileImageViewModel)
          .environmentObject(coordinator)
      case .imageProcessingProgress(let imageProcessingViewModel):
        ImageProcessingProgressView(viewModel: imageProcessingViewModel)
          .environmentObject(coordinator)
      }
    }
}

#Preview {
    ContentView()
}
