// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

public struct OAuth2Configuration: CaseIterable, Codable, Equatable, Hashable, Sendable {
    public let authURI: String
    public let tokenURI: String
    public let redirectURI: String
    public let responseType: String
    public let scope: [String]
    public let hosts: [String]
    public let clientID: String
    
    public func authURL(hint: String? = nil, pkce: PKCE) -> URL {
        var components: URLComponents = URLComponents(string: authURI)!  // Validated during init
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: responseType),
            URLQueryItem(name: "scope", value: scope.joined(separator: " ")),
            URLQueryItem(name: "code_challenge", value: pkce.codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "S256")
        ]
        if let hint, !hint.isEmpty {  // Prepopulate email address for specific user
            components.queryItems?.append(URLQueryItem(name: "login_hint", value: hint))
        }
        return components.url!
    }
    
    public func refreshTokenURL(_ refreshToken: String) -> URL {
        var components: URLComponents = URLComponents(string: tokenURI)!  // Validated during init
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: ""),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        return components.url!
    }

    public func tokenURL(code: String, pkce: PKCE) -> URL {
        var components: URLComponents = URLComponents(string: tokenURI)!  // Validated during init
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: ""),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "code_verifier", value: pkce.codeVerifier)
        ]
        return components.url!
    }

    public func matches(_ host: String) -> Bool {
        for _host in hosts {
            guard host.hasSuffix(_host) else { continue }
            return true
        }
        return false
    }

    public init(authURI: String, tokenURI: String, redirectURI: String, responseType: String, scope: [String], clientID: String, hosts: [String]) throws {
        guard URL(string: authURI) != nil, URL(string: tokenURI) != nil,  // Validate URI strings pass failable URL init
            !redirectURI.isEmpty, !scope.isEmpty, !(scope.first ?? "").isEmpty, !clientID.isEmpty else {
            throw URLError(.badURL)
        }
        self.authURI = authURI
        self.tokenURI = tokenURI
        self.redirectURI = redirectURI
        self.responseType = responseType
        self.scope = scope
        self.hosts = hosts
        self.clientID = clientID
    }
    
    // MARK: CaseIterable
    nonisolated(unsafe) public static var allCases: [Self] = []
}
