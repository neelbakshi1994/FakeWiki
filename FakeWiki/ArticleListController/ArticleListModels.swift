//
//  ArticleListModels.swift
//  FakeWiki
//
//  Created by Neel Bakshi on 25/08/18.
//  Copyright © 2018 Neel Bakshi. All rights reserved.
//

import Foundation

struct WikiListObjectWrapper: Codable {
    let batchcomplete: Bool?
    let `continue`: WikiContinue?
    let query: WikiQuery?

    enum CodingKeys: String, CodingKey {
        case batchcomplete
        case `continue` = "continue"
        case query
    }
}

struct WikiContinue: Codable {
    let gpsoffset: Int?
    let `continue`: String?

    enum CodingKeys: String, CodingKey {
        case gpsoffset
        case `continue` = "continue"
    }
}

struct WikiQuery: Codable {
    let redirects: [WikiRedirect]?
    let pages: [WikiPage]?
}

struct WikiPage: Codable {
    let pageid, ns: Int?
    let title: String?
    let index: Int?
    let thumbnail: WikiThumbnail?
    let description: String?
}

struct WikiThumbnail: Codable {
    let source: String?
    let width, height: Int?
}

struct WikiRedirect: Codable {
    let index: Int?
    let from, to: String?
}
