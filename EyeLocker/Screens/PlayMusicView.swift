//
//  PlayMusicView.swift
//  EyeLocker
//
//  Created by Christian Lin on 2022/6/8.
//

import SwiftUI
import Foundation
import AVFoundation

enum LatoFontType: String {
    case regular = "Lato-Regular"
    case semibold = "Lato-Semibold"
    case bold = "Lato-Bold"
    case black = "Lato-Black"
}

struct FontModifier: ViewModifier {
    
    var type: LatoFontType, size: CGFloat
    
    init(_ type: LatoFontType = .regular, size: CGFloat = 16) {
        self.type = type
        self.size = size
    }
    
    func body(content: Content) -> some View {
        content.font(Font.custom(type.rawValue, size: size))
    }
}

struct MusicModel {
    let name: String
    let artistName: String
    let coverImage: Image
}

class PlayerViewModel: ObservableObject {
    
    let model: MusicModel
    
    @Published var liked = true
    @Published var slider: Double = 0
    @Published var isPlaying = false {
        didSet {
            if !isPlaying {
                pause_playing()
            } else {
                start_playing()
            }
        }
    }
    
    var audioPlayer: AVAudioPlayer?
    
    var musicCounter: Timer?
    
    init(model: MusicModel) {
        self.model = model
    }
    
    func start_playing() {
        if ((audioPlayer?.isPlaying) != nil) {
            audioPlayer?.play()
            musicCounter = Timer(timeInterval: 1.0, repeats: true, block: {_ in
                self.slider += 1.0
            })
        } else {
            if let path = Bundle.main.path(forResource: "23", ofType: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                    audioPlayer?.play()
                    musicCounter = Timer(timeInterval: 1.0, repeats: true, block: {_ in
                        self.slider += 1.0
                    })
                } catch {
                    print("ERROR")
                }
            }
        }
    }
    
    func pause_playing() {
        if ((audioPlayer?.isPlaying) != nil) {
            audioPlayer?.pause()
            musicCounter?.invalidate()
        }
    }
    
    func stop_playing() {
        if ((audioPlayer?.isPlaying) != nil) {
            audioPlayer?.stop()
            musicCounter?.invalidate()
            audioPlayer = nil
            slider = 0.0
            isPlaying = false
        }
    }
}

struct NeuShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color("neuColor1"), radius: 1, x: -7, y: -7)
            .shadow(color: Color("neuColor2"), radius: 4, x: -13, y: -7)
            .shadow(color: Color("neuColor3"), radius: 10, x: -8, y: 5)
            .shadow(color: Color("neuColor4"), radius: 10, x: 10, y: 9)
    }
}


struct PlayMusicView: View {
        
    @StateObject var viewModel: PlayerViewModel
    
    private let pub = NotificationCenter.default.publisher(for: NSNotification.Name("click_event"))
    
    var body: some View {
        ZStack {
            Color.primary_color.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center) {
                    Button(action: {  }) {
                        Image.close.resizable().frame(width: 20, height: 20)
                            .padding(8).background(Color.primary_color)
                            .cornerRadius(20).modifier(NeuShadow())
                    }
                    Spacer()
                    Button(action: {  }) {
                        Image.options.resizable().frame(width: 16, height: 16)
                            .padding(12).background(Color.primary_color)
                            .cornerRadius(20).modifier(NeuShadow())
                    }
                }.padding(.horizontal, 24).padding(.top, 12)
                
                PlayerDiscView(coverImage: viewModel.model.coverImage)
                
                Text(viewModel.model.name).foregroundColor(.text_primary)
                    .modifier(FontModifier(.black, size: 30))
                    .padding(.top, 12)
                Text(viewModel.model.artistName).foregroundColor(.text_primary_f1)
                    .modifier(FontModifier(.semibold, size: 18))
                    .padding(.top, 12)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 12) {
                    Slider(value: $viewModel.slider, in: 0...100)
                        .accentColor(.main_white)
                }.padding(.horizontal, 45)
                
                Spacer()
                
                HStack(alignment: .center) {
                    Button(action: {
                        if viewModel.isPlaying {
                            viewModel.stop_playing()
                        }
                    }) {
                        Image.next.resizable().frame(width: 18, height: 18)
                            .rotationEffect(Angle(degrees: 180))
                            .padding(24).background(Color.primary_color)
                            .cornerRadius(40).modifier(NeuShadow())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.isPlaying.toggle()
                    }) {
                        (viewModel.isPlaying ? Image.pause : Image.play)
                            .resizable().frame(width: 28, height: 28)
                            .padding(50).background(Color.main_color)
                            .cornerRadius(70).modifier(NeuShadow())
                    }.onReceive(pub) { output in
                        if let userInfo = output.userInfo, let info = userInfo["event"] {
                            guard let data = info as? String else { return }
                            
                            if data == "1" {                // reset music
                                viewModel.stop_playing()
                            } else if data == "2" {         // start/keep playing
                                viewModel.isPlaying.toggle()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {  }) {
                        Image.next.resizable().frame(width: 18, height: 18)
                            .padding(24).background(Color.primary_color)
                            .cornerRadius(40).modifier(NeuShadow())
                    }
                }
                .padding(.horizontal, 32)
            }
            .padding(.bottom, 24)
        }
    }
}

struct PlayMusicView_Previews: PreviewProvider {
    static var previews: some View {
        PlayMusicView(viewModel: PlayerViewModel(model: MusicModel(name: "I'm twenty three", artistName: "IU", coverImage: Image("IU"))))
    }
}


fileprivate struct PlayerDiscView: View {
    let coverImage: Image
    var body: some View {
        ZStack {
            Circle().foregroundColor(.primary_color)
                .frame(width: 300, height: 300).modifier(NeuShadow())
            ForEach(0..<15, id: \.self) { i in
                RoundedRectangle(cornerRadius: (150 + CGFloat((8 * i))) / 2)
                    .stroke(lineWidth: 0.25)
                    .foregroundColor(.disc_line)
                    .frame(width: 150 + CGFloat((8 * i)),
                           height: 150 + CGFloat((8 * i)))
            }
            coverImage.resizable().scaledToFill()
                .frame(width: 120, height: 120).cornerRadius(60)
        }
    }
}
