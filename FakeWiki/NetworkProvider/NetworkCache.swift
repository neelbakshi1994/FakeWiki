//
//  NetworkCache.swift
//  FakeWiki
//
//  Created by Neel Bakshi on 25/08/18.
//  Copyright © 2018 Neel Bakshi. All rights reserved.
//

import Foundation

let ResponseCachedAtKey: String = "ResponseCachedAt"

class NetworkCacheConfig {
    let cacheExpiryInterval: TimeInterval
    let memoryCapacity: Int
    let diskCapacity: Int
    let diskPath: String?

    init(withExpiryInterval expiryInterval: TimeInterval? = nil, memCapacity: Int? = nil, diskCapacity: Int? = nil, diskPath: String? = nil) {
        self.cacheExpiryInterval = expiryInterval ?? 0
        self.memoryCapacity = memCapacity ?? 4 * 1024 * 1024
        self.diskCapacity = diskCapacity ?? 50 * 1024 * 1024
        self.diskPath = diskPath
    }
}

class NetworkCache: URLCache {

    private let config: NetworkCacheConfig

    required init(with config: NetworkCacheConfig) {
        self.config = config
        super.init(memoryCapacity: config.memoryCapacity, diskCapacity: config.diskCapacity, diskPath: config.diskPath)
    }

    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for dataTask: URLSessionDataTask) {
        var userInfo = cachedResponse.userInfo ?? [AnyHashable: Any]()
        userInfo[ResponseCachedAtKey] = Date()
        let newCachedResponse = CachedURLResponse(response: cachedResponse.response, data: cachedResponse.data, userInfo: userInfo, storagePolicy: cachedResponse.storagePolicy)
        super.storeCachedResponse(newCachedResponse, for: dataTask)
    }

    override func getCachedResponse(for dataTask: URLSessionDataTask, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        super.getCachedResponse(for: dataTask) { (cachedResponse) in
            //Check if there is a a cached at date,if not then just call the completion handler without any cached response
            guard let cachedAtDate = cachedResponse?.userInfo?[ResponseCachedAtKey] as? Date else {
                completionHandler(nil)
                return
            }
            //Check if the cached response has expired, if it has then remove the cached response and return
            guard Date().timeIntervalSince(cachedAtDate) <= self.config.cacheExpiryInterval else {
                super.removeCachedResponse(for: dataTask)
                completionHandler(nil)
                return
            }
            //if the cached response is still fresh according to our expiry interval then return it.
            completionHandler(cachedResponse)
        }
    }
}
