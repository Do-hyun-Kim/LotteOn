//
//  ImageCacheFetch.swift
//  LotteOn
//
//  Created by Kim dohyun on 2022/04/24.
//

import UIKit


final class ImageCacheFetch {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}

extension UIImageView {
    
    func setCacheImage(_ url: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let `self` = self else { return }
            let chchedKey = NSString(string: url)
            
            if let cacheImage = ImageCacheFetch.shared.object(forKey: chchedKey) {
                DispatchQueue.main.async {
                    self.image = cacheImage
                }
                return
            }
            
            guard let url = URL(string: url) else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    DispatchQueue.main.async {
                        self.image = UIImage()
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        ImageCacheFetch.shared.setObject(image, forKey: chchedKey)
                        self.image = image
                    }
                }
            }.resume()
                
        }
    }
}
