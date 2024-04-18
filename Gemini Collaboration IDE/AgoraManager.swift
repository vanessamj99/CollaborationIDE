//
//  AgoraManager.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 4/18/24.
//

import Foundation
import AgoraRtcKit
import AVFoundation


class AgoraManager: NSObject, AgoraRtcEngineDelegate {
    
    // The Agora RTC Engine Kit for the session.
    public var agoraEngine: AgoraRtcEngineKit {
        if let engine { return engine }
        let engine = setupEngine()
        self.engine = engine
        return engine
    }

    open func setupEngine() -> AgoraRtcEngineKit {
        let eng = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: self)
        if DocsAppConfig.shared.product != .voice {
            eng.enableVideo()
        } else { eng.enableAudio() }
        eng.setClientRole(role)
        return eng
    }

    // The Agora App ID for the session.
    public let appId: String = ""
    // The client's role in the session.
    public var role: AgoraClientRole = .audience {
        didSet { agoraEngine.setClientRole(role) }
    }

    // The set of all users in the channel.
    @Published public var allUsers: Set<UInt> = []

    // Integer ID of the local user.
    @Published public var localUserId: UInt = 0

    private var engine: AgoraRtcEngineKit?
    
    static func checkForPermissions() async -> Bool {
        var hasPermissions = await self.avAuthorization(mediaType: .audio)
        return hasPermissions
    }

    static func avAuthorization(mediaType: AVMediaType) async -> Bool {
        let mediaAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch mediaAuthorizationStatus {
        case .denied, .restricted: return false
        case .authorized: return true
        case .notDetermined:
            return await withCheckedContinuation { continuation in
                AVCaptureDevice.requestAccess(for: mediaType) { granted in
                    continuation.resume(returning: granted)
                }
            }
        @unknown default: return false
        }
    }
    
    func rtcEngine(
        _ engine: AgoraRtcEngineKit, didJoinChannel channel: String,
        withUid uid: UInt, elapsed: Int
    ) {
        // The delegate is telling us that the local user has successfully joined the channel.
        self.localUserId = uid
        self.allUsers.insert(uid)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        // The delegate is telling us that a remote user has joined the channel.
        self.allUsers.insert(uid)
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        // The delegate is telling us that a remote user has left the channel.
        self.allUsers.remove(uid)
    }
    
    func joinVoiceCall(
        _ channel: String, token: String? = nil, uid: UInt = 0
    ) async -> Int32 {
        /// See ``AgoraManager/checkForPermissions()``, or Apple's docs for details of this method.
        if await !AgoraManager.checkForPermissions() {
            // handle permissions not granted
            return -3
        }

        let opt = AgoraRtcChannelMediaOptions()
        opt.channelProfile = .communication

        return self.agoraEngine.joinChannel(
            byToken: token, channelId: channel,
            uid: uid, mediaOptions: opt
        )
    }
    
    func leaveChannel(
        leaveChannelBlock: ((AgoraChannelStats) -> Void)? = nil
    ) -> Int32 {
        let leaveErr = self.agoraEngine.leaveChannel(leaveChannelBlock)
        self.agoraEngine.stopPreview()
        self.allUsers.removeAll()
        return leaveErr
    }
    
    func destroyAgoraEngine() {
        AgoraRtcEngineKit.destroy()
    }

}
