//
//  TabView.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 26/05/26.
//

import SwiftUI

struct MainTabView: View {

    @State private var selectedTab: Tab = .home

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(Tab.home)

                    MarketView(selectedTab: $selectedTab)
                        .tag(Tab.market)

                    SettingsView()
                        .tag(Tab.settings)
                }

                CustomTabView(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
}

#Preview {
    MainTabView()
}
