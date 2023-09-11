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
import AVFoundation

struct PlayView: View {
    
    // プロパティ定義
    @State private var score = 0
    @State private var audioPlayer: AVAudioPlayer?
    @State var numberA: Int = Int.random(in: 2...9)
    @State var numberB: Int = 0
    @State var prediction: Int = 0
    @State var result: String = ""
    @State var showNumberB: Bool = false
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
    let ScoreDigits: [String]
    
    init() {
        let score = UserDefaults.standard.integer(forKey: highestScoreKey)
        self._score = State(initialValue: score)
        self.ScoreDigits = String(score).map { String($0) }
    }
    var body: some View {
        
        ZStack(alignment: .bottom) {
            SwiftUI.Image("main_back")
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
                                ForEach(ScoreDigits, id: \.self) { digit in
                                    Image("simage\(digit)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 30)
                                        .offset(x: 70,y: -10)
                                }
                            }
                            HStack(spacing: -5) {
                                // ベストスコア表示
                                ForEach(ScoreDigits, id: \.self) { digit in
                                    Image("simage\(digit)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 20, height: 30)
                                        .offset(x: 70,y: 17)
                                }
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
                        Image("win") // "winImage"は実際の勝利画像の名前に置き換えてください
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200) // 画像サイズを調整
                            .offset(x: 50, y: -100) // "playback"の右上に配置
                    } else if gameStatus == .lose {
                        Image("lose") // "loseImage"は実際の敗北画像の名前に置き換えてください
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200) // 画像サイズを調整
                            .offset(x: 50, y: -100) // "playback"の右上に配置
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
                        audioPlayer?.play()
                    }) {
                        SwiftUI.Image("up") // 画像オブジェクトを渡す
                            .resizable() // 画像をリサイズ可能にする
                            .frame(width: 80, height: 90) // 画像の幅と高さを設定
                    }
                    .padding()
                    Image("image\(numberA)")
                    .resizable()
                    .aspectRatio(contentMode: .fit) // 画像のアスペクト比を保持してフィットさせる
                    .frame(width: 80, height: 90)
                        .padding(.bottom, 20) // 下部の余白を追加
                    // ローボタン
                    Button(action: {
                        onLowButtonTap()
                        audioPlayer?.play()
                    }) {
                        SwiftUI.Image("down") // 画像オブジェクトを渡す
                            .resizable() // 画像をリサイズ可能にする
                            .frame(width: 80, height: 90) // 画像の幅と高さを設定
                    }
                    .padding() // ボタン間の余白を追加
                }
                .onAppear {
                    if let soundURL = Bundle.main.url(forResource: "drumroll", withExtension: "mp3") {
                        do {
                            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                            audioPlayer?.prepareToPlay()
                        } catch {
                            print("Error loading sound file: \(error.localizedDescription)")
                        }
                    }
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
                
            }
            .padding(20) // 余白を追加
            .onAppear {
                // 初期設定
                setupInitialGame()
            }
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
        }
    }
    
    // 最高スコアの取得
    private func getHighestScore() -> Int {
        return UserDefaults.standard.integer(forKey: highestScoreKey)
    }
    
    // スコアの保存
    private func saveScore() {
        if score > savedScore {
            savedScore = score
            UserDefaults.standard.set(savedScore, forKey: highestScoreKey)
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
