//
//  MarketWarningPopup.swift
//  Team17Project
//

import SwiftUI

struct MarketWarningPopup: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ModalDimmedOverlay(onDismiss: onCancel, animated: true) {
            PopUpNotif(onClick: onConfirm, onCancel: onCancel)
        }
    }
}

#Preview {
    MarketWarningPopup(onConfirm: {}, onCancel: {})
}
