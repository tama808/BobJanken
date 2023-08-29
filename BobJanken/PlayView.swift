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
    @State private var isPlaying: Bool = false
    @State private var buttonText: String = ""
    @State private var buttonColor: Color = .blue
    
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
                        .padding(.bottom, 20)
                } else {
                    Image(enemyHand.imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                    Text("相手の手: \(enemyHand.description)")
                        .padding(.top, 20)
                }
                VerticalRainbowRectangleMeter(consecutiveWins: consecutiveWins)
            }
            
            HStack(spacing: 40) {
                Button(action: { self.play(hand: .rock) }) {
                    Image(Hand.rock.imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                .disabled(isPlaying)
                
                Button(action: { self.play(hand: .scissors) }) {
                    Image(Hand.scissors.imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                .disabled(isPlaying)
                
                Button(action: { self.play(hand: .paper) }) {
                    Image(Hand.paper.imageName)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                .disabled(isPlaying)
            }
            
            Text(resultMessage)
                .font(.headline)
                .foregroundColor(textColor)
                .padding()
            
            // 初回のプレイ結果時にのみ表示
            if isPlaying {
                Button(buttonText, action: {
                    self.stopRandomTimer()
                    self.resultMessage = ""
                    self.enemyHand = .rock
                    self.isRandomlyDisplaying = true
                    self.startRandomTimer()
                    self.isPlaying = true
                })
                .padding() // ボタンのパディング
                .background(buttonColor) // ボタンの背景色
                .foregroundColor(.white) // ボタンのテキスト色
                .cornerRadius(10) // 角丸
                .font(.headline) // ボタンのフォント
            }
            
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
        if isPlaying {
            return // 試合中なら何もしない
        }
        
        self.stopRandomTimer()
        playerHand = hand
        isRandomlyDisplaying = false
        determineResult()
        isPlaying = true // 試合中フラグを設定
        
        if resultMessage.isEmpty {
            isPlaying = false // 試合が終了したら試合中フラグを解除
        }
    }
    
    
    private func startRandomTimer() {
        isPlaying = true // タイマーが始まったら試合中フラグを設定
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.enemyHand = Hand.allCases.randomElement()!
            // タイマーが終了したら再挑戦ボタンを有効化
            self.isPlaying = false
        }
    }
    
    private func stopRandomTimer() {
        timer?.invalidate()
        timer = nil
        // タイマーが停止したら再挑戦ボタンを有効化
        isPlaying = false
    }
    
    private func determineResult() {
        switch (playerHand, enemyHand) {
        case (.rock, .scissors), (.scissors, .paper), (.paper, .rock):
            resultMessage = "勝ち！"
            textColor = Color.red
            buttonText = "連勝に挑戦"
            buttonColor = Color.red
            consecutiveWins += 1 // 連勝回数をインクリメント
            lastResult = "win" // 前回の結果を保持
        case (.rock, .paper), (.scissors, .rock), (.paper, .scissors):
            resultMessage = "負け！"
            textColor = Color.blue
            buttonText = "再挑戦だー"
            buttonColor = Color.blue
            consecutiveWins = 0 // 連勝回数をリセット
            lastResult = "lose" // 前回の結果を保持
        default:
            resultMessage = "引き分け！"
            textColor = Color.black
            buttonText = "あいこはもう一回"
            buttonColor = Color.green
            // 引き分けの場合は連勝回数をリセットしない
            lastResult = "draw" // 前回の結果を保持
            
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
    
    struct VerticalRainbowRectangleMeter: View {
        var consecutiveWins: Int
        
        var body: some View {
            VStack {
                HStack(spacing: 5) {
                    ForEach(0..<min((consecutiveWins - 1) / 20 + 1, 3), id: \.self) { index in
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: rainbowColors), startPoint: .bottom, endPoint: .top)) // 上から下へのグラデーション
                            .frame(width: 15, height: barHeight(for: index))
                    }
                }
                Text("連勝: \(min(consecutiveWins, 60))")
                    .font(.headline)
            }
        }
        
        private var rainbowColors: [Color] {
            return [
                Color.red,
                Color.orange,
                Color.yellow,
                Color.green,
                Color.blue,
                Color.purple
            ]
        }
        
        private func barHeight(for index: Int) -> CGFloat {
            let maxBarHeight: CGFloat = 60 // 最大高さを60に制限（3本分）
            let height = CGFloat(min(consecutiveWins - index * 20, 20)) * 3 // バーの高さを計算
            return min(height, maxBarHeight)
        }
    }
    
    
}
