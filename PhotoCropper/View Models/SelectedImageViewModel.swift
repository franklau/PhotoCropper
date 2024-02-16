//
//  SelectedImageViewModel.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-16.
//

import Foundation
import SwiftUI

class SelectedImageViewModel: ObservableObject {
  @Published var selectedImage: UIImage?
}
