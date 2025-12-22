//
//  AirQualityLevelsView.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct AirQualityLevelsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Levels of air quality")
                .font(.title)
                .fontDesign(.rounded)
                .bold()
            
            AirQualityRow()
            AirQualityRow(name: "Moderate", aqiRange: "51-100", photoPath: "Moderate")
            AirQualityRow(name: "Unhealthy for Sensitive groups", aqiRange: "101-200", photoPath: "USG")
            AirQualityRow(name: "Unhealthy", aqiRange: "201-250", photoPath: "Unhealthy")
            AirQualityRow(name: "Very Unhealthy", aqiRange: "251-300", photoPath: "VeryUnhealthy")
            AirQualityRow(name: "Hazardous", aqiRange: "300+", photoPath: "Hazardous")

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct AirQualityRow: View {
    var name: String = "Good"
    var aqiRange: String = "0-50"
    var photoPath: String = "Good"
    
    var body: some View {
        HStack(spacing: 16) {
            Image("\(photoPath)")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("\(name)")
                    .font(.title3)
                    .fontDesign(.rounded)
                    .fontWeight(.medium)
                
                Text("\(aqiRange)")
            }
        }
    }
}

#Preview {
    AirQualityLevelsView()
}
