//
//  ContentView.swift
//  Clip
//
//  Created by Serge Gainsbourg on 9/7/20.
//  Copyright © 2020 IKSong. All rights reserved.
//

import SwiftUI

struct IntroModel {
    let title: String
    let subTitle: String
    let color: Color
    
    static let atm = IntroModel(title: "Welcome To Clip", subTitle: "Let's find ATMs nearby", color: Color.green)
    
    static let card = IntroModel(title: "Welcome To Clip", subTitle: "Ready to active your card?", color: Color.init(.sRGB, red: 8/255, green: 50/255, blue: 66/255, opacity: 1.0))
    
}

extension IntroModel {
    enum Model: String {
        case atm
        case card
    }
    init?(withPath path: String) {
        let p = path.replacingOccurrences(of: "/", with: "")
        let m = Model.init(rawValue: p)
        
        switch m {
        case .atm: self = IntroModel.atm
        case .card: self = IntroModel.card
        default: return nil
        }
    }
}

struct ContentView: View {
    var model: IntroModel
    var body: some View {
        ZStack {
            Circle()
                .stroke(model.color, lineWidth: 2.0)
                .frame(width: 300, height: 300, alignment: .center)
            Circle()
                .fill(model.color)
                .frame(width: 292, height: 292, alignment: .center)
            Text(model.subTitle)
                .foregroundColor(.white)
                .font(.headline)
        }
        Text(model.title)
            .font(.headline)
            .foregroundColor(Color.orange)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: IntroModel.card)
    }
}
