//
//  SpeakBubble.swift
//  Team17Project
//
//  Created by Muhammad Sandy Prastyo on 03/06/26.
//

import SwiftUI

struct SpeakBubble: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 48)
            SpeechBubble()
                .fill(.white)
                .shadow(color: .black, radius: 0, x: 0, y: 4)
                .overlay(
                    SpeechBubble()
                        .stroke(.black, lineWidth: 1)
                )
                .overlay(
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("good job on doing")
                                .font(.system(size: 12))
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                                .frame(width: 18)
                        }
                        HStack {
                            Text("assignments today")
                                .font(.system(size: 13, weight: .bold))
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                                .frame(width: 18)
                        }
                    }
                        .foregroundStyle(.black)
                        .padding(0)
                )
                .frame(width: 134, height: 54)
            Spacer()
        }
    }
}

private struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius: CGFloat = 8
        let tailWidth: CGFloat = 18
        let tailHeight: CGFloat = 10
        
        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - radius - tailWidth, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - tailWidth, y: rect.minY + radius),
            control: CGPoint(x: rect.maxX - tailWidth, y: rect.minY)
        )
        path.addLine(to: CGPoint(x: rect.maxX - tailWidth, y: rect.midY - tailHeight))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY - tailHeight - 10))
        path.addLine(to: CGPoint(x: rect.maxX - tailWidth, y: rect.midY + 2))
        path.addLine(to: CGPoint(x: rect.maxX - tailWidth, y: rect.maxY - radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - tailWidth - radius, y: rect.maxY),
            control: CGPoint(x: rect.maxX - tailWidth, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY - radius),
            control: CGPoint(x: rect.minX, y: rect.maxY)
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + radius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        
        return path
    }
}

#Preview {
    SpeakBubble()
}
