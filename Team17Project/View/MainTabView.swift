//
//  TabView.swift
//  Team17Project
//
//  Created by ROONEY on 26/05/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
            }
            
            Tab("Market", systemImage: "storefront") {
                Text("Market content")
            }
        }
        
    }
}

#Preview {
    MainTabView()
}
