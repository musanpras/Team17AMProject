//
//  StoryView.swift
//  Team17Project
//
//  Created by Imelda Damayanti on 03/06/26.


import SwiftUI

struct StoryView: View {
    var body: some View {
        ZStack {
            GridPaperBackground()
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button {
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

                AccordionListView()
                
            }
        }
    }
}

private struct GridPaperBackground: View {
    var body: some View {
        Canvas { context, size in
            let smallSpacing: CGFloat = 16
            let largeSpacing: CGFloat = 64
            
            for x in stride(from: 0, through: size.width, by: smallSpacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(Color.blue.opacity(0.08)), lineWidth: 1)
            }
            
            for y in stride(from: 0, through: size.height, by: smallSpacing) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(Color.blue.opacity(0.08)), lineWidth: 1)
            }
            
            for x in stride(from: 0, through: size.width, by: largeSpacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(Color.red.opacity(0.08)), lineWidth: 1)
            }
            
            for y in stride(from: 0, through: size.height, by: largeSpacing) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(Color.red.opacity(0.08)), lineWidth: 1)
            }
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

#Preview {
    StoryView()
}
