//
//  PlayView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/28.

import SwiftUI

struct PlayView: View {
    @State private var playerHand: Hand = .rock
    @State private var enemyHand: Hand = .rock
    @State private var resultMessage: String = ""
    @State private var isRandomlyDisplaying: Bool = true
    @State private var timer: Timer?
    @State private var textColor: Color = Color.black
    @State private var consecutiveWins: Int = 0
    @State private var lastResult: String = ""
    @State private var isPlaying: Bool = false // 追加
    
    var body: some View {
        VStack {
            Text("じゃんけんアプリ")
                .font(.largeTitle)
                .padding()
            
            VStack {
                if isRandomlyDisplaying {
                    Image(enemyHand.imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.bottom, 20) // スペースを確保
                } else {
                    Image(enemyHand.imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                    Text("相手の手: \(enemyHand.description)")
                        .padding(.top, 20) // スペースを確保
                }
            }
            
            HStack(spacing: 40) {
                Button(action: { self.play(hand: .rock) }) {
                    Image(Hand.rock.imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                Button(action: { self.play(hand: .scissors) }) {
                    Image(Hand.scissors.imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                Button(action: { self.play(hand: .paper) }) {
                    Image(Hand.paper.imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
            }
            .disabled(isPlaying) // ボタンを無効化
            
            Text(resultMessage)
                .font(.headline)
                .foregroundColor(textColor)
                .padding()
            
            Text("連勝: \(consecutiveWins)")
                .font(.headline)
                .padding()
            
            Button("再挑戦", action: {
                self.stopRandomTimer() // タイマーを停止
                self.resultMessage = ""
                self.enemyHand = .rock // 相手の手を初期化
                self.isRandomlyDisplaying = true // ランダム表示を再開
                self.startRandomTimer() // タイマーを再開
                self.isPlaying = true // 試合中フラグを設定
            })
            .disabled(isPlaying) // ボタンを無効化
            
            Spacer()
        }
        .onAppear {
            self.startRandomTimer()
        }
        .onDisappear {
            self.stopRandomTimer()
        }
    }
    
    private func play(hand: Hand) {
        self.stopRandomTimer() // ボタンが押されたらタイマーを停止
        playerHand = hand
        isRandomlyDisplaying = false // ボタンが押されたらランダム表示を停止
        determineResult() // 結果の判定
        isPlaying = false // 試合終了後、試合中フラグを解除
    }
    
    private func startRandomTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.enemyHand = Hand.allCases.randomElement()!
        }
    }
    
    private func stopRandomTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func determineResult() {
        switch (playerHand, enemyHand) {
        case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
            resultMessage = "勝ち！"
            textColor = Color.red
            consecutiveWins += 1 // 連勝回数をインクリメント
            lastResult = "win" // 前回の結果を保持
        case (.rock, .paper), (.scissors, .rock), (.paper, .scissors):
            resultMessage = "負け！"
            textColor = Color.blue
            consecutiveWins = 0 // 連勝回数をリセット
            lastResult = "lose" // 前回の結果を保持
        default:
            resultMessage = "引き分け！"
            textColor = Color.black
            // 引き分けの場合は連勝回数をリセットしない
            lastResult = "draw" // 前回の結果を保持
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
    
    var imageName: String {
        switch self {
        case .rock: return "rock_image"
        case .scissors: return "scissors_image"
        case .paper: return "paper_image"
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
