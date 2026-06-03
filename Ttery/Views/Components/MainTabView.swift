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

            ZStack(alignment: .bottom) {

                // Main content
                TabView(selection: $selectedTab) {

                    HomeView()
                        .tag(Tab.home)

                    MarketView()
                        .tag(Tab.market)
                }
                .toolbarVisibility(.hidden, for: .tabBar)
                // Custom tab bar
                CustomTabView(selectedTab: $selectedTab)
                    .padding(.horizontal, 24)
                
            }
        }
}



#Preview {
    MainTabView()
}
