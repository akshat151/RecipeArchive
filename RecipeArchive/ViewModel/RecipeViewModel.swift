//
//  RecipeViewModel.swift
//  RecipeArchive
//
//  Created by Akshat Khare on 11/4/24.
//

import Foundation
import SwiftUI

/// ViewModel to manage recipes, handling network operations, filtering, and navigation states.
@MainActor
class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe] = []
    @Published var isLoading = false
    @Published var error: NetworkErrorManager?
    @Published var showError = false
    @Published var selectedRecipe: Recipe?
    @Published var isShowingDetail = false
    @Published var showURLAlert = false
    @Published var alertMessage = ""
    @Published var selectedCuisine: String = "All"
    @Published var cuisines: [String] = ["All"]
    
    private let networkUtility: NetworkUtilityProtocol
    
    init(networkUtility: NetworkUtilityProtocol = NetworkUtility()) {
        self.networkUtility = networkUtility
        Task { await loadRecipes() }
    }
    
    func loadRecipes() async {
        isLoading = true
        error = nil
        
        do {
            recipes = try await networkUtility.fetchRecipes()
            cuisines = Array(Set(recipes.map { $0.cuisine })).sorted()
            cuisines.insert("All", at: 0)
            filterRecipes()
        } catch let error as NetworkErrorManager {
            self.error = error
            self.showError = true
        } catch {
            self.error = .invalidResponse
            self.showError = true
        }
        
        isLoading = false
    }
    
    func filterRecipes() {
        if selectedCuisine == "All" {
            filteredRecipes = recipes
        } else {
            filteredRecipes = recipes.filter { $0.cuisine == selectedCuisine }
        }
    }
    
    func openURL(_ urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else {
            alertMessage = "The URL provided is invalid or unsupported."
            showURLAlert = true
            return
        }
        DispatchQueue.main.async { UIApplication.shared.open(url) }
    }
}
