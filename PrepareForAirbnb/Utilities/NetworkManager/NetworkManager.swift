//
//  NetworkManager.swift
//  PrepareForAirbnb
//
//  Created by Jie Huang on 2023/10/10.
//

import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    static let baseURL = "https://seanallen-course-backend.herokuapp.com/swiftui-fundamentals/"
    private let appetizerURL = baseURL + "appetizers"
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getAppetizer() async throws -> [Appetizer] {
        guard let url = URL(string: appetizerURL) else {
            throw APError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(AppetizerResponse.self, from: data).request
        } catch {
            throw APError.invalidData
        }
    }
    
    func downloadImage(urlString: String) async throws -> UIImage? {
        let cachedKey = NSString(string: urlString)
        if let image = cache.object(forKey: cachedKey) {
            return image
        }
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
}



