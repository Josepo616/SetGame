//
//  ContentView.swift
//  SetGame
//
//  Created by JoseAlvarez on 7/28/25.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: SetGameViewModel
    @Namespace public var dealingNamespace
    @Namespace public var matchingNamespace
    @State public var zoomedCardIDs: Set<UUID> = []
    @State public var shakingCardIDs: Set<UUID> = []

    var body: some View {
        VStack {
            VStack {
                VStack {
                    cards.animation(
                        .smooth(duration: 0.5),
                        value: viewModel.cardsOnScreen
                    )
                }
            }
            .imageScale(.large)
            .padding()
            
            HStack {
                Text("\(viewModel.response)")
            }
            
            HStack {
                remainingCards
                    .padding(.leading)
                Spacer()
                VStack {
                    Button(action: {
                        viewModel.startNewGame()
                    }) {
                        Label("Start new game", systemImage: "hourglass.start")
                            .padding(10)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(20)
                    }
                    Button(action: {
                        viewModel.shuffleVisibleCards()
                    }) {
                        Label(
                            "Shuffle cards",
                            systemImage:
                                "point.bottomleft.forward.to.arrow.triangle.scurvepath.fill"
                        )
                        .padding(10)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(20)
                    }
                }
                matchedCards
                Spacer()
            }
        }
    }
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
