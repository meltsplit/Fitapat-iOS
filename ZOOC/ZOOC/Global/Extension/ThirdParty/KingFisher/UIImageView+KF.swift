//
//  UIImageView+.swift
//  ZOOC
//
//  Created by 장석우 on 2023/01/12.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func kfSetImage(
        url : String?,
        defaultImage: UIImage? = .default
    ) {
        
        guard let url = url else {
            self.image = defaultImage
            return
        }
        
        if let url = URL(string: url) {
            kf.indicatorType = .activity
            kf.setImage(with: url,
                        placeholder: nil,
                        options: [.transition(.fade(1.0))], progressBlock: nil)
        }
    }
    
    func kfSetImage(with url : String?,
                    placeholder: UIImage? = .default,
                    completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        guard let url = url,
              let url = URL(string: url) else {
            self.image = placeholder
            return
        }
        
        Task { @MainActor in
            
            let processor = DownsamplingImageProcessor(size: self.frame.size)
            kf.setImage(with: url,
                        placeholder: placeholder,
                        options: [.processor(processor),
                                  .scaleFactor(UIScreen.main.scale),
                                  .cacheOriginalImage],
            completionHandler: completionHandler)
        }
        
        
    }
}
