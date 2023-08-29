//
//  ContentView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/27.
//

import SwiftUI

struct ContentView: View {
    @State var isPlayViewPresented = false
    
    var body: some View {
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
            
            Rectangle()
                .foregroundColor(.purple)
                .frame(width: 350, height: 100)
        }
    }
}
