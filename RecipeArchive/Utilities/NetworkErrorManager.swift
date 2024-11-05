//
//  NetworkErrorManager.swift
//  RecipeArchive
//
//  Created by Akshat Khare on 11/4/24.
//

import Foundation

/// Enumerates possible network errors, conforming to the `Error` protocol.
enum NetworkErrorManager: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError
    case emptyData
    
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL configuration"
        case .invalidResponse:
            return "Server error. Please try again later."
        case .invalidData:
            return "Unable to process data from server"
        case .decodingError:
            return "Error processing recipe data"
        case .emptyData:
            return "No recipes available at the moment"
        }
    }
}
