//
//  ContentView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/27.
//

//
//  ContentView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/27.
//

import SwiftUI

struct ContentView: View {
    @State var isPlayViewPresented = false
    @State var isSignUpViewPresented = false
    @AppStorage("savedNickname") private var savedNickname = ""
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.gray
            
            VStack {
                if !savedNickname.isEmpty {
                    Text("ようこそ、\(savedNickname) さん！")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }
                
                Text("ボブくんの\n気ままにじゃんけん")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 30)
                
                if savedNickname.isEmpty {
                    Button(action: {
                        isSignUpViewPresented = true
                    }) {
                        Text("登録する")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 150, height: 60)
                            .background(Color.pink)
                            .cornerRadius(10)
                    }
                    .fullScreenCover(isPresented: $isSignUpViewPresented) {
                        SignUpView()
                    }
                    .padding(.bottom, 20)
                } else {
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
                    .padding(.bottom, 20)
                    
                    Button(action: {
                        savedNickname = ""
                    }) {
                        Text("ログアウト")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 100, height: 40)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    
                    Spacer() // スペースを追加して画像を上に押し上げる
                    
                    Image("b-main")
                        .resizable()
                        .frame(width: 300, height: 300)
                        .aspectRatio(contentMode: .fit)
                        .offset(y: 25) // 画像を少し上に移動
            
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
        HStack {
            Image("b-nozoki")
                .resizable()
                .frame(width: 100, height: 100)
                .aspectRatio(contentMode: .fit)
        }
        .padding(.horizontal, 20)
    }
}
