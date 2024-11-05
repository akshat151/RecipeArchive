//
//  StandardButtonView.swift
//  RecipeArchive
//
//  Created by Akshat Khare on 11/4/24.
//

import SwiftUI

struct StandardButtonView: ViewModifier {
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}
