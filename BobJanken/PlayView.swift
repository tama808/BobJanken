//
//  PlayView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/28.

import SwiftUI

struct PlayView: View {
    // プロパティ定義
    @State var numberA: Int = Int.random(in: 2...9)
    @State var numberB: Int = 0
    @State var prediction: Int = 0
    @State var result: String = ""
    @State var showNumberB: Bool = false
    @State var score: Int = 0
    @State var gameStatus: GameStatus? = nil
    @State var isGameFinished: Bool = false
    @State var isButtonsEnabled: Bool = true
    @AppStorage("score") private var savedScore = 0
    @State var isRankingViewPresented = false
    var userID: String = "" // ユーザーIDを追加
    enum GameStatus {
        case win
        case lose
    }
    let highestScoreKey = "highestScore"
    var body: some View {
        VStack {
            // 結果表示
            HStack {
                // スコア表示（左上）
                Text("スコア: \(score)")
                    .font(.largeTitle) // フォントサイズを大きく
                    .padding(.top, 20) // 上部の余白を追加
                    .padding(.leading, 20) // 左側の余白を追加
                Spacer()
                Button(action: {
                    isRankingViewPresented = true
                }) {
                    Text("あなたのランク")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(width: 100, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .fullScreenCover(isPresented: $isRankingViewPresented) {
                    RankView()
                }
            }
            Spacer()
                // 最高記録の表示
                HStack {
                    // 最高スコア表示（左上）
                    Text("最高スコア: \(savedScore)")
                        .font(.largeTitle)
                        .padding(.top, 20)
                        .padding(.leading, 20)
                }
            HStack {
                Spacer()
                Text(result)
                Spacer()
                    .padding(.leading, 10)
            }
            // 数字B表示
            if showNumberB {
                Text("数字B: \(numberB)")
            }
            Spacer()
            // ハイボタンとローボタンを横並びに配置
            HStack {
                // ハイボタン
                Button("ハイ") {
                    onHighButtonTap()
                }
                .padding()
                Text("数字A: \(numberA)")
                    .font(.title) // 数字Aのフォントサイズを設定
                    .padding(.bottom, 20) // 下部の余白を追加
                // ローボタン
                Button("ロー") {
                    onLowButtonTap()
                }
                .padding() // ボタン間の余白を追加
            }
            Spacer()
            
            // ゲームステータスに応じたボタン
            switch gameStatus {
            case .win:
                Button("次の試合") {
                    onNextGameButtonTap()
                }
                .buttonStyle(CustomButtonStyle1())
                
            case .lose:
                Button("再挑戦") {
                    onRetryButtonTap()
                }
                .buttonStyle(CustomButtonStyle2())
            default:
                EmptyView()
            }
            Spacer()
            
        }
        .padding(20) // 余白を追加
        .onAppear {
            // 初期設定
            setupInitialGame()
        }
    }
    
    // ハイボタンがタップされた時の処理
    private func onHighButtonTap() {
        // ハイボタンを押したら、予測をハイに設定する
        prediction = 1
        
        // タイマーを停止する
        isGameFinished = true
        
        // 結果を計算して表示し、数字Bも表示する
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            result = predictResult()
            showNumberB = true
            updateScore()
            if result == "勝ち" {
                gameStatus = .win
            } else {
                gameStatus = .lose
            }
            // スコアをユーザーデフォルトに保存
            UserDefaults.standard.set(score, forKey: "score")
            savedScore = score
        }
    }
    
    // ローボタンがタップされた時の処理
    private func onLowButtonTap() {
        // ローボタンを押したら、予測をローに設定する
        prediction = -1
        
        // タイマーを停止する
        isGameFinished = true
        
        // 結果を計算して表示し、数字Bも表示する
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            result = predictResult()
            showNumberB = true
            updateScore()
            if result == "勝ち" {
                gameStatus = .win
            } else {
                gameStatus = .lose
            }
        }
    }
    
    // 次の試合ボタンがタップされた時の処理
    private func onNextGameButtonTap() {
        // 次の試合ボタンを押したら、新しい数字Aとリセットする
        numberA = Int.random(in: 2...9)
        repeat {
            numberB = Int.random(in: 1...10)
        } while numberB == numberA
        resetGame()
    }
    
    // 再挑戦ボタンがタップされた時の処理
    private func onRetryButtonTap() {
        // 再挑戦ボタンを押したら、数字Aと数字Bをリセットし、結果とタイマーとスコアをクリアする
        numberA = Int.random(in: 2...9)
        repeat {
            numberB = Int.random(in: 1...10)
        } while numberB == numberA
        resetGame()
        // スコアを0にリセット
        score = 0
    }
    
    // 初期ゲームのセットアップ
    private func setupInitialGame() {
        repeat {
            numberB = Int.random(in: 1...10)
        } while numberB == numberA
    }
    
    // ゲームのリセット
    private func resetGame() {
        prediction = 0
        result = ""
        isGameFinished = false
        showNumberB = false
        gameStatus = nil
    }
    
    // 結果の予測
    private func predictResult() -> String {
        if prediction == 1 && numberA < numberB {
            return "勝ち"
        } else if prediction == -1 && numberA > numberB {
            return "勝ち"
        } else {
            return "負け"
        }
    }
    
    // スコアの更新
    private func updateScore() {
        if result == "勝ち" {
            if (numberA == 4 && prediction == -1) || (numberA == 7 && prediction == 1) {
                score += 2
            } else if (numberA == 3 && prediction == -1) || (numberA == 8 && prediction == 1) {
                score += 3
            } else if (numberA == 2 && prediction == -1) || (numberA == 9 && prediction == 1) {
                score += 5
            } else {
                score += 1
            }
            if score > getHighestScore() {
                UserDefaults.standard.set(score, forKey: highestScoreKey)
            }
            
            // スコアをユーザーデフォルトに保存
            UserDefaults.standard.set(score, forKey: "score")
            savedScore = score
        }
    }
    
    // 最高スコアの取得
    private func getHighestScore() -> Int {
        return UserDefaults.standard.integer(forKey: highestScoreKey)
    }
    
    
    // スコアの保存
    private func saveScore() {
        if score > savedScore {
            UserDefaults.standard.set(score, forKey: "highestScore")
            savedScore = score
        }
    }
    struct CustomButtonStyle1: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(Color.red) // ボタンの背景色
                .foregroundColor(.white) // ボタンのテキストカラー
                .cornerRadius(10) // ボタンの角丸
        }
    }
    
    struct CustomButtonStyle2: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(Color.orange) // ボタンの背景色
                .foregroundColor(.white) // ボタンのテキストカラー
                .cornerRadius(10) // ボタンの角丸
        }
    }
}
