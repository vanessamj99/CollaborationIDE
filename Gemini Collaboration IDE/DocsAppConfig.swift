//
//  DocsAppConfig.swift
//  Gemini Collaboration IDE
//
//  Created by Vanessa Johnson on 4/18/24.
//

import Foundation
import SwiftUI

public struct DocsAppConfig: Codable {
    static var shared: DocsAppConfig = {
        guard let fileUrl = Bundle.main.url(forResource: "config", withExtension: "json"),
              let jsonData  = try? Data(contentsOf: fileUrl) else { fatalError() }

        let decoder = JSONDecoder()
        // For this sample code we can assume the json is a valid format.
        // swiftlint:disable:next force_try
        var obj = try! decoder.decode(DocsAppConfig.self, from: jsonData)
        if (obj.rtcToken ?? "").isEmpty {
            obj.rtcToken = nil
        }
        return obj
    }()

    var uid: UInt
    // APP ID from https://console.agora.io
    var appId: String = "42576d05d7c94f29af6b93bd0f8b069a"
    /// Channel prefil text to join
    var channel: String
    /// Generate RTC Token at ...
    var rtcToken: String?
    /// Generate Signaling Token at ...
    var signalingToken: String
    /// Mode for encryption, choose from 1-8
    var encryptionMode: Int
    /// RTC encryption salt
    var salt: String
    /// RTC encryption key
    var cipherKey: String
    /// Add Proxy Server URL
    var proxyUrl: String
    /// Add Proxy type from "none", "tcp", "udp"
    var proxyType: String
    /// Add Token Generator URL
    var tokenUrl: String
    /// ID used for screen shares by default
    var screenShareId: UInt
    /// Choose product type from "rtc", "ilr", "voice". See ``RtcProducts``.
    var product: RtcProducts
}

enum RtcProducts: String, CaseIterable, Codable {
    case rtc
    case ils
    case voice
    var description: String {
        switch self {
        case .rtc: return "Video Calling"
        case .ils: return "Interactive Live Streaming"
        case .voice: return "Voice Calling"
        }
    }
}
