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
    @State var half = true
    @State var progress: CGFloat = 0.0
    @State var animateFlag = false
    @Namespace var nspace
    
    let retroColors: [Color] = [
        Color.init(.sRGB, red: 129/255, green: 179/255, blue: 174/255, opacity: 1.0),
        Color.init(.sRGB, red: 225/255, green: 124/255, blue: 123/255, opacity: 1.0),
        Color.init(.sRGB, red: 170/255, green: 82/255, blue: 78/255, opacity: 1.0),
        Color.init(.sRGB, red: 44/255, green: 47/255, blue: 90/255, opacity: 1.0),
        Color.init(.sRGB, red: 229/255, green: 202/255, blue: 175/255, opacity: 1.0),
        Color.init(.sRGB, red: 136/255, green: 29/255, blue: 29/255, opacity: 1.0),
        Color.init(.sRGB, red: 120/255, green: 149/255, blue: 97/255, opacity: 1.0)
    ]
    
    var model: IntroModel
    var isATM: Bool {
        model.subTitle == IntroModel.atm.subTitle
    }
    
    var body: some View {
        if animateFlag {
            rectableView
        } else {
            if isATM {
                capsuleView
            } else {
                circleView
            }
        }
        titleView
        Button("Let's Go") { withAnimation(.easeInOut(duration: 0.5)) {
            animateFlag.toggle()
        } }.font(.headline)
    }
    
    var accentColor: Color {
        retroColors.randomElement() ?? model.color
    }
    
    var titleView: some View {
        Text(model.title)
            .font(.headline)
            .foregroundColor(Color.orange)
            .padding()
    }
    
    var rectableView: some View {
        ZStack {
            Rectangle()
                .stroke(accentColor, lineWidth: 2.0)
                .frame(width: 300, height: 200, alignment: .center)
            Rectangle()
                .fill(accentColor)
                .frame(width: 292, height: 192, alignment: .center)
            subtitleView
        }.matchedGeometryEffect(id: "geoeffect1", in: nspace)
    }
    
    var circleView: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(accentColor, lineWidth: 2.0)
                .frame(width: 300, height: 300, alignment: .center)
            Circle()
                .fill(accentColor)
                .frame(width: 292, height: 292, alignment: .center)
                .scaleEffect(half ? 0.2 : 1.0)
            subtitleView
        }
        .matchedGeometryEffect(id: "geoeffect1", in: nspace)
        .animation(.easeInOut(duration: 1.0))
        .onAppear(perform: {
            half = false
            progress = 1.0
        })
    }
    
    var subtitleView: some View {
        Text(model.subTitle)
            .foregroundColor(.white)
            .font(.system(size: 22))
            .fontWeight(.bold)
    }
    
    var capsuleView: some View {
        ZStack {
            Capsule(style: .continuous)
                .trim(from: 0.0, to: progress)
                .stroke(accentColor, lineWidth: 2.0)
                .frame(width: 300, height: 100, alignment: .center)
            Capsule(style: .continuous)
                .fill(accentColor)
                .frame(width: 292, height: 92, alignment: .center)
                .scaleEffect(half ? 0.2 : 1.0)
            subtitleView
        }
        .matchedGeometryEffect(id: "geoeffect1", in: nspace)
        .animation(.easeInOut(duration: 1.0))
        .onAppear(perform: {
            half = false
            progress = 1.0
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: IntroModel.card)
    }
}
