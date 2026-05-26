//
//  EnergyBar.swift
//  Team17Project
//
//  Created by Imelda Damayanti on 26/05/26.
//

import SwiftUI

struct EnergyBar: View {
    var body: some View {
        GeometryReader{ geo in
            ZStack (alignment: .leading){
                Capsule()
                    .fill(Color.black)
                    .frame(width: 350)
                    .shadow(radius: 10, x:0, y:10)
             
                Capsule()
                    .fill(Color.green)
                    .frame(width: geo.size.width * 0.6)
                
                Text("10")
                    
            }
        }
        .frame(height: 40)
        .overlay(alignment: .leading){
            Circle()
                .fill(Color.white)
                .overlay(
                    Image(systemName: "bolt.fill")
                )
                .font(.system(size: 32, weight: .bold))
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 2)
                )
                .frame(width: 56, height: 56)
                
                       
        }
        
        .padding(.leading, 4)
       
    }
    
}

#Preview {
    EnergyBar()
}
