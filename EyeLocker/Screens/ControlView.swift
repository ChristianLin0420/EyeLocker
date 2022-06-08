//
//  ControlView.swift
//  EyeLocker
//
//  Created by Christian Lin on 2022/6/8.
//

import SwiftUI

class ControlViewModel: ObservableObject {
    @Published var connected = false
}

struct ControlView: View {
    
    @StateObject var viewModel: ControlViewModel
    
    // define what kind of view will shon on the screen
//    @State private var loginTask = true
        
    // socket object
    let socket = Socket()
    
    var body: some View {
        if !viewModel.connected {
            ConnectDeviceView(viewModel: viewModel, socket: socket)
        } else {
            PlayMusicView(viewModel: PlayerViewModel(model: MusicModel(name: "I'm twenty five", artistName: "IU", coverImage: Image("IU"))))
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView(viewModel: ControlViewModel())
    }
}
