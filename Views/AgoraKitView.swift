//
//  AgoraKitView.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 5/1/24.
//

import SwiftUI
import AgoraRtcKit


struct AgoraKitView: View {
    @State private var agoraKit: AgoraRtcEngineKit?
    @State private var channelName: String = ""
    @State private var isJoining = false
    @State private var isMuted = true
    @State private var joinedChannel = false
    
    var body: some View {
        HStack {
            
            if !joinedChannel {
                TextField("Enter channel name", text: $channelName)
                    .background(Color.white).border(Color.black, width: 2).padding(10)
                    .textInputAutocapitalization(.never)
                
                Button(action: joinChannel) {
                    Text(isJoining ? "Joining..." : "Join Channel")
                }
                .frame(height: 2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(channelName.isEmpty || isJoining)
            }
            else{
                Button(action: {
                    toggleMicMute()
                }, label: {
                    Text(isMuted ? "Muted" : "Unmuted").font(.custom("BinaryCHRBRK", size: 20))
                        .frame(width: 110, height: 50)
                        .background(Gradient(colors: [Color.blue, Color(red: 29/255, green: 95/255, blue: 117/255)])).overlay(
                            RoundedRectangle(cornerRadius: 50, style: .continuous)
                                .stroke(Color.black, lineWidth: 10)
                        ).foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 50, height: 10)))
                        .shadow(color: Color.black, radius: 3, x: -5, y: -3)
                })

            }
            
        }
    }
    
    private func joinChannel() {
        guard !channelName.isEmpty else { return }
        
        isJoining = true
        joinedChannel = true
        
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "", delegate: nil)
        agoraKit?.joinChannel(byToken: nil, channelId: channelName, info: nil, uid: 0) { (channel, uid, elapsed) in
            // Join channel success
            DispatchQueue.main.async { [self] in
                isJoining = false
                print("Joined channel: \(channel)")
            }
        }
    }
    private func toggleMicMute() {
        isMuted.toggle()
        if isMuted {
            agoraKit?.disableAudio()
        }
        else{
            agoraKit?.enableAudio()
        }
    }
}

struct AgoraKit_Previews: PreviewProvider {
    static var previews: some View {
        AgoraKitView()
    }
}
