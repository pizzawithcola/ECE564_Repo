//
//  PlayerView.swift
//  Using SwiftUI
//
//  Created by Ric Telford on 2/12/24.
//

import SwiftUI

class Episode: ObservableObject {
    @Published var title = "Swift Part"
}

struct PlayButton: View {
    @ObservedObject var episode: Episode
    @Binding var isPlaying: Bool
    @Binding var currentPartNumber: Int
    var body: some View {
        Button(isPlaying ? "Pause " + episode.title + "\(currentPartNumber)" : "Play " + episode.title + "\(currentPartNumber)") {
            isPlaying.toggle()
            currentPartNumber += 1
        }
    }
}
struct PlayerView: View {
    @StateObject private var episode = Episode()
    @State private var playState: Bool = false
    @State private var partNumber: Int = 1
    var body: some View {
        VStack {
            Text(episode.title + "\(partNumber)")
                .foregroundStyle(playState ? .primary : .tertiary)
                .font(.largeTitle)
            PlayButton(episode: episode, isPlaying: $playState, currentPartNumber: $partNumber)
                .font(.custom("AmericanTypewriter", size: 30))
        }
    }
}

#Preview {
    PlayerView()
}
