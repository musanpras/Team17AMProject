//
//  ActivityCell.swift
//  Team17Project
//
//  Created by Imelda Damayanti on 26/05/26.
//

import SwiftUI

struct ActivityCell: View {
    var body: some View {
        VStack(spacing: 4){
            Text("🚿")
                .font(.system(size: 50))
            
            Text("shower")
                .font(.system(size: 20, weight: .bold))
            
//            if the
            HStack{
                Image(systemName: "bolt.circle")
                Text("15")
            }
        }
        .frame(maxWidth: 100, minHeight: 140)
        .border(Color.black, width: 0.5)
    }
}

#Preview {
    ActivityCell()
}
