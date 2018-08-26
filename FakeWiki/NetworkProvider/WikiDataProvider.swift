//
//  WikiDataProvider.swift
//  FakeWiki
//
//  Created by Neel Bakshi on 25/08/18.
//  Copyright © 2018 Neel Bakshi. All rights reserved.
//

import Alamofire

let WikiListEndpoint = "https://en.wikipedia.org/w/api.php"
let WikiDetailEndpoint = "https://en.m.wikipedia.org/wiki/"

class WikiDataProvider {
    static func getArticlesFor(searchTerm: String, completionSuccess: (([WikiPage]) -> Void)? = nil, completionFailure: CompletionFailureClosure? = nil) {
        let parameters: Parameters = ["action":"query",
                          "format":"json",
                          "prop":"pageimages|description",
                          "generator":"prefixsearch",
                          "redirects":1,
                          "formatversion":2,
                          "piprop":"thumbnail",
                          "pithumbsize":50,
                          "pilimit":10,
                          "wbptterms":"description",
                          "gpssearch":searchTerm,
                          "gpslimit":10]
        NetworkManager.shared.get(urlString: WikiListEndpoint, parameters: parameters, withCompletionSuccess: { (data) in
            guard let listObject = try? JSONDecoder().decode(WikiListObjectWrapper.self, from: data) else {
                completionFailure?(.dataParseFailure)
                return
            }
            guard let articles = listObject.query?.pages else {
                completionFailure?(.noData)
                return
            }
            completionSuccess?(articles)
        }, andCompletionFailure: completionFailure)
    }
}
