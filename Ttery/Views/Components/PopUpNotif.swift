//
//  PopUpNotif.swift
//  Ttery
//
//  Created by Muhammad Sandy Prastyo on 04/06/26.
//

import SwiftUI

struct PopUpNotif: View {
    @Environment(\.dismiss) private var dismiss
    
    var onClick: (() -> Void)?
    var onCancel: (() -> Void)?
    
    init(
        onClick: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        self.onClick = onClick
        self.onCancel = onCancel
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.white)
                    .shadow(color: .black, radius: 0, x: 0, y: 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(.black, lineWidth: 2)
                    )
                
                            HStack {
                                circleButton(
                                    systemImage: "xmark",
                                    foregroundColor: .black,
                                    backgroundColor: .white,
                                    action: close
                                )
                            }
                            .padding(.horizontal, -16)
                            .offset(x: -150, y: -18)
                
                VStack {
                    Text("heads up!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                    
                    Text("you don’t have enough energy to do this task right now.")
                        .font(.system(size: 16, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    
                    Text("ttery recommends doing energizing tasks before proceeding, but it’s up to you.")
                        .font(.system(size: 16, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                    
                    Button {
                        onClick?()
                    } label: {
                        Text("go ahead anyway?")
                            .font(.system(size: 14))
                            .underline()
                            .foregroundStyle(.black)
                            .padding(.vertical, 16)
                    }
                    .foregroundColor(.primary)
                }
                
            }
            .frame(width: 310, height: 293)
        }
    }
    
    private func circleButton(
        systemImage: String,
        foregroundColor: Color,
        backgroundColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(foregroundColor)
                .frame(width: 58, height: 58)
                .background(Circle().fill(backgroundColor)
                    .shadow(color: .black, radius: 0, x: 0, y: 7))
                .overlay(Circle().stroke(.white.opacity(0.85), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
    
    private func close() {
        onCancel?()
        dismiss()
    }
    
}



#Preview {
    PopUpNotif()
}
