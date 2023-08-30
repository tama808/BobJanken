//
//  ContentView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/27.
//

import SwiftUI

struct ContentView: View {
    @State var isPlayViewPresented = false
    @State var isSignUpViewPresented = false // 追加: SignUpView表示のための状態プロパティ
    @AppStorage("savedNickname") private var savedNickname = ""
    var body: some View {
        if !savedNickname.isEmpty {
            Text("ようこそ、\(savedNickname) さん！")
        }
        VStack {
            Button(action: {
                isPlayViewPresented = true
            }) {
                Text("勝負する")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(width: 350, height: 100)
                    .background(Color.blue)
                    .cornerRadius(10)
                
            }
            .fullScreenCover(isPresented: $isPlayViewPresented) {
                PlayView()
            }
            
            Button(action: {
                isSignUpViewPresented = true // ボタンアクションでSignUpView表示の状態を更新
            }) {
                Text("登録する")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(width: 350, height: 100)
                    .background(Color.pink)
                    .cornerRadius(10)
            }
            .fullScreenCover(isPresented: $isSignUpViewPresented) {
                SignUpView()
            }
            
            Button(action: {
                savedNickname = "" // ユーザーデフォルトをクリアしてログアウト
            }) {
                Text("ログアウト")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(width: 150, height: 40)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            }
        .navigationBarHidden(true) // ナビゲーションバーを非表示にする
        }
    }

