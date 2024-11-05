//
//  RecipeModel.swift
//  RecipeArchive
//
//  Created by Akshat Khare on 11/4/24.
//

import Foundation

/// Represents a recipe, conforming to `Codable` for JSON encoding/decoding and `Identifiable` for use in SwiftUI.
struct Recipe: Codable, Identifiable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let uuid: String
    let sourceUrl: String?
    let youtubeUrl: String?
    
    var id: String { uuid }

    /// Maps JSON keys to appropriate property names.
    enum CodingKeys: String, CodingKey {
        case cuisine, name, uuid
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}

/// Provides sample data for development and testing.
struct MockData {
    static let sampleAppetizer = Recipe(
        cuisine: "Italian",
        name: "Spaghetti Carbonara",
        photoUrlLarge: "https://example.com/images/spaghetti_carbonara_large.jpg",
        photoUrlSmall: "https://example.com/images/spaghetti_carbonara_small.jpg",
        uuid: UUID().uuidString,
        sourceUrl: "https://example.com/recipes/spaghetti-carbonara",
        youtubeUrl: "https://youtube.com/watch?v=dQw4w9WgXcQ"
    )
}
