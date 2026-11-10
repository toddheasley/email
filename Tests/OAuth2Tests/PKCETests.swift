// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

@testable import OAuth2
import Foundation
import Testing

struct PKCETests {
    @Test func randomInit() {
        let pkce: PKCE = PKCE()
        #expect(pkce.codeVerifier.unicodeScalars.allSatisfy { CharacterSet.pkce.contains($0) })
        #expect(pkce.codeVerifier.count == 43)
    }
    
    @Test func codeVerifierInit() {
        #expect(PKCE(codeVerifier: "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk").codeChallenge == "E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM")
    }
}

private extension CharacterSet {
    static let pkce: Self = Self(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
}

/*
@Test func authURLIncludesPKCEChallenge() throws {
    let configuration: OAuth2.Configuration = try OAuth2.Configuration(
        authURI: "https://example.com/authorize",
        tokenURI: "https://example.com/token",
        redirectURI: "com.example:/oauth2redirect",
        responseType: "code",
        scope: [
            "mail-w"
        ],
        clientID: "Cl13n+-ID"
    )
    let pkce = OAuth2.PKCE(codeVerifier: "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk")
    let queryItems = URLComponents(
        url: configuration.authURL(hint: "user@example.com", pkce: pkce),
        resolvingAgainstBaseURL: false
    )?.queryItems

    #expect(queryItems?.first(where: { $0.name == "code_challenge" })?.value == pkce.codeChallenge)
    #expect(queryItems?.first(where: { $0.name == "code_challenge_method" })?.value == "S256")
    #expect(queryItems?.first(where: { $0.name == "login_hint" })?.value == "user@example.com")
} */
