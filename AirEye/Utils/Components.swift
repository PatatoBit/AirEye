//
//  Components.swift
//  AirEye
//
//  Created by Patato on 22/12/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
        }
        .background(Color.black)
        .cornerRadius(16)
    }
}
