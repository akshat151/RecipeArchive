//
//  RecipeListCellView.swift
//  RecipeArchive
//
//  Created by Akshat Khare on 11/4/24.
//
import SwiftUI
import Kingfisher

/// A view representing a single cell in a recipe list.
struct RecipeListCellView: View {
    
    let recipe: Recipe
    
    var body: some View {
        HStack {
            if let photoUrlSmall = recipe.photoUrlSmall {
                KFImage(URL(string: photoUrlSmall))
                    .placeholder {
                        Image("food-placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 90)
                            .cornerRadius(8)
                    }
                    .fade(duration: 0.3)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 90)
                    .cornerRadius(8)
            }
            
            // Displays recipe name and cuisine in a vertical stack.
            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.title2)
                    .fontWeight(.medium)
                
                Text("Cuisine - " + recipe.cuisine)
                    .foregroundColor(.secondary)
                    .fontWeight(.semibold)
            }
            .padding(.leading)
        }
    }
}

struct RecipeListCell_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListCellView(recipe: MockData.sampleAppetizer)
    }
}

