//
//  File.swift
//  
//
//  Created by SathyaKrishna on 21/09/21.
//

import Foundation

import Foundation

enum QueryParam: String {
    case search
    case fields
    case offset
    case limit
}

public class URLFactory {
    
    static let shared = URLFactory()
    
    init() {}
    
    /// Generate Fayvit URL String for provided endpoint
    /// - Parameters:
    ///   - endpoint: Enpoint of the request
    ///   - parameters: Request parameters of the request
    ///   - pathVariable: Path variable of the request
    ///   - version: API version
    ///   - query: Preset query parameters like search, fields & pagination
    /// - Returns: Fayvit URL string for the provided paramters
    func url(
        endpoint: String,
        query: [QueryParam: String] = [.limit: String(fayvEnvironment.fetchLimit)],
        parameters: [String: String] = [:],
        pathVariable: String = "",
        version: Int = 1
    ) -> String {
        let url = buildBaseUrl(for: version) + endpoint
        return buildPathVariable(for: url, with: pathVariable) + queryParamsOf(query, parameters)
    }
}

extension URLFactory {
    public func buildBaseUrl(for version: Int) -> String {
//        return Urls.base + String(format: Urls.version, version)
        return Urls.init(base: , version: <#T##String#>, fayvEnvironment: <#T##String#>)
    }

    private func buildPathVariable(for url: String, with pathVariable: String) -> String {
        return pathVariable.isEmpty ? "\(url)" : "\(url)\(pathVariable)/"
    }

    private func queryParamsOf(_ query: [QueryParam: String], _ parameters: [String: String]) -> String {
        var queryParams = [String]()
        for (key, value) in query {
            queryParams.append("\(key)=\(value)")
        }
        for (key, value) in parameters {
            queryParams.append("\(key)=\(value)")
        }
        guard !queryParams.isEmpty else {
            return ""
        }
        return "?\(queryParams.joined(separator: "&"))"
    }
}
