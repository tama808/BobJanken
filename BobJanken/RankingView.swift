//
//  RankingView.swift
//  BobJanken
//
//  Created by taro tama on 2023/09/05.
//
import SwiftUI

struct RankingView: View {
    @AppStorage("score") private var savedScore = 0
    @AppStorage("savedNickname") private var savedNickname = ""
    @AppStorage("savedPrefecture") private var savedPrefecture = ""
    @AppStorage("savedAge") private var savedAge = 0
    @AppStorage("savedGender") private var savedGender = ""
    @State var isPlayViewPresented = false
    
    // PlayView のインスタンスを作成
    let playView = PlayView()
    
    struct PlayerData: Identifiable {
        var id = UUID()
        var nickname: String
        var score: Int
        var prefecture: String // 都道府県
        var age: Int // 年齢
        var gender: String // 性別
    }
    
    var body: some View {
        VStack {
            Text("ランキング")
                .font(.largeTitle)
                .padding()
            
            // ランキングのリスト表示
            List(getRanking()) { playerData in
                VStack(alignment: .leading) {
                    Text("ニックネーム: \(playerData.nickname)")
                    Text("スコア: \(playerData.score)")
                    Text("都道府県: \(playerData.prefecture)")
                    Text("年齢: \(playerData.age)")
                    Text("性別: \(playerData.gender)")
                }
            }
        }
        .navigationBarTitle("ランキング")
        
        Button(action: {
            isPlayViewPresented = true
        }) {
            Text("勝負する")
                .foregroundColor(.white)
                .font(.headline)
                .frame(width: 300, height: 100)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .fullScreenCover(isPresented: $isPlayViewPresented) {
            PlayView()
        }
    }
    
    // ユーザーデフォルトからスコアのランキングを取得する関数
    private func getRanking() -> [PlayerData] {
        // ユーザーデフォルトから保存されたスコアを取得
        var scores = UserDefaults.standard.array(forKey: "score") as? [Int] ?? []
        
        // 最高スコアを追加
        let highestScore = UserDefaults.standard.integer(forKey: playView.highestScoreKey)
        scores.append(highestScore)
        
        // ニックネーム、スコア、都道府県、年齢、性別を含む PlayerData オブジェクトの配列を作成
        let rankingData: [PlayerData] = scores.map { score in
            return PlayerData(nickname: savedNickname, score: score, prefecture: savedPrefecture, age: savedAge, gender: savedGender)
        }
        
        // スコアを高い順にソートして返す
        return rankingData.sorted(by: { $0.score > $1.score })
    }
}
