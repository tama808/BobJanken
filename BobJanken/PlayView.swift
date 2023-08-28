//
//  PlayView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/28.
//

import SwiftUI

struct PlayView: View {
    @State private var playerHand: Hand = .rock
    @State private var enemyHand: Hand = .rock
    @State private var resultMessage: String = ""
    
    var body: some View {
        VStack {
            Text("じゃんけんアプリ")
                .font(.largeTitle)
                .padding()
            
            Text("相手の手: \(enemyHand.description)")
            
            HStack {
                Button(action: { self.play(hand: .rock) }) {
                    Text("グー")
                }
                Button(action: { self.play(hand: .scissors) }) {
                    Text("チョキ")
                }
                Button(action: { self.play(hand: .paper) }) {
                    Text("パー")
                }
            }
            
            Text(resultMessage)
                .font(.headline)
                .padding()
            
            Spacer()
        }
    }
    
    private func play(hand: Hand) {
        playerHand = hand
        enemyHand = Hand.allCases.randomElement()!
        
        switch (playerHand, enemyHand) {
        case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
            resultMessage = "勝ち！"
        case (.rock, .paper), (.scissors, .rock), (.paper, .scissors):
            resultMessage = "負け！"
        default:
            resultMessage = "引き分け！"
        }
    }
}

enum Hand: CaseIterable {
    case rock, scissors, paper
    
    var iconName: String {
        switch self {
        case .rock: return "hand.raised.fill"
        case .scissors: return "scissors"
        case .paper: return "pencil.and.outline"
        }
    }
    
    var description: String {
        switch self {
        case .rock: return "グー"
        case .scissors: return "チョキ"
        case .paper: return "パー"
        }
    }
}
