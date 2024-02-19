//
//  ContentView.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-14.
//

import SwiftUI
import UIKit

struct ImageCropperView: View {
  
  // https://stackoverflow.com/questions/61305331/crop-image-according-to-rectangle-in-swiftui
  
  let screenHeight = UIScreen.main.bounds.height
  let defaultScreenHeight = 1200.0
  @ObservedObject var viewModel: ImageCropperViewModel
//  let image: UIImage
  
  @State private var currentPosition: CGPoint = .zero
  @State private var previousPosition: CGPoint = .zero
  
  @State private var scale: CGFloat = 1
  @State private var rotationAngle: Angle = Angle(degrees: 0)
  
  @State var isOn: Bool = false
  
  @EnvironmentObject var coordinator: Coordinator
  @EnvironmentObject var profileImageViewModel: ProfileImageViewModel

  let screenWidth = UIScreen.main.bounds.width
  
  let horizontalPadding = 24.0
  let circlePadding = 24.0

  @State private var offset: CGPoint = .zero
  
    var body: some View {
      
      VStack(spacing: 0) {
        HStack {
          Text("Edit headshot")
            .font(Font.semiBoldInter(size: 18))
          Spacer()
          Button(action: {
            coordinator.rootScreen = .profile
          }) {
            Image("close")
              .padding([.leading, .top, .bottom], 10.0 )
          }
        }
        .frame(height: 68 * screenHeight / defaultScreenHeight)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, horizontalPadding)
        .background()
        
        makeTransformableImage()
          .contentShape(Rectangle()) // fixes issue with tapping close button not working with specific images
        makeSlider()
        makeRotateButton()
        makeRemoveToggle()
        Spacer()
        makeButtonStack()
        
      }
    }
  
  private func makeTransformableImage() -> some View {
    let size = CGSize(width: screenWidth, height: screenWidth)
    return Image(uiImage: isOn ? viewModel.getNoBackgroundImage() : viewModel.originalImage)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .scaleEffect(scale)
      .rotationEffect(rotationAngle)
      .frame(width: screenWidth, height: screenWidth)
      .offset(x: currentPosition.x, y: currentPosition.y)
      .overlay {
        Rectangle()
          .fill(Color.black.opacity(0.6))
          .mask(HoleShapeMask(in: CGRect(origin: .zero, size: size), inset: circlePadding).fill(style: FillStyle(eoFill: true)))
      }
      .clipped()
      .gesture(DragGesture()
        .onChanged({ value in
          currentPosition = CGPoint(x: value.translation.width + previousPosition.x,
                                    y: value.translation.height + previousPosition.y)
        })
          .onEnded { value in
            currentPosition = CGPoint(x: value.translation.width + previousPosition.x,
                                     y: value.translation.height + previousPosition.y)
            previousPosition = currentPosition
          }
      )
    
  }
  
  private func makeSlider() -> some View {
    HStack {
      
      let scaleBinding = Binding(
        get: { self.scale - 1 },
        set: { self.scale = $0 + 1 }
      ) // slider is from 0 to 1, so conversion is needed since scale is from 1 to 2
      
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
  }
  
  private func makeRotateButton() -> some View {
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
      .padding(.top, 14 * screenHeight / defaultScreenHeight)
    }
  }
  
  private func makeRemoveToggle() -> some View {
    HStack {
      Text("Remove background")
        .font(Font.mediumInter(size: 14.0))
        .foregroundColor(Color.buttonSecondaryFG)
        
      Toggle("", isOn: $isOn)
                 .toggleStyle(SwitchToggleStyle(tint: Color.brandBlue))
    }
    .padding(.horizontal, horizontalPadding)
    .padding(.top, 22 * screenHeight / defaultScreenHeight)
  }
  
  private func makeButtonStack() -> some View {
    VStack(spacing: 10) {
      Button(action: {
        
        let imageToTransform = isOn ? viewModel.getNoBackgroundImage() : viewModel.originalImage
        let transformedImage = imageToTransform.transformImage(scale: scale,
                                                                      rotationAngle: rotationAngle.radians,
                                                                      position: currentPosition)
        let aspectFillSize = CGSize(width: screenWidth, height: screenWidth)
        let aspectFilledImage = transformedImage?.aspectFilledImage(imageViewSize: aspectFillSize)
        let sideLength = (screenWidth - 2 * circlePadding)
        if let croppedImage = aspectFilledImage?.cropImageTo(sideLength: sideLength) {
          let imageProcessorViewModel = ImageProcessingViewModel(image: croppedImage)
          profileImageViewModel.image = croppedImage
          coordinator.rootScreen = .imageProcessingProgress(imageProcessorViewModel)
        }
      }) {
        Text("Upload Headshot")
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(RoundedBlueButtonStyle())
      Button(action: {
        coordinator.rootScreen = .profile
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      let viewModel = ImageCropperViewModel(originalImage: UIImage(named: "image")!)
      ImageCropperView(viewModel: viewModel)
    }
}
