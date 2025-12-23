//
//  FindingPatterns.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct FindingPatterns: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("The Filter Lens")
                .labelStyle()
            
            
            Text("Finding Patterns Among Images")
                .headingStyle()
                .frame(maxWidth: .infinity, alignment: .topLeading)

            Text("Imagine giving your AI special glasses to see specific things.")
            
            Text("A filter is a math trick that highlights one type of pattern.")
            
            Spacer()
        }
        .fullFrameStyle()
        .padding()
    }
}

#Preview {
    FindingPatterns()
}
