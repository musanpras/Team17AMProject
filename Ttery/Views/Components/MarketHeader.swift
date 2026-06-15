//
//  MarketHeader.swift
//  Team17Project
//

import SwiftUI

struct MarketHeader: View {
    let energyValue: Double
    let energyColor: Color

    var body: some View {
        HStack(alignment: .center) {
            Text("market")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.black)

            Spacer()

            StyledEnergyBar(value: energyValue, energyColor: energyColor, style: .market)
        }
    }
}

#Preview {
    MarketHeader(energyValue: 0.6, energyColor: .green)
        .padding()
}
