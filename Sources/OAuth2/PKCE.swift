// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import CryptoKit

public struct PKCE: Equatable, Sendable {
    public let codeChallenge: String
    public let codeVerifier: String
    
    public init() {
        var generator: SystemRandomNumberGenerator = SystemRandomNumberGenerator()
        let bytes: [UInt8] = (0..<32).map { _ in
            UInt8.random(in: UInt8.min...UInt8.max, using: &generator)
        }
        self.init(codeVerifier: Data(bytes).base64URLEncodedString())
    }
    
    init(codeVerifier: String) {
        self.codeChallenge = Data(SHA256.hash(data: Data(codeVerifier.utf8))).base64URLEncodedString()
        self.codeVerifier = codeVerifier
    }
}

private extension Data {
    func base64URLEncodedString() -> String {
        base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
