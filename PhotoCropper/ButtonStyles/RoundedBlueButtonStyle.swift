//
//  RoundedBlueButtonStyle.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-14.
//

import Foundation
import SwiftUI

struct RoundedBlueButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(height: 44)
      .background(RoundedRectangle(cornerRadius: 8)
        .fill(Color.buttonPrimaryBG)
        .foregroundColor(.white))
        .contentShape(Rectangle())
      .font(Font.semiBoldInter(size: 16.0))
      .foregroundColor(.white)
  }
}


