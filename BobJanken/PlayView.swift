//
//  PlayView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/28.

//
//  PlayView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/28.

import SwiftUI

struct PlayView: View {
    
    @State private var score = 0
    @State private var highScore = UserDefaults.standard.integer(forKey: "highestScore")
    @State private var numberA: Int = Int.random(in: 2...9)
    @State private var numberB: Int = 0
    @State private var prediction: Int = 0
    @State private var result: String = ""
    @State private var showNumberB: Bool = false
    @State private var gameStatus: GameStatus? = nil
    @State private var isGameFinished: Bool = false
    @State private var isButtonsEnabled: Bool = true
    @AppStorage("score") private var savedScore = 0
    @State private var isRankingViewPresented = false
    var userID: String = ""
    
    enum GameStatus {
        case win
        case lose
    }
    let highestScoreKey = "highestScore"
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            Image("main_back")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // 結果表示
                HStack {
                    Spacer()
                    ZStack {
                        Image("bestscore")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 200)
                            .padding()
                        VStack {
                            HStack(spacing: -5)  {
                                // スコア表示
                                Text("\(score)")
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(width: 100, height: 50) // 幅と高さを設定
                                    .offset(x: 80, y: 0) // X軸方向に50ポイント右にずらす
                            }
                            HStack(spacing: -5) {
                                // ベストスコア表示
                                Text("\(highScore)")
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(width: 100, height: 50) // 幅と高さを設定
                                    .offset(x: 80, y: 0) // X軸方向に50ポイント右にずらす
                                
                            }
                        }
                    }
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
                    .sheet(isPresented: $isRankingViewPresented) {
                        RankView()
                    }
                    Spacer()
                }
                Spacer()
            ZStack {
                    Image("playback")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 400)
                    
                    if gameStatus == .win {
                        Image("win")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .offset(x: 50, y: -100)
                    } else if gameStatus == .lose {
                        Image("lose")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .offset(x: 50, y: -100)
                    }
                    
                    if showNumberB {
                        ZStack {
                            HStack(alignment: .top) {
                                Spacer()
                                Image("image\(numberB)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 130, height: 130)
                                    .padding()
                                Spacer()
                            }
                        }
                        .padding(.bottom, 150)
                        .padding(.trailing, 200)
                    }
                }
                
                Spacer()
                // ハイボタンとローボタンを横並びに配置
                HStack {
                    // ハイボタン
                    Button(action: {
                        onHighButtonTap()
                    }) {
                        Image("up")
                            .resizable()
                            .frame(width: 80, height: 90)
                    }
                    .padding()
                    Image("image\(numberA)")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 90)
                        .padding(.bottom, 20)
                    // ローボタン
                    Button(action: {
                        onLowButtonTap()
                    }) {
                        Image("down")
                            .resizable()
                            .frame(width: 80, height: 90)
                    }
                    .padding()
                }
                
                
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
                    Spacer()
                }
            }
            .padding(20)
            .onAppear {
                // 初期設定
                setupInitialGame()
            }
        }
    }
    
    // ハイボタンがタップされた時の処理
    private func onHighButtonTap() {
        prediction = 1
        isGameFinished = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            result = predictResult()
            showNumberB = true
            updateScore()
            if result == "勝ち" {
                gameStatus = .win
            } else {
                gameStatus = .lose
            }
            saveScore()
        }
    }
    
    // ローボタンがタップされた時の処理
    private func onLowButtonTap() {
        prediction = -1
        isGameFinished = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            result = predictResult()
            showNumberB = true
            updateScore()
            if result == "勝ち" {
                gameStatus = .win
            } else {
                gameStatus = .lose
                saveScore()
            }
        }
    }
    
    // 次の試合ボタンがタップされた時の処理
    private func onNextGameButtonTap() {
        numberA = Int.random(in: 2...9)
        repeat {
            numberB = Int.random(in: 1...10)
        } while numberB == numberA
        resetGame()
    }
    
    // 再挑戦ボタンがタップされた時の処理
    private func onRetryButtonTap() {
        numberA = Int.random(in: 2...9)
        repeat {
            numberB = Int.random(in: 1...10)
        } while numberB == numberA
        resetGame()
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
            var scoreIncrement = 1
            
            if (numberA == 4 && prediction == -1) || (numberA == 7 && prediction == 1) {
                scoreIncrement = 2
            } else if (numberA == 3 && prediction == -1) || (numberA == 8 && prediction == 1) {
                scoreIncrement = 3
            } else if (numberA == 2 && prediction == -1) || (numberA == 9 && prediction == 1) {
                scoreIncrement = 5
            }
            
            score += scoreIncrement
            savedScore = score
        }
    }
    
    // スコアの保存

    private func saveScore() {
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: highestScoreKey)
        }
    }
    
    struct CustomButtonStyle1: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    struct CustomButtonStyle2: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
}
