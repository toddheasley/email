// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

public struct TokenResponse: Decodable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresIn: Double
    
    // MARK: Decodable
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        refreshToken = try container.decode(String.self, forKey: .refreshToken)
        expiresIn = try container.decode(Double.self, forKey: .expiresIn)
    }
}

public struct RefreshTokenResponse: Decodable {
    public let accessToken: String
    public let expiresIn: Double
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        accessToken = try container.decode(String.self, forKey: .accessToken)
        expiresIn = try container.decode(Double.self, forKey: .expiresIn)
    }
}

private enum Key: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case expiresIn = "expires_in"
}
