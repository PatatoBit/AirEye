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
                
                    Text("Imagine giving your AI special glasses to see specific things.")
                        .font(.body)
                    
                    // MARK: - Interactive Component
                    // Replace "sample_image" with the name of an image in your Assets
                    FilterLens(imageName: "example")
                        .padding(.vertical)
                    
                    Text("A filter is a math trick that highlights one type of pattern.")
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
