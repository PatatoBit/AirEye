//
//  FindingPatterns.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct FindingPatterns: View {
    var body: some View {
        ScrollView { // Added ScrollView for better layout on small screens
            VStack(alignment: .leading) {
                
                Text("The Filter Lens")
                    .labelStyle()
                
                
                VStack(alignment: .leading, spacing: 20) {
                    
                Text("Finding Patterns Among Images")
                    .headingStyle()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                    Text("How does the model make sense of those numbers? It uses filters—mathematical lenses that scan the image to highlight meaningful features. ")
                        .font(.body)
                    
                    // MARK: - Interactive Component
                    // Replace "sample_image" with the name of an image in your Assets
                    FilterLens(imageName: "example")
                        .padding(.vertical)
                    
                    Text("These filters strip away noise to focus on what matters, like the sharp edges of a building or the soft texture of smog.")
                        .font(.body)
                    
                    Text("By sliding the lens, you reveal the 'edges'—the hidden structure the computer uses to understand the world.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    FindingPatterns()
}
