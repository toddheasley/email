// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

extension URLRequest {
    public static func refreshToken(_ refreshToken: String, configuration: OAuth2Configuration) throws -> Self {
        let url: URL = configuration.refreshTokenURL(refreshToken)
        guard let httpBody: Data = url.query(percentEncoded: true)?.data(using: .utf8) else {
            throw URLError(.badURL)
        }
        return .post(httpBody, to: url.deletingQuery())
    }
    
    public static func token(code: String, configuration: OAuth2Configuration, pkce: PKCE) throws -> Self {
        let url: URL = configuration.tokenURL(code: code, pkce: pkce)
        guard let httpBody: Data = url.query(percentEncoded: true)?.data(using: .utf8) else {
            throw URLError(.badURL)
        }
        return .post(httpBody, to: url.deletingQuery())
    }
    
    private static func post(_ httpBody: Data, to url: URL) -> Self {
        var request: Self = Self(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody
        return request
    }
}

private extension URL {
    func deletingQuery() -> Self {
        guard query() != nil, var components: URLComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }
        components.queryItems = nil
        return components.url ?? self
    }
}
