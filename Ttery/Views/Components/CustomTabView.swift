//
//  CustomTabView.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 26/05/26.
//

import SwiftUI

struct CustomTabView: View {

    @Binding var selectedTab: Tab

    private let tabWidth: CGFloat = 88

    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.black.opacity(0.8))
                .frame(height: 68)

            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.white)
                    .frame(height: 68)

                HStack {
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color.gray.opacity(0.12))
                        .frame(width: tabWidth, height: 60)
                        .offset(x: selectionOffset)
                }
                .padding(.horizontal, 6)

                HStack {
                    tabButton(
                        image: "activettery",
                        unactiveimage: "unactivettery",
                        title: "ttery",
                        tab: .home
                    )
//                    .padding(.leading, 8)

                    tabButton(
                        image: "storefront",
                        unactiveimage: "",
                        title: "market",
                        tab: .market
                    )

                    tabButton(
                        image: "gearshape.fill",
                        unactiveimage: "",
                        title: "settings",
                        tab: .settings
                    )
                }
            }
        }
        .frame(width: tabWidth * 3 + 12, height: 50)
    }

    private var selectionOffset: CGFloat {
        let index = CGFloat(selectedTab.index)
        return (index - 1) * tabWidth
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
                if tab == .home {
                    Image(selectedTab == .home ? image : unactiveimage)
                        .resizable()
                        .frame(width: 20, height: 20)
                } else {
                    Image(systemName: image)
                        .font(.system(size: tab == .settings ? 18 : 20))
                }

                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(
                selectedTab == tab
                ? Color.green
                : Color.black
            )
            .frame(maxWidth: .infinity)
            .frame(height: 80)
        }
        .padding(.leading, tab == .home ? 8 : 0)
        .padding(.trailing, tab == .settings ? 8 : 0)
    }
}

#Preview {
    CustomTabView(selectedTab: .constant(.home))
        .background(Color(.systemGray6))
}
