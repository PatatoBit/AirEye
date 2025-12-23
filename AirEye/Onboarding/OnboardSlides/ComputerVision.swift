//
//  ComputerVision.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct ComputerVision: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pixels = Numbers")
                .labelStyle()

            
            Text("How computers see images")
                .headingStyle()
                .frame(maxWidth: .infinity, alignment: .topLeading)

            Text("Unlike humans, all computers see are just pixel values.")
            
            Spacer()
        }
        .fullFrameStyle()
        .padding()
    }
}

#Preview {
    ComputerVision()
}
