// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

public struct OAuth2: Decodable {
    public let authURL: URL
    public let tokenURL: URL
    public let scope: [String]
    public let issuer: String
    
    // MARK: Decodable
    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer = try decoder.container(keyedBy: Key.self)
        self.tokenURL = try container.decode(URL.self, forKey: .tokenURL)
        self.authURL = try container.decode(URL.self, forKey: .authURL)
        self.issuer = try container.decode(String.self, forKey: .issuer)
        self.scope = try container.decode(String.self, forKey: .scope).components(separatedBy: " ")
    }
    
    private enum Key: CodingKey {
        case authURL, issuer, scope, tokenURL
    }
}

