//
//  RoundedOutlineButtonStyle.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-14.
//

import Foundation
import SwiftUI

struct RoundedOutlineButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(height: 44)
      .background(RoundedRectangle(cornerRadius: 8)
        .stroke(Color.buttonSecondaryBorder, lineWidth: 1.0)
      )
      .background(RoundedRectangle(cornerRadius: 8)
        .fill(Color.white)
        .foregroundColor(Color.buttonSecondaryFG))
        .contentShape(Rectangle())
      .font(Font.semiBoldInter(size: 16.0))
      .foregroundColor(.buttonSecondaryFG)
  }
}
