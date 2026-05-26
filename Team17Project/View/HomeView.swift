//
//  HomeView.swift
//  Team17Project
//
//  Created by ROONEY on 26/05/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack{
            Text("Home Content")
            
            
            ZStack{
                // shadow rectangle - slightly below
                    RoundedRectangle(cornerRadius: 13)
                        .fill(Color.black)
                        .frame(width: 348, height: 100)
                        .offset(x: 0, y: 5)
                
                //main rectangle
                RoundedRectangle(cornerRadius: 13)
                       .fill(Color(UIColor.systemBackground))
                       .frame(width:348, height: 100)
                       .overlay(
                               RoundedRectangle(cornerRadius: 13)
                                   .stroke(Color.gray, lineWidth: 1)
                           )
            }
            
        }
    }
}

#Preview {
    HomeView()
}
