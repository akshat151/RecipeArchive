//
//  RecipeDetailView.swift
//  RecipeArchive
//
//  Created by Akshat Khare on 11/4/24.
//

import SwiftUI
import Kingfisher

/// A detailed view displaying information about a recipe.
struct RecipeDetailView: View {
    @StateObject var viewModel: RecipeViewModel
    let recipe: Recipe
    @Binding var isShowingDetail: Bool
    
    var body: some View {
        VStack {
            // Displays a large recipe image if available.
            if let photoUrl = recipe.photoUrlLarge {
                KFImage(URL(string: photoUrl)) // Uses Kingfisher to load the image from a URL.
                    .placeholder {
                        ProgressView()
                            .frame(width: 300, height: 225)
                            .background(Color.gray.opacity(0.1))
                    }
                    .fade(duration: 0.3)
                    .cancelOnDisappear(true)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 225)
                    .clipped()
                    .cornerRadius(12)
            }
            
            // Recipe Details
            VStack {
                Text(recipe.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Cuisine - " + recipe.cuisine)
                    .font(.body)
                    .padding()
            }
            
            // Buttons for additional recipe actions.
            VStack(spacing: 16) {
                if let sourceUrl = recipe.sourceUrl {
                    Button(action: {
                        viewModel.openURL(sourceUrl)
                    }) {
                        Text("View Recipe")
                            .frame(maxWidth: .infinity)
                    }
                    .standardButtonView(backgroundColor: .indigo)
                }
                
                if let youtubeUrl = recipe.youtubeUrl {
                    Button(action: {
                        viewModel.openURL(youtubeUrl)
                    }) {
                        Text("Watch Recipe Video")
                            .frame(maxWidth: .infinity)
                    }
                    .standardButtonView(backgroundColor: .red)
                }
            }
            .padding(.horizontal)
        }
        .frame(width: 300, height: 500)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 40)
        .overlay(Button {
            isShowingDetail = false
        } label: {
            DismissButtonView()
        }, alignment: .topTrailing)
        .alert(isPresented: $viewModel.showURLAlert) {
            Alert(
                title: Text("Invalid URL"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(viewModel: RecipeViewModel(), recipe: MockData.sampleAppetizer,
                         isShowingDetail: .constant(true))
    }
}

// Extension to apply standard button styling.
extension View {
    func standardButtonView(backgroundColor: Color) -> some View {
        self.modifier(StandardButtonView(backgroundColor: backgroundColor))
    }
}
