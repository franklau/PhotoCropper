//
//  UIColor+Theme.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-14.
//

import Foundation
import SwiftUI

extension Color {
  
  static var progressBackground: Color {
    return Color(hex: 0xEAECF0)
  }
  
  static var brandBlue: Color {
    return Color(hex: 0x326DF7)
  }
  
  static var utilityGray50: Color {
    return Color(hex: 0xF9FAFB)
  }
  
  static var buttonPrimaryBG: Color {
    return Color(hex: 0x155EEF)
  }
  
  static var buttonSecondaryFG: Color {
    return Color(hex: 0x344054)
  }
  
  static var buttonSecondaryBorder: Color {
    return Color(hex: 0xD0D5DD)
  }
  
  static var dropShadow: Color {
    return Color(hex: 0x101828)
  }
  
  static var primary: Color {
    return Color(hex: 0x2979FF)
  }
  
  static var secondary: Color {
    return Color(hex: 0xDFEBFF)
  }
  
  static var utilityBody: Color {
    return Color(hex: 0x27272A)
  }
  
  static var buttonTertiearyFG: Color {
    return Color(hex: 0x475467)
  }
  
  init(hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xff) / 255,
      green: Double((hex >> 08) & 0xff) / 255,
      blue: Double((hex >> 00) & 0xff) / 255,
      opacity: alpha
    )
  }
}

