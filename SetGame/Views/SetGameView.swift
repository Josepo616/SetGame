//
//  ContentView.swift
//  SetGame
//
//  Created by JoseAlvarez on 7/28/25.
//

import SwiftUI

struct SetGameView: View {
    @Namespace public var dealingNamespace
    @Namespace public var matchingNamespace
    @ObservedObject var viewModel: SetGameViewModel
    var body: some View {
        VStack {
            VStack {
                VStack {
                    cards
                        .animation(
                            .smooth(duration: 0.5),
                            value: viewModel.cards
                        )
                    
                }
            }
            .imageScale(.large)
            .padding()
            HStack {
                Text("\(viewModel.response)")
            }
            HStack{
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
                    }) {
                        Label("test", systemImage: "hourglass.start")
                            .padding(10)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(20)
                    }
                }
                matchedCards
                Spacer()
                Spacer()

            }
        }
    }
    
}

#Preview {
    SetGameView(viewModel: SetGameViewModel())
}
