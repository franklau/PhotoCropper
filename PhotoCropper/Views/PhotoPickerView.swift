//
//  ImagePickerView.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-16.
//

import SwiftUI
import Photos

// partially from chat gpt
struct PhotoPickerView: View {
  
  @State private var showPicker: Bool  = false
  @State private var photos: [PHAsset] = []
  @EnvironmentObject var coordinator: Coordinator
  
  
  var body: some View {
    ScrollView {
      LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: .infinity), spacing: 0)], spacing: 0) {
        Image(uiImage: UIImage(named:"camera")!)
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          .contentShape(Rectangle())
          .onTapGesture {
            showPicker = true
          }
        ForEach(photos.indices, id: \.self) { index in
          let asset = photos[index]
          
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
    .fullScreenCover(isPresented: $showPicker) {
      CameraPicker { image in
        coordinator.rootScreen = .imageCropper(image)
        // image your image
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

// mostly from chatGPT
struct AsyncImage: View {
  let asset: PHAsset
  
  @State private var image: UIImage?
  
  var body: some View {
    if let image = image {
      // https://stackoverflow.com/questions/64420313/how-to-make-a-lazyvgrid-of-square-images
      Color.clear
        .aspectRatio(1, contentMode: .fill)
        .overlay( Image(uiImage: image)
          .resizable()
          .scaledToFill()
        )
        .clipped()
        .contentShape(Rectangle()) // fixes the wrong image being tapped
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
    
    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options) { result, _ in
        image = result
      }
  }
}

struct PhotoGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoPickerView()
    }
}
