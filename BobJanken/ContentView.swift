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
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
  
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                Image("main_back")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Text("ボブくんの\n気ままにじゃんけん")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.vertical, 30)
                    
                    if savedNickname.isEmpty {
                        VStack {
                            TextField("savedNickname", text: $savedNickname)
                                .padding()
                                .autocapitalization(.none)
                            
                            SecureField("Password", text: $password)
                                .padding()
                            
                            Button("Log In") {
                                // ここにログインのロジックを追加
                                // 例えば、ユーザー名とパスワードが正しいかを確認し、isLoggedInをtrueに設定するなど
                                isLoggedIn = true // 仮のログイン状態を設定
                            }
                            .padding()
                            .disabled(savedNickname.isEmpty || password.isEmpty)
                        }
                        .padding()

                        Button(action: {
                            isSignUpViewPresented = true
                        }) {
                            Text("新規登録する")
                                .foregroundColor(.white)
                                .font(.headline)
                                .frame(width: 150, height: 60)
                                .background(Color.pink)
                                .cornerRadius(10)
                        }
                        HStack {
                            Image("b-nozoki")
                                .resizable()
                                .frame(width: 200, height: 200)
                                .aspectRatio(contentMode: .fit)
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
}
