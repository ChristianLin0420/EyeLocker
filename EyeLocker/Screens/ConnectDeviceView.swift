//
//  ConnectDeviceView.swift
//  EyeLocker
//
//  Created by Christian Lin on 2022/6/1.
//

import SwiftUI

struct ConnectDeviceView: View {
    
    // flag to indicate whether the device is connecting or not
    @State private var startConnect = false {
        didSet {
            if startConnect { connectTitle = "Cancel" }
            else { connectTitle = "Start Connecting" }
        }
    }
    
    // connecting status
    @State private var connectTitle = "Start Connecting"
    
    // define what kind of view will shon on the screen
    @StateObject var viewModel: ControlViewModel
    
    private let pub = NotificationCenter.default.publisher(for: NSNotification.Name("click_event"))
    
    // socket object
    let socket: Socket
    
    var body: some View {
        ZStack{
            Color.primary_color.edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("Connect Your Muse2")
                    .padding()
                    .foregroundColor(Color.text_primary)
                    .font(.system(size: 36, weight: .heavy, design: .rounded))
                Text("Pair your device right now!!!")
                    .foregroundColor(darkGray)
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                
                Spinner(connectStateLabel: connectTitle)
                    .onReceive(pub) { output in
                        if let userInfo = output.userInfo, let info = userInfo["event"] {
                            guard let data = info as? String else { return }
                            
                            if data == "1" {        // shown unlock
                                connectTitle = "Connectted!"
                                viewModel.connected = true
                            } else if data == "2" { // show music playing
                                viewModel.connected = true
                            }
                        }
                    }
                
                Spacer()
                
                PrimaryButton(title: connectTitle, onTapAction: {
                    startConnect.toggle()
                    
                    if startConnect {
                        socket.start_connect()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            socket.keep_checking()
                        }
                    }
                })
            }
            .padding()
        }
    }
}

struct ConnectDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectDeviceView(viewModel: ControlViewModel(), socket: Socket())
    }
}
