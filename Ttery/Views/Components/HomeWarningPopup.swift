//
//  HomeWarningPopup.swift
//  Team17Project
//

import SwiftUI

struct HomeWarningPopup: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ModalDimmedOverlay(onDismiss: onCancel, animated: true) {
            PopUpNotif(onClick: onConfirm, onCancel: onCancel)
        }
    }
}

#Preview {
    HomeWarningPopup(onConfirm: {}, onCancel: {})
}
