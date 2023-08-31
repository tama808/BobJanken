//
//  SignUpView.swift
//  BobJanken
//
//  Created by taro tama on 2023/08/30.
//

import SwiftUI

struct SignUpView: View {
    @State private var nickname = ""
    @State private var password = ""
    @State private var selectedPrefecture = Prefecture.hokkaido
    @State private var age = 18
    @State private var gender = Gender.male
    
    @AppStorage("savedNickname") private var savedNickname = ""
    
    @State private var isRegistered = false
    
    var isNicknameValid: Bool {
        nickname.count >= 2
    }
    
    var isPasswordValid: Bool {
        password.count >= 4
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本情報")) {
                    TextField("ニックネーム（２文字以上）", text: $nickname)
                        .foregroundColor(isNicknameValid ? .primary : .red)
                    SecureField("パスワード（４文字以上）", text: $password)
                        .foregroundColor(isPasswordValid ? .primary : .red)
                    
                    Picker("都道府県", selection: $selectedPrefecture) {
                        ForEach(Prefecture.allCases, id: \.self) { prefecture in
                            Text(prefecture.rawValue)
                        }
                    }
                    .pickerStyle(WheelPickerStyle()) // スクロール選択
                    
                    Stepper("年齢: \(age)", value: $age, in: 0...150)
                    
                    Picker("性別", selection: $gender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: ContentView(), isActive: $isRegistered) {
                        EmptyView()
                    }
                    Button("登録できるよ") {
                        savedNickname = nickname
                        isRegistered = true
                    }
                    .disabled(!isNicknameValid || !isPasswordValid)
                }
            }
            .navigationBarTitle("サインアップ")
        }
    }
}
enum Prefecture: String, CaseIterable {
    case hokkaido = "北海道", aomori = "青森県", iwate = "岩手県", miyagi = "宮城県", akita = "秋田県", yamagata = "山形県", fukushima = "福島県", ibaraki = "茨城県", tochigi = "栃木県", gunma = "群馬県", saitama = "埼玉県", chiba = "千葉県", tokyo = "東京都", kanagawa = "神奈川県", niigata = "新潟県", toyama = "富山県", ishikawa = "石川県", fukui = "福井県", yamanashi = "山梨県", nagano = "長野県", gifu = "岐阜県", shizuoka = "静岡県", aichi = "愛知県", mie = "三重県", shiga = "滋賀県", kyoto = "京都府", osaka = "大阪府", hyogo = "兵庫県", nara = "奈良県", wakayama = "和歌山県", tottori = "鳥取県", shimane = "島根県", okayama = "岡山県", hiroshima = "広島県", yamaguchi = "山口県", tokushima = "徳島県", kagawa = "香川県", ehime = "愛媛県", kochi = "高知県", fukuoka = "福岡県", saga = "佐賀県", nagasaki = "長崎県", kumamoto = "熊本県", oita = "大分県", miyazaki = "宮崎県", kagoshima = "鹿児島県", okinawa = "沖縄県", other = "その他"
    
    var id: String { self.rawValue }
}
    
    enum Gender: String, CaseIterable {
        case male = "男性"
        case female = "女性"
        case other = "どちらでもない"
    }

