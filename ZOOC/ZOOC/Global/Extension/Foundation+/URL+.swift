//
//  URL+.swift
//  ZOOC
//
//  Created by 류희재 on 12/8/23.
//

import Foundation

extension URL {
    func fetchData(completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: self) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            completion(data)
        }.resume()
    }
}
