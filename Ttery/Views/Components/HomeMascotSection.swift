//
//  HomeMascotSection.swift
//  Team17Project
//

import SwiftUI

struct HomeMascotSection: View {
    let mascotEnergy: String

    var body: some View {
        ZStack(alignment: .leading) {
            Image(mascotEnergy)
                .resizable()
                .scaledToFit()
                .frame(width: 170, height: 310)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 330)
    }
}

#Preview {
    HomeMascotSection(mascotEnergy: "idle")
}
