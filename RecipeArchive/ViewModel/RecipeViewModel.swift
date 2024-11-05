//
//  RecipeViewModel.swift
//  RecipeArchive
//
//  Created by Akshat Khare on 11/4/24.
//

import Foundation
import SwiftUI

/// Marks the class to be used from the main actor, ensuring that updates to the published properties are thread-safe and UI-related changes occur on the main thread.
@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []            // The list of recipes loaded from the network.
    @Published var isLoading = false                 // Tracks loading state of recipe data.
    @Published var error: NetworkErrorManager?       // Holds any network error that occurs.
    @Published var showError = false                 // Controls the visibility of error alerts.
    @Published var selectedRecipe: Recipe?           // Holds the currently selected recipe for detailed view.
    @Published var isShowingDetail = false           // Indicates whether the detail view is being shown.
    @Published var showURLAlert = false              // Controls the display of URL related alerts.
    @Published var alertMessage = ""                 // Message to be displayed in alerts for URL errors.
    
    private let networkUtility: NetworkUtilityProtocol
    
    init(networkUtility: NetworkUtilityProtocol = NetworkUtility()) {
        self.networkUtility = networkUtility
    }
    
    /// Asynchronously loads recipes from the network, updating the UI state accordingly.
    func loadRecipes() async {
        isLoading = true
        error = nil
        
        do {
            recipes = try await networkUtility.fetchRecipes()
        } catch let error as NetworkErrorManager {
            self.error = error
            self.showError = true
        } catch {
            self.error = .invalidResponse
            self.showError = true
        }
        
        isLoading = false
    }
    
    /// Opens a URL and displays an alert if the URL is invalid.
    func openURL(_ urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else {
            alertMessage = "The URL provided is invalid or unsupported."
            showURLAlert = true
            return
        }
        
        DispatchQueue.main.async{ UIApplication.shared.open(url)}
    }
    
}
