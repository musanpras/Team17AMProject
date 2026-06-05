//
//  CodedGridBackground.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 03/06/26.
//

import SwiftUI

struct CodedGridBackground: View {
    var body: some View {
        HomeGridPaperBackground()
    }
}

private struct HomeGridPaperBackground: View {
    var body: some View {
        Canvas { context, size in
            let smallSpacing: CGFloat = 16
            let largeSpacing: CGFloat = 80
            
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
    CodedGridBackground()
}
