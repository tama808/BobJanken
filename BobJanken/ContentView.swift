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
        NavigationView {
            ZStack(alignment: .center) {
                Image("main_back")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("ボブくんの\n気ままにじゃんけん")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
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
