//
//  ImageUploader.swift
//  PhotoCropper
//
//  Created by Frank Lau on 2024-02-15.
//

import Foundation
import UIKit


enum ImageUploaderError: Error {
  case couldNotCreateImage(String?, URLResponse?)
}

protocol ImageUploaderDelegate: AnyObject {
  func imageUploader(progress: Float)
}

class ImageUploader: NSObject {
  
  static let shared = ImageUploader()
  
  weak var delegate: ImageUploaderDelegate?
  
  static let baseURLString = "https://www.roomvu.com/api/v1"
  
  private lazy var session: URLSession = {
    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.timeoutIntervalForRequest = 120
    sessionConfig.timeoutIntervalForResource = 120
    return URLSession(configuration: sessionConfig, delegate: self, delegateQueue: OperationQueue.main)
  }()
  
  // https://stackoverflow.com/questions/29623187/upload-image-with-multipart-form-data-ios-in-swift
  
  func uploadImage(image: UIImage, completion: ((_ image: UIImage?, _ error: Error?) -> Void)? ) {
    // Convert UIImage to Data
    guard let imageData = image.pngData() else { return }
    
    // API Endpoint URL
    let apiUrl = URL(string: Self.baseURLString + "/agent-dashboard/user-image/enhance")!
    
    // Create a URLRequest
    var request = URLRequest(url: apiUrl)
    request.httpMethod = "POST"
    
    // Add the token header (replace "YOUR_TOKEN" with the actual token)
    request.setValue("AHpzZnQjHfPaRd9NMCq8", forHTTPHeaderField: "token")
    
    // Create a boundary for the multipart/form-data
    let boundary = UUID().uuidString
    let contentType = "multipart/form-data; boundary=\(boundary)"
    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    
    // Create the body of the request
    var body = Data()
    
    // Append the image part to the request body
    body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n".data(using: .utf8)!)
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    
    request.httpBody = body
    
    // Create a URLSession task
    let task =  session.dataTask(with: request) { data, response, error in
      if let error = error {
        completion?(nil, error)
        return
      }
      
      // Handle the response
      guard let data = data else {
        completion?(nil, ImageUploaderError.couldNotCreateImage(nil, response))
        return
      }
      
      guard let image = UIImage(data: data) else {
        completion?(nil, ImageUploaderError.couldNotCreateImage(String(data: data, encoding: .utf8), response))
        return
      }
      DispatchQueue.main.async {
        completion?(image, nil)
      }
    }
    task.resume()
  }
 
}

extension ImageUploader: URLSessionTaskDelegate {
  func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    let uploadProgress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
    delegate?.imageUploader(progress: uploadProgress)
  }
}

