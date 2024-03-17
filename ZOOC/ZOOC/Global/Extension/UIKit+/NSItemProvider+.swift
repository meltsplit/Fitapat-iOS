//
//  NSItemProvider+.swift
//  ZOOC
//
//  Created by 류희재 on 2023/08/23.
//

import UIKit
import UniformTypeIdentifiers

extension NSItemProvider {
    enum NSItemProviderLoadImageError: Error {
        case unexpectedImageType
    }
 
    func loadImage(completion: @escaping (UIImage?, Error?) -> Void) {
        if canLoadObject(ofClass: UIImage.self) {
            loadObject(ofClass: UIImage.self) { image, error in
                guard let resultImage = image as? UIImage else {
                    completion(nil, error)
                    return
                }
                completion(resultImage,error)
            }
        } else if hasItemConformingToTypeIdentifier(UTType.webP.identifier) {
            loadDataRepresentation(forTypeIdentifier: UTType.webP.identifier) { data, error in
                guard let data, let webImage = UIImage(data: data) else {
                    completion(nil, error)
                    return
                }
                completion(webImage, error)
            }
        } else {
            completion(nil, NSItemProviderLoadImageError.unexpectedImageType)
        }
    }
}
