//
//  StoryView.swift
//  Team17Project
//
//  Created by Imelda Damayanti on 03/06/26.


import SwiftUI

struct StoryView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            CodedGridBackground()
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.black)
                            .frame(width: 54, height: 54)
                            .background(Circle().fill(.white).shadow(color: .black, radius: 0, x: 0, y: 4))
                            .overlay(Circle().stroke(.black, lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    
                    Spacer()
                    Text("info")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Color.clear
                        .frame(width: 54, height: 54)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 5)
                
                AccordionListView()
                
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    HomeView()
}

#Preview {
    StoryView()
}
