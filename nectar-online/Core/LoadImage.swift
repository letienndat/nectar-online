//
//  LoadImage.swift
//  nectar-online
//
//  Created by Macbook on 02/11/2024.
//

import Foundation
import SDWebImage

func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    SDWebImageManager.shared.loadImage(
        with: url,
        options: .highPriority,
        progress: nil
    ) { image, data, error, cacheType, finished, imageURL in
        if let error = error {
            print("Lỗi khi tải ảnh: \(error.localizedDescription)")
            completion(nil)
        } else {
            completion(image) // Trả về UIImage
        }
    }
}
