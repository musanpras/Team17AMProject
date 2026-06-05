//
//  SplashScreen.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 03/06/26.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var scale = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack{
            Image("backgroundImage")
                .resizable()
                .padding(.top, 10)
                .ignoresSafeArea()
            
            Image("AppLogo")
                .resizable()
                .frame(width: 300, height: 200)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.scale = 1.0
                        self.opacity = 1.0
                    }
                }
        }
        
    }
}

#Preview {
    SplashScreenView()
}
