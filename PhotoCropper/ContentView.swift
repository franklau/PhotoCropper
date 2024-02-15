//
//  ContentView.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-14.
//

import SwiftUI

struct ContentView: View {
  
  @State private var scale: CGFloat = 1
  @State private var rotationAngle: Angle = Angle(degrees: 0)
  @State var image = UIImage(named: "image")!
  @State var savedImage = UIImage(named: "image")!
  let screenWidth = UIScreen.main.bounds.width
  
  var horizontalPadding = 24.0

  @State private var offset: CGPoint = .zero
  
    var body: some View {
      
      let scaleBinding = Binding(
        get: { self.scale - 1 },
        set: { self.scale = $0 + 1 }
      )
      
      VStack(spacing: 0) {
        HStack {
          Text("Edit headshot")
            .font(Font.semiBoldInter(size: 18))
          Spacer()
          Button(action: {
            print("close tapped")
          }) {
            Image("close")
          }
        }
        .frame(height: 68)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, horizontalPadding)
        .background()
        
        let size = CGSize(width: screenWidth, height: screenWidth)
        let padding = 24.0
        
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: screenWidth, height: screenWidth)
          .clipped()
          .scaleEffect(scale)
          .rotationEffect(rotationAngle)
          .frame(width: screenWidth, height: screenWidth)
          .clipped()
          .overlay {
            Rectangle()
              .fill(Color.black.opacity(0.6))
              .mask(HoleShapeMask(in: CGRect(origin: .zero, size: size), inset: padding).fill(style: FillStyle(eoFill: true)))
          }
        HStack {
          let vOffset = 8
          Image("minus")
            .offset(.init(width: 0, height: vOffset))
          ScaleSlider(value: scaleBinding)
            .frame(height: 42)
            .padding(.top, 14)
          Image("plus")
            .offset(.init(width: 0, height: vOffset))
        }
        .padding(.horizontal, horizontalPadding)
        
        Button(action: {
          let degrees = rotationAngle.degrees
          let newDegrees = degrees + 90
          rotationAngle = Angle(degrees: newDegrees == 360 ? 0 : newDegrees)
        }) {
          HStack(spacing: 6.0) {
            Image("refresh-ccw-01")
              .resizable()
              .frame(width: 20, height: 20)
            Text("Rotate")
              .foregroundColor(Color.buttonTertiearyFG)
              .font(Font.semiBoldInter(size: 14.0))
          }
          .padding(.top, 14)
        }
        
        Spacer()
        Image(uiImage: savedImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 200)
        
        VStack(spacing: 10) {
          Button(action: {
            let transformedImage = image.transformImage(scale: scale, rotationAngle: rotationAngle.radians)
            let aspectFillSize = CGSize(width: screenWidth, height: screenWidth)
            let aspectFilledImage = transformedImage?.aspectFilledImage(imageViewSize: aspectFillSize)
            let radius = (screenWidth - 2 * horizontalPadding) / 2.0
            let croppedImage = aspectFilledImage?.cropImageToCircularRegion(circleRadius: radius)
            savedImage = croppedImage!
          }) {
            Text("Upload Headshot")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(RoundedBlueButtonStyle())
          Button(action: {
            print("upload")
          }) {
            Text("Cancel")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(RoundedOutlineButtonStyle())
          
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.bottom, 24)
      }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView()
    }
}
