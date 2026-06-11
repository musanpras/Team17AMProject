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
                        image: "activettery",
                        unactiveimage: "unactivettery",
                        title: "ttery",
                        tab: .home
                    )

                    tabButton(
                        image: "storefront",
                        unactiveimage: "",
                        title: "market",
                        tab: .market
                    )
                }
            }
        }
        .frame(width: 200, height: 50)
    }

    private func tabButton(
        image: String,
        unactiveimage: String,
        title: String,
        tab: Tab
    ) -> some View {

        Button {
            Haptic.medium()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 6) {

                if unactiveimage != "" {
                    if selectedTab == .home {
                        Image(image)
                            .resizable()
                            .frame(width: 20, height: 20)
                    } else {
                        Image(unactiveimage)
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                } else {
                    Image(systemName: image)
                        .font(.system(size: 20))
                }

                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundColor(
                selectedTab == tab
                ? Color.green
                : Color.black
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
