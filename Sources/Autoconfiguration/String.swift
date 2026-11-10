// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

extension String {
    public var host: Self {
        get throws {
            guard let url: URL = URL(string: "http://\(components(separatedBy: "@").last!)"), let host: String = url.host() else {
                throw URLError(.cannotFindHost) // Ensure valid host/domain, then discard `URL`
            }
            return host
        }
    }
    
    public var local: Self {
        get throws {
            guard contains("@") else {
                throw URLError(.cannotFindHost)
            }
            return components(separatedBy: "@").dropLast().joined(separator: "@")
        }
    }
    
    public func query(_ service: Service) throws -> Self {
        "_\(service.rawValue)._tcp.\(try host)"
    }
}
