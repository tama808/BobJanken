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

struct HoveringImage: View {
    @State private var isHovered = false
    @State private var rotationAngle: Double = 0.0

    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .frame(width: 100, height: 100)
            .rotationEffect(.degrees(rotationAngle))
            .onAppear() {
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    self.rotationAngle = 5.0 // 画像を揺らす角度を設定します
                }
            }
    }
}
struct ContentView: View {
    
    @State var isPlayViewPresented = false
    @State var isRankingViewPresented = false
    @State var isSignUpViewPresented = false
    @State private var isResetting = false
    
    @AppStorage("savedNickname") private var savedNickname = ""
    @State private var isLoggedIn: Bool = false
    @AppStorage("savedPrefecture") private var savedPrefecture = ""
    @AppStorage("savedAge") private var savedAge = ""
    @AppStorage("savedGender") private var savedGender = ""
    @AppStorage("savedScore") private var savedScore = ""
    
    var body: some View {
        HoveringImage()
            .padding()
        
        NavigationView {
            ZStack(alignment: .center) {
                Image("main_back")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    if savedNickname.isEmpty {
                        VStack {
                            Button("新規登録する") {
                                isSignUpViewPresented = true
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 150, height: 60)
                            .background(Color.pink)
                            .cornerRadius(10)
                            .fullScreenCover(isPresented: $isSignUpViewPresented) {
                                SignUpView()
                            }
                            HStack {
                                Image("b-nozoki")
                                    .resizable()
                                    .frame(width: 200, height: 200)
                                    .aspectRatio(contentMode: .fit)
                            }
                            
                        }
                        .padding(.bottom, 20)
                    } else {
                        Button("勝負する") {
                            isPlayViewPresented = true
                        }
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(width: 300, height: 100)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .fullScreenCover(isPresented: $isPlayViewPresented) {
                            PlayView()
                        }
                        .padding(.bottom, 20)
                            
                        Button(action: {
                            isRankingViewPresented = true
                        }) {
                            Text("あなたのランク")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(width: 300, height: 50)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $isRankingViewPresented) {
                            RankView()
                        }
                        .padding(.bottom, 20)
                        
                        Button(action: {
                            isResetting = true // リセットボタンが押されたらisResettingをtrueに設定
                        }) {
                            Text("リセット")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(width: 300, height: 50)
                                .background(Color.red) // リセットボタンの色を変更
                                .cornerRadius(10)
                        }
                        .disabled(isResetting) // ボタンを無効にする
                        .alert(isPresented: $isResetting) {
                            Alert(
                                title: Text("リセット"),
                                message: Text("すべてのユーザーデフォルトデータを削除します。よろしいですか？"),
                                primaryButton: .default(Text("OK"), action: {
                                    resetUserDefaults()
                                    isResetting = false // リセット処理が完了したらisResettingをfalseに設定
                                    // ページを再読み込みする
                                    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: ContentView())
                                }),
                                secondaryButton: .cancel()
                            )
                        }
                        if !savedNickname.isEmpty {
                            HStack {
                                ZStack(alignment: .topLeading) {
                                    Image("fuki")
                                        .resizable()
                                        .frame(width: 250, height: 150)
                                        .offset(x: -30, y: 0)
                                    
                                    
                                    Text("ようこそ、\n\(savedNickname) さん！\n楽しんでくださいね\n今日は負けないぞ")
                                        .font(.system(size: 14))
                                        .foregroundColor(.black)
                                        .padding(15)
                                        .offset(x: -10, y: 30)
                                    Spacer()
                                    Image("b-main")
                                        .resizable()
                                        .frame(width: 300, height: 300)
                                        .aspectRatio(contentMode: .fit)
                                        .offset(x: 70,y: 25)
                                }
                            }
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
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    // ユーザーデフォルトをリセットする処理
    private func resetUserDefaults() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}
