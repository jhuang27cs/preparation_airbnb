//
//  APError.swift
//  PrepareForAirbnb
//
//  Created by Jie Huang on 2023/10/10.
//

import Foundation

enum APError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case unableToComplete
}
