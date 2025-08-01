//
//  SetGameApp.swift
//  SetGame
//
//  Created by JoseAlvarez on 7/28/25.
//

import SwiftUI

@main
struct SetGameApp: App {
    var body: some Scene {
        WindowGroup {
            SetGameView(viewModel: SetGameViewModel())
        }
    }
}
