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
    
    func dataAssetName() -> String {
        switch self {
        case .user:     return "UsersData"
        case .post:     return ""
        }
    }
}

struct Resource<A: Codable> {
    let urlRequest: URLRequest
    let stubDataAssetName: String
}

extension Resource {
    init(withURLRequest urlRequest: URLRequest, stubDataAssetName: String = "") {
        self.urlRequest = urlRequest
        self.stubDataAssetName = stubDataAssetName
    }
}

enum Result<T> {
    case success(T)
    case failure(String)
}

class WebService {
    let decoder = JSONDecoder()
    
    func load<A>(resource: Resource<A>, completion: @escaping (Result<A>) -> ()) {
        URLSession.shared.dataTask(with: resource.urlRequest) { (data, _, _) in
            guard let data = data else {
                completion(.failure("Invalid data response"))
                return
            }
            
            if let parsed = try? self.decoder.decode(A.self, from: data) {
                completion(.success(parsed))
            }
        }.resume()
    }
    
    func loadFromDataAssets<A>(resource: Resource<A>, completion: @escaping (Result<A>) -> ()) {
        guard let data = DataAssets.loadDataAsset(name: resource.stubDataAssetName) else {
            completion(.failure("Invalid data asset name"))
            return
        }
        
        if let parsed = try? self.decoder.decode(A.self, from: data) {
            completion(.success(parsed))
        }
    }
}
