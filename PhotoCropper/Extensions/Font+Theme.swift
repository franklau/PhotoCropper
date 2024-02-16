//
//  Font+Theme.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-14.
//

import Foundation
import SwiftUI

extension Font {
  static func semiBoldInter(size: CGFloat) -> Font {
    return Font.custom("Inter-SemiBold", size: size)
  }
  
  static func mediumInter(size: CGFloat) -> Font {
    return Font.custom("Inter-Medium", size: size)
  }
  
  static func boldInter(size: CGFloat) -> Font {
    return Font.custom("Inter-Bold", size: size)
  }
  
  static func lightInter(size: CGFloat) -> Font {
    return Font.custom("Inter-Light", size: size)
  }
}
