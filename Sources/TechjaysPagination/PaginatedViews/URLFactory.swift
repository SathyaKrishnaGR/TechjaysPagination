//
//  URLFactory.swift
//  TechjaysAPIHelper
//
//  Created by Sathya on 10/24/21.
//  Copyright © 2021 Techjays. All rights reserved.
//

import Foundation

public enum QueryParam: String {
    case search
    case fields
    case offset
    case limit
}

 public class URLFactory {
    
    public static let shared = URLFactory()
     public var baseUrl: String = ""
     public var version: String = ""
    
    public init() {}
    
    /// Generate TechjaysAPIHelper URL String for provided endpoint
    /// - Parameters:
    ///   - endpoint: Enpoint of the request
    ///   - parameters: Request parameters of the request
    ///   - pathVariable: Path variable of the request
    ///   - version: API version
    ///   - query: Preset query parameters like search, fields & pagination
    /// - Returns: TechjaysAPIHelper URL string for the provided paramters
    public func url(
        endpoint: String,
        query: [QueryParam: String] = [.limit: String("10")],
        parameters: [String: String] = [:],
        pathVariable: String = "",
        version: String = "1"
    ) -> String {
        let url = buildBaseUrl(baseUrl: self.baseUrl, version: self.version) + endpoint
        return buildPathVariable(for: url, with: pathVariable) + queryParamsOf(query, parameters)
    }
     public func url(
         endpoint: String,
         parameters: [String: String] = [:],
         pathVariable: String = "",
         version: String = "1"
     ) -> String {
         let url = buildBaseUrl(baseUrl: self.baseUrl, version: self.version) + endpoint
         return buildPathVariable(for: url, with: pathVariable)
     }
}

extension URLFactory {
    public func buildBaseUrl(baseUrl: String, version: String) -> String {
        return baseUrl + version
    }

    public func buildPathVariable(for url: String, with pathVariable: String) -> String {
        return pathVariable.isEmpty ? "\(url)" : "\(url)\(pathVariable)/"
    }

    public func queryParamsOf(_ query: [QueryParam: String], _ parameters: [String: String]) -> String {
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
