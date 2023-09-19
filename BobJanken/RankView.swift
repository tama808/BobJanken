import SwiftUI

extension Color {
    static let bronze = Color(red: 205 / 255.0, green: 127 / 255.0, blue: 50 / 255.0)
}

struct RankView: View {
    
    @AppStorage("highestScore") private var highestScore = 0
    @AppStorage("savedNickname") private var savedNickname = ""
    
    var body: some View {
        VStack {
            if highestScore < 10 {
                Image("bronze")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("\(savedNickname)さんは\n")
                    .font(.title)
                    .foregroundColor(.black) +
                Text("　ブロンズ\n")
                    .font(.system(size: 40, weight: .bold)) // ブロンズの部分のフォントサイズを変更
                    .foregroundColor(.bronze) +
                Text("　　　　ランクです")
                    .font(.title)
                    .foregroundColor(.black)
            } else if highestScore < 15 {
                Image("silver")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                Text("頑張っています！")
                    .font(.title)
                    .foregroundColor(.orange)
            } else if highestScore < 20 {
                Image("excellent")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                Text("素晴らしい成績！")
                    .font(.title)
                    .foregroundColor(.green)
            } else {
                Image("score_20")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            // その他のコンテンツを追加
        }
    }
}
