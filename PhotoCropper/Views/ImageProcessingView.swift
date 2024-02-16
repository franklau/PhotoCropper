//
//  ImageProcessingProgressView.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-15.
//

import Foundation
import SwiftUI

struct ImageProcessingView: View {
  @StateObject var viewModel: ImageProcessingViewModel
  let loadingImageSideLength = 200.0
  @State var hasStartedUpload = false
  
  var body: some View {
    VStack(spacing: 0) {
      Text("Take a sip")
        .foregroundColor(Color.buttonSecondaryFG)
        .font(Font.boldInter(size: 18))
        .padding(.bottom, 30)
      Image("coffee-cup-loading")
        .resizable()
        .frame(width: loadingImageSideLength, height: loadingImageSideLength)
        .cornerRadius(loadingImageSideLength / 2)
        .padding(.bottom, 30)
      VStack(alignment: .trailing, spacing: 10) {
        ProgressView(value: viewModel.progress)
        Text(viewModel.progressPercentage)
          .font(Font.mediumInter(size: 14))
          .foregroundColor(Color.buttonSecondaryFG)
      }
      .padding(.bottom, 30)
      Text("We are currently processing your image. Background remover may take few miniutes.")
        .multilineTextAlignment(.center)
        .foregroundColor(Color.buttonSecondaryFG)
        .font(Font.mediumInter(size: 14))
      
    }
    .offset(x: 0, y: -100)
    .padding(.horizontal, 24)
    .onAppear(perform: { 
      if !hasStartedUpload {
        viewModel.performUpload()
        hasStartedUpload = true
      }
    })
  }
  
}


struct ImageProcessingView_Previews: PreviewProvider {
    static var previews: some View {
      ImageProcessingView(viewModel: ImageProcessingViewModel(image: UIImage(imageLiteralResourceName: "image")))
    }
}
