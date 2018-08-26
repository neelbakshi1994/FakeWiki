//
//  NetworkManager.swift
//  FakeWiki
//
//  Created by Neel Bakshi on 25/08/18.
//  Copyright © 2018 Neel Bakshi. All rights reserved.
//

import UIKit
import Alamofire

typealias CompletionSuccessClosure = ((Data) -> Void)
typealias CompletionFailureClosure = ((NetworkError) -> Void)

enum NetworkError: Error {
    case noInternet
    case badRequest
    case noData
    case parameterParsingFailed
    case notFound
    case somethingWentWrong
    case dataParseFailure

    var localizedDescription: String {
        switch self {
        case .noInternet :
            return "NO INTERNET"
        case .badRequest:
            return "BAD REQUEST"
        case .noData:
            return "NO DATA"
        case .notFound:
            return "URL not found"
        case .somethingWentWrong:
            return "SOMETHING WENT WRONG"
        case .parameterParsingFailed:
            return "Could not parse parameters"
        case .dataParseFailure:
            return "Could not parse response data"
        }
    }
}

class NetworkManager: SessionManager {

    static let shared = NetworkManager()
    private let networkReachabilityManager = NetworkReachabilityManager()

    private init() {
        let networkCacheConfig = NetworkCacheConfig(withExpiryInterval: 3600)
        let networkCache = NetworkCache(with: networkCacheConfig)
        URLCache.shared = networkCache
        super.init()
    }

    func get(urlString: String, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, withCompletionSuccess success:CompletionSuccessClosure? = nil, andCompletionFailure failure: CompletionFailureClosure? = nil) {
        return self.performRequest(withMethod: .get, urlString: urlString, withParameters: parameters, headers: headers, withCompletionSuccess: success, andCompletionFailure: failure)
    }

    private func performRequest(withMethod method: HTTPMethod, urlString: String, withParameters params: Parameters?, headers: HTTPHeaders?, withCompletionSuccess success:CompletionSuccessClosure? = nil, andCompletionFailure failure: CompletionFailureClosure? = nil) {
        self.request(urlString, method: method, parameters: params, encoding: URLEncoding.default, headers: headers).responseData {[weak self] (response) in
            switch response.result {
            case .success(let data):
                success?(data)
            case .failure:
                guard self?.networkReachabilityManager?.isReachable == true else {
                    failure?(.noInternet)
                    return
                }
                switch response.response?.statusCode {
                case 400:
                    failure?(.badRequest)
                case 404:
                    failure?(.notFound)
                default:
                    failure?(.somethingWentWrong)
                }
            }
        }
    }

}
