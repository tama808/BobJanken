import SwiftUI

struct RankView: View {
    
    @AppStorage("highestScore") private var highestScore = 0
    var body: some View {
        VStack {
            if highestScore >= 13 {
                Text("優秀な成績！")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            } else {
                Text("もっと頑張りましょう！")
                    .font(.title)
                    .foregroundColor(.red)
            }
            // その他のコンテンツを追加
        }
    }
}
