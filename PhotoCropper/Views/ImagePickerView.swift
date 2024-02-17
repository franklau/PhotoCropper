//
//  ImagePickerView.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-16.
//

import SwiftUI
import Photos

// from chat gpt
struct ImagePickerView: View {
  @State private var photos: [PHAsset] = []
  @EnvironmentObject var coordinator: Coordinator
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: .infinity), spacing: 0)], spacing: 0) {
        ForEach(photos, id: \.self) { asset in
          AsyncImage(asset: asset)
            .onTapGesture {
              let options = PHImageRequestOptions()
              options.isSynchronous = false
              options.deliveryMode = .highQualityFormat
              PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { result, _ in
                DispatchQueue.main.async {
                  if let result = result {                  
                    coordinator.rootScreen = .imageCropper(result)
                  }
                }
              }
              print("asset \(asset)")
            }
        }
      }
    }
    .onAppear {
      PHPhotoLibrary.requestAuthorization { (status) in
        switch status {
        case .authorized:
          print("Good to proceed")
          fetchPhotos()
        case .denied, .restricted:
          print("Not allowed")
        case .notDetermined:
          print("Not determined yet")
        case .limited:
          print("limited")
        default:
          print("unknown")
        }
      }
     
    }
    .navigationTitle("Photo Gallery")
  }
  
  private func fetchPhotos() {
    let fetchOptions = PHFetchOptions()
    fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
    
    var assets: [PHAsset] = []
    fetchResult.enumerateObjects { asset, _, _ in
      assets.append(asset)
    }
    
    photos = assets
  }
}


struct AsyncImage: View {
  let asset: PHAsset
  
  @State private var image: UIImage?
  
  // sizing into squares from https://talk.objc.io/episodes/S01E309-building-a-photo-grid-square-grid-cells
  var body: some View {
    if let image = image {
      Image(uiImage: image)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .clipped()
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
          loadImage()
        }
    } else {
      ProgressView()
        .onAppear {
          loadImage()
        }
    }
  }
  
  private func loadImage() {
    let options = PHImageRequestOptions()
    options.isSynchronous = false
    options.deliveryMode = .highQualityFormat
    
    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { result, _ in
        image = result
      }
  }
}

struct PhotoGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView()
    }
}
