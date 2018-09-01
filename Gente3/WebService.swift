//
//  WebService.swift
//  Gente
//
//  Created by IKSong on 7/24/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import Foundation

enum BackEnd {
    case user
    case post
    
    func urlString() -> String {
        switch self {
        case .user :    return "https://jsonplaceholder.typicode.com/users"
        case .post :    return "https://jsonplaceholder.typicode.com/posts?userId="
        }
    }
}

struct Resource<A: Codable> {
    let url: URL
}

extension Resource {
    init(withURL url: URL) {
        self.url = url
    }
}

enum Result<T> {
    case success(T)
    case failure(String)
}

class WebService {
    let decoder = JSONDecoder()
    func load<A>(resource: Resource<A>, completion: @escaping (Result<A>) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            guard let data = data else {
                completion(.failure("Invalid data response"))
                return
            }
            
            if let parsed = try? self.decoder.decode(A.self, from: data) {
                completion(.success(parsed))
            }
            
        }.resume()
    }
}
