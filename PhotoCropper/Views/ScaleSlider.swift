//
//  ScaleSlider.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-14.
//

import Foundation
import SwiftUI

// partially from ChatGPT
struct ScaleSlider: View {
  
  @Binding var value: CGFloat
  var range: ClosedRange<CGFloat> = 0...1
  var knobSize: CGSize = CGSize(width: 16, height: 16)
  var sliderHeight: CGFloat = 8.0
  
  var body: some View {
    GeometryReader { proxy in
      
      let width = proxy.size.width
      let height = proxy.size.height
      ZStack(alignment: .leading) {
        Rectangle()
          .foregroundColor(Color.progressBackground)
          .frame(width: width, height: sliderHeight)
          .clipShape(Capsule())
        
        Rectangle()
          .foregroundColor(Color.progressBar)
          .frame(width: sliderWidth(from: width), height: sliderHeight)
          .clipShape(Capsule())
        
        Knob(value: $value)
          .frame( height: height)
          .position(x: self.knobPosition(from: width), y: knobSize.height / 2)
        
          .contentShape(Rectangle())
          .gesture(DragGesture().onChanged { value in
            self.onSliderDrag(value.location.x, width)
          })
      }
    }
  }
  
  
  struct Knob: View {
    
    @Binding var value: CGFloat
    
    var body: some View {
      VStack(spacing: 4.0) {
        let percent = Int(value * 100)
        Text("\(percent) %")
          .foregroundColor(Color.buttonSecondaryFG)
          .font(Font.semiBoldInter(size: 8.0))
          .padding(7)
          .background(
            RoundedRectangle(cornerRadius: 10)
              .fill(.white)
              .shadow(color: Color.dropShadow.opacity(0.3), radius: 4, x: 0, y: 2)
          )
        Circle()
          .fill(Color.white)
          .overlay(
            Circle()
              .stroke(Color.buttonPrimaryBG, lineWidth: 1)
          )
          .frame(width: 16, height: 16)
      }
    }
  }
  
  private func sliderWidth(from totalWidth: CGFloat) -> CGFloat {
    let ratio = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
    return totalWidth * ratio
  }
  
  private func knobPosition(from totalWidth: CGFloat) -> CGFloat {
    let ratio = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
    let availableWidth = totalWidth - knobSize.width
    return availableWidth * ratio + knobSize.width / 2.0
  }
  
  private func onSliderDrag(_ x: CGFloat, _ totalWidth: CGFloat) {
    let ratio = min(max((x - knobSize.width / 2.0) / (totalWidth - knobSize.width), 0.0), 1.0)
    let newValue = range.lowerBound + Double(ratio) * (range.upperBound - range.lowerBound)
    value = newValue
  }
  
}
