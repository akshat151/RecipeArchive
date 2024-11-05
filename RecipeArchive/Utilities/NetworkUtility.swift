//
//  NetworkUtility.swift
//  RecipeArchive
//
//  Created by Akshat Khare on 11/4/24.
//

import Foundation

/// Defines the protocol for fetching recipes from a network source.
protocol NetworkUtilityProtocol {
    func fetchRecipes() async throws -> [Recipe]
}

/// Implements network communication to fetch recipe data from the specified URL.
class NetworkUtility: NetworkUtilityProtocol {
    private var baseURL: URL
    
    init(baseURL: URL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!) {
        self.baseURL = baseURL
    }
    
    /// Fetches recipes from the server asynchronously.
    /// Throws errors for invalid responses, data issues, or decoding failures.
    func fetchRecipes() async throws -> [Recipe] {
        let (data, response) = try await URLSession.shared.data(from: baseURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkErrorManager.invalidResponse
        }
        
        let decoder = JSONDecoder()
        
        do {
            let recipeResponse = try decoder.decode(RecipeResponse.self, from: data)
            if recipeResponse.recipes.isEmpty {
                throw NetworkErrorManager.emptyData
            }
            return recipeResponse.recipes
        } catch {
            throw NetworkErrorManager.decodingError
        }
    }
}

