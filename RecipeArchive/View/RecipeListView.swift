//
//  RecipeListView.swift
//  RecipeArchive
//
//  Created by Akshat Khare on 11/4/24.
//

import SwiftUI

/// A view displaying a list of recipes with a filterable option based on cuisines.
struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel()

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    List(viewModel.filteredRecipes) { recipe in
                        RecipeListCellView(recipe: recipe)
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                viewModel.selectedRecipe = recipe
                                viewModel.isShowingDetail = true
                            }
                    }
                    .navigationTitle("🧑‍🍳 Recipes")
                    .listStyle(.plain)
                    .disabled(viewModel.isShowingDetail)
                    .refreshable {
                        await viewModel.loadRecipes()
                    }
                    .toolbar {
                        // Menu as a toolbar item, positioned at the top right
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                // Option to select each cuisine from the dropdown
                                ForEach(viewModel.cuisines, id: \.self) { cuisine in
                                    Button(action: {
                                        viewModel.selectedCuisine = cuisine
                                        viewModel.filterRecipes() // Update the recipes based on selected cuisine
                                    }) {
                                        Text(cuisine)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(viewModel.selectedCuisine)
                                        .foregroundColor(.primary)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.gray)
                                }
                                .padding(.horizontal, 5)
                            }
                        }
                    }
                }
            }
            .task {
                await viewModel.loadRecipes()
            }
            .blur(radius: viewModel.isShowingDetail ? 20 : 0)

            if viewModel.isShowingDetail {
                RecipeDetailView(viewModel: viewModel, recipe: viewModel.selectedRecipe!,
                                 isShowingDetail: $viewModel.isShowingDetail)
            }

            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if viewModel.recipes.isEmpty {
                EmptyStateView(message: "No recipes available.\nPull to refresh.")
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.error?.userMessage ?? "An unknown error occurred")
        }
        .onChange(of: viewModel.selectedCuisine) { _ in
            viewModel.filterRecipes()
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
