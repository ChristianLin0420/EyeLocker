//
//  Socket.swift
//  EyeLocker
//
//  Created by Christian Lin on 2022/6/5.
//

import Foundation
import SocketIO

class Socket {
    
    private let manager: SocketManager
    private var socket: SocketIOClient
    private var connected = false
    private var emittedTimer: Timer = Timer()

    init() {
         manager = SocketManager(socketURL: URL(string: "http://localhost:5000")!, config: [.log(true),.reconnects(true)])
         socket = manager.defaultSocket
    }
    
    func start_connect() {
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
            self.socket.emit("connect", [])
        }
                    
        socket.on("get_event") {data, ack in
            guard let b = data[0] as? Int else { return }
            print("test: " + String(b))
            
            NotificationCenter.default.post(name: NSNotification.Name("click_event"), object: nil, userInfo: ["event": String(b / 3)])
            
            if !self.connected {
                self.connected = true
            }
        }
                       
        socket.connect()
    }
    
    func keep_checking() {
        emittedTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.socket.emit("get_event", [])
        }
    }
    
    func cancel_checking() {
        socket.disconnect()
        emittedTimer.invalidate()
    }
}
