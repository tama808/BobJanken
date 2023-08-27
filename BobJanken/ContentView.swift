//
//  ContentView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/27.
//

import SwiftUI

struct ContentView: View {
    @State var str = "Hello,SwiftUI"
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 350, height: 100)
            Rectangle()
                .foregroundColor(.purple)
                .frame(width: 350, height: 100)
            HStack {
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 150, height: 150)
                Rectangle()
                    .foregroundColor(.red)
                    .frame(width: 100, height: 100)
                Rectangle()
                    .foregroundColor(.yellow)
                    .frame(width: 50, height: 50)
            }
            ZStack {
                Rectangle()
                    .foregroundColor(.green)
                    .frame(width: 350, height: 200)
                HStack{
                    VStack{
                        Rectangle()
                            .foregroundColor(.pink)
                            .frame(width: 150, height: 70)
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(width: 150, height: 70)
                    }
                    VStack{
                        Rectangle()
                            .foregroundColor(.white)
                            .frame(width: 150, height: 70)
                        Rectangle()
                            .foregroundColor(.yellow)
                            .frame(width: 150, height: 70)
                    }
                }
            }
        }
    }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
    }
}
