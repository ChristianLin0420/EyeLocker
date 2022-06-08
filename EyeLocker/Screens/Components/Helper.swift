//
//  Helper.swift
//  EyeLocker
//
//  Created by Christian Lin on 2022/6/1.
//

import Foundation
import SwiftUI

// MARK: Colors
let darkBlack = Color(red: 17/255, green: 18/255, blue: 19/255)
let darkGray = Color(red: 41/255, green: 42/255, blue: 48/255)
let darkBlue = Color(red: 96/255, green: 174/255, blue: 201/255)
let darkPink = Color(red: 244/255, green: 132/255, blue: 177/255)
let darkViolet = Color(red: 214/255, green: 189/255, blue: 251/255)
let darkGreen = Color(red: 137/255, green: 192/255, blue: 180/255)

let clearWhite = Color(red: 17/255, green: 18/255, blue: 19/255)
let clearGray = Color(red: 181/255, green: 182/255, blue: 183/255)
let clearBlue = Color(red: 116/255, green: 166/255, blue: 240/255)

extension Color {
    static let primary_color = Color("EFF0F9_282C31")
    static let main_color = Color(hex: "657592")
    static let main_white = Color("657592_F4F4F4")
    
    static let text_header = Color("333333_F4F4F4")
    static let text_primary = Color("657592_C6CBDA")
    static let text_primary_f1 = Color.text_primary.opacity(0.8)
    
    static let disc_line = Color("666666_F4F4F4")
    
    init(hex: String, alpha: Double = 1) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
        
        let scanner = Scanner(string: cString)
        scanner.currentIndex = scanner.string.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        self.init(.sRGB, red: Double(r) / 0xff, green: Double(g) / 0xff, blue:  Double(b) / 0xff, opacity: alpha)
    }
}

extension Image {
    
    // icons
    static let close = Image("arrow_down")
    static let options = Image("options_icon")
    static let search = Image("search_icon")
    static let play = Image("play_icon")
    static let pause = Image("pause_icon")
    static let heart = Image("heart_icon")
    static let heart_filled = Image("heart-filled_icon")
    static let next = Image("next_icon")
    
    // Profile Pic
    static let profile_pic = Image("profile_pic")
    // cover images
    static let cover1 = Image("cover1")
    static let cover2 = Image("cover2")
    static let cover3 = Image("cover3")
    static let cover4 = Image("cover4")
    static let cover5 = Image("cover5")
}
