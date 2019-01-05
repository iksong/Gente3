//
//  WebService.swift
//  Gente
//
//  Created by IKSong on 7/24/17.
//  Copyright © 2017 IKSong. All rights reserved.
//

import Foundation

enum HttpMethod<Body> {
    case get
    case post(Body)
}

extension HttpMethod {
    var method: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

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
    var urlRequest: URLRequest
    let stubDataAssetName: String
    let parse: (Data) -> A?
}

extension Resource {
    init(get urlRequest: URLRequest, stubDataAssetName: String = "") {
        self.urlRequest = urlRequest
        self.stubDataAssetName = stubDataAssetName
        self.parse = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
    }
    
    init<Body: Encodable>(url: URL, method: HttpMethod<Body>, stubDataAssetName: String = "") {
        self.stubDataAssetName = stubDataAssetName
        
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.method
        
        switch method {
        case .get: ()
        case .post(let body):
            self.urlRequest.httpBody = try! JSONEncoder().encode(body)
        }
        self.parse = { data in
            try? JSONDecoder().decode(A.self, from: data)
        }
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
