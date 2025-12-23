//
//  Welcome.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct Welcome: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("AirEye")
                .font(.largeTitle)
                .bold()
                .fontDesign(.rounded)
            
            Text("Explore how machine learning teaches computers to see air quality")
        }
        .padding()
    }
}

#Preview {
    Welcome()
}
