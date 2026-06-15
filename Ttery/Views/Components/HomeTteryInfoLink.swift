//
//  HomeTteryInfoLink.swift
//  Team17Project
//

import SwiftUI

struct HomeTteryInfoLink: View {
    var body: some View {
        NavigationLink {
            StoryView()
                .onAppear {
                    Haptic.light()
                }
        } label: {
            Text("who’s ttery?")
                .font(.system(size: 14))
                .underline()
                .foregroundStyle(.black)
        }
        .foregroundColor(.primary)
    }
}

#Preview {
    NavigationStack {
        HomeTteryInfoLink()
    }
}
