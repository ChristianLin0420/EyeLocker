//
//  ContentView.swift
//  EyeLocker
//
//  Created by Christian Lin on 2022/5/30.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WelcomeScreenView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PrimaryButton: View {
    var title: String
    var onTapAction: () -> Void
    
    var body: some View {
        Button(action: onTapAction) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.text_primary)
                .cornerRadius(50)
        }
    }
}
