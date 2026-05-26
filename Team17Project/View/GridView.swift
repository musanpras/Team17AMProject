//
//  GridView.swift
//  Team17Project
//
//  Created by Imelda Damayanti on 26/05/26.
//

import SwiftUI

struct GridView: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 4)
       
    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
                    ActivityCell()
                    ActivityCell()
                    ActivityCell()
                    ActivityCell()
                    ActivityCell()
                    ActivityCell()
                    ActivityCell()
                    ActivityCell()
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding()
            }
    
}

#Preview {
    GridView()
}
