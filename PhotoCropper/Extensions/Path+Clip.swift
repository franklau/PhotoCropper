//
//  Path+Clip.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-14.
//

import Foundation
import SwiftUI

// https://stackoverflow.com/questions/59656117/swiftui-add-inverted-mask
func HoleShapeMask(in rect: CGRect, inset: CGFloat) -> Path {
    var shape = Rectangle().path(in: rect)
    shape.addPath(Circle().path(in: rect.insetBy(dx: inset, dy: inset)))
    return shape
}

