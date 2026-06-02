//
//  CustomTabView.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 26/05/26.
//

import SwiftUI

struct CustomTabView: View {

    @Binding var selectedTab: Tab
    

    var body: some View {

        ZStack(alignment: .bottom) {

            // Bottom dark shadow layer
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.black.opacity(0.8))
                .frame(height: 68)

            // Main tab bar
            ZStack {

                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.white)
                    .frame(height: 68)

                // Selected tab background
                HStack {
                    if selectedTab == .market {
                        Spacer()
                    }

                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color.gray.opacity(0.12))
                        .frame(width: 90, height: 60)

                    if selectedTab == .home {
                        Spacer()
                    }
                }
                .padding(.horizontal, 6)

                // Tabs
                HStack {

                    tabButton(
                        image: "house",
                        title: "Home",
                        tab: .home
                    )

                    tabButton(
                        image: "storefront",
                        title: "Market",
                        tab: .market
                    )
                }
            }
        }
        .frame(width: 190, height: 50)
    }

    private func tabButton(
        image: String,
        title: String,
        tab: Tab
    ) -> some View {

        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selectedTab = tab
            }
        } label: {

            VStack(spacing: 6) {

                Image(systemName: image)
                    .font(.system(size: 20))

                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(
                selectedTab == tab
                ? Color.blue
                : Color.gray
            )
            .frame(maxWidth: .infinity)
            .frame(height: 80)
        }
    }
}

#Preview {
    CustomTabView(selectedTab: .constant(.home))
        .background(Color(.systemGray6))
}
