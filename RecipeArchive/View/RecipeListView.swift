//
//  RecipeListView.swift
//  RecipeArchive
//
//  Created by Akshat Khare on 11/4/24.
//

import SwiftUI

/// A view displaying a list of recipes.
struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel() // ViewModel that manages the data and state for the list of recipes.
    
    var body: some View {
        ZStack {
            NavigationView {
                List(viewModel.recipes) { recipe in
                    RecipeListCellView(recipe: recipe)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            viewModel.selectedRecipe = recipe
                            viewModel.isShowingDetail = true
                        }
                }
                .navigationTitle("🧑‍🍳 Recipes")
                .listStyle(.plain)
                .disabled(viewModel.isShowingDetail)  // Disables interaction with the list when a detail view is shown.
                .refreshable {
                    await viewModel.loadRecipes()  // Refreshes the recipes list.
                }
            }
            .task {
                await viewModel.loadRecipes()
            }
            .blur(radius: viewModel.isShowingDetail ? 20 : 0)
            
            if viewModel.isShowingDetail {
                RecipeDetailView(viewModel: self.viewModel, recipe: viewModel.selectedRecipe!,
                                 isShowingDetail: $viewModel.isShowingDetail)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if viewModel.recipes.isEmpty {
                EmptyStateView(message: "No recipes available.\nPull to refresh.")
            }
        }.alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.error?.userMessage ?? "An unknown error occurred")
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
