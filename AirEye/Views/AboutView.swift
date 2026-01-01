//
//  AboutView.swift
//  AirEye
//
//  Created by Patato on 1/1/26.
//

import SwiftUI

struct AboutView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("About AirEye")
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .headingStyle()
            
            VStack(alignment: .leading, spacing: 16) {
                Text("AirEye estimates air quality from images using advanced CNN models, inspired by cutting-edge research.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                Button(action: {
                    if let url = URL(string: "https://github.com/PatatoBit/WebcamScraper") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Label("GitHub Repo", systemImage: "link.circle.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.bordered)
                
                Button(action: {
                    if let url = URL(string: "https://www.kaggle.com/code/patatotato/aireye-full") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Label("Kaggle Notebook", systemImage: "link.circle.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.bordered)
                
                Button(action: {
                    hasCompletedOnboarding = false
                }) {
                    Label("Reset Onboarding", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .fullFrameStyle()
        .padding()
    }
}

#Preview {
    AboutView()
}
