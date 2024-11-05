//
//  RecipeArchiveApp.swift
//  RecipeArchive
//
//  Created by Akshat Khare on 11/4/24.
//

import SwiftUI
import Kingfisher

@main
struct RecipeArchiveApp: App {
    
    /// Initializes app-specific settings for image caching using Kingfisher.
    init() {
        let cache = ImageCache.default
        
        // Configures the memory cache to hold up to 50 MB of images.
        cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
        
        // Configures the disk cache to use up to 100 MB of disk space for cached images.
        cache.diskStorage.config.sizeLimit = 100 * 1024 * 1024
        
        // Sets the expiration of cached images on disk to 7 days.
        cache.diskStorage.config.expiration = .days(7)
        
        // Sets the default image download timeout to 15 seconds.
        KingfisherManager.shared.downloader.downloadTimeout = 15.0
    }
    
    var body: some Scene {
        WindowGroup {
            RecipeListView()
        }
    }
}
