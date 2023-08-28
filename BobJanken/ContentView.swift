//
//  ContentView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/27.
//

import SwiftUI

struct ContentView: View {
    @State var str = "Hello, SwiftUI"
    @State var isPlayViewPresented = false // ステート変数を追加
    
    var body: some View {
        VStack {
            Button(action: {
                isPlayViewPresented = true // ボタンがタップされたらisPlayViewPresentedをtrueにする
            }) {
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 350, height: 100)
            }
            Rectangle()
                .foregroundColor(.purple)
                .frame(width: 350, height: 100)
        }
        .sheet(isPresented: $isPlayViewPresented) {
            // PlayViewを表示する
            PlayView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
