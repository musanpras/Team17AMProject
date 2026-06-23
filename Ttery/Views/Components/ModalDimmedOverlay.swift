//
//  ModalDimmedOverlay.swift
//  Team17Project
//

import SwiftUI

struct ModalDimmedOverlay<Content: View>: View {
    let onDismiss: () -> Void
    var animated: Bool = false
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            Color.black.opacity(0.18)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            content()
                .frame(maxWidth: 660)
                .padding(.horizontal, 18)
        }
        .modifier(AnimatedOverlayModifier(enabled: animated))
        .zIndex(10)
    }
}

private struct AnimatedOverlayModifier: ViewModifier {
    let enabled: Bool

    func body(content: Content) -> some View {
        if enabled {
            content
                .transition(.opacity.combined(with: .scale(scale: 0.96)))
        } else {
            content
        }
    }
}
