//
//  File.swift
//  
//
//  Created by SathyaKrishna on 21/09/21.
//

import Foundation


let fayvEnvironment: FayvEnvironment = .staging
let locale = Locale.current
let region = locale.regionCode ?? ""

/// Fayvit Environment properties
public enum FayvEnvironment: CaseIterable {
    case development
    case staging
    case production
    
    var baseUrl: String {
        let regionCode = Region(rawValue: region)
        switch regionCode {
        case .IN:
            switch self {
            case .development: return "https://dev.myfayvit.com/"
            case .staging: return "https://stgin.myfayvit.com/"
            case .production: return "https://stgin.myfayvit.com/"
            }
        default:
            switch self {
            case .development: return "https://dev.myfayvit.com/"
            case .staging: return "https://stg.myfayvit.com/"
            case .production: return "https://stg.myfayvit.com/"
            }
        }
    }
    
    var subdomain: String {
        let regionCode = Region(rawValue: region)
        switch regionCode {
        case .IN:
            switch self {
            case .development: return "dev"
            case .staging: return "stgin"
            case .production: return "stgin"
            }
        default:
            switch self {
            case .development: return "dev"
            case .staging: return "stg"
            case .production: return "stg"
            }
        }
    }
    
    var fetchLimit: Int { return 10 }
}

enum Region: String {
    case IN
}

extension FayvEnvironment {
    static func runOnDebug(run: () -> Void) {
        #if DEBUG
        run()
        #endif
    }
}
