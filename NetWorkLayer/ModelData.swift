//
//  ModelData.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 04/07/23.
//

import Foundation
struct Languges: Codable {
    let data: [Datum]
    let meta: Meta
}

//// MARK: - Datum
struct Datum: Codable {
    let langID, langName, langCode, orientation: String
    let statusID: String

    enum CodingKeys: String, CodingKey {
        case langID = "lang_id"
        case langName = "lang_name"
        case langCode = "lang_code"
        case orientation
        case statusID = "status_id"
    }
}

//// MARK: - Meta
//// MARK: - Welcome
//struct Languges: Codable {
//    let data: [Datum]
//    let meta: Meta
//}
//
//// MARK: - Datum
//struct Datum: Codable {
//    let userID, elementID, isLiked, likes: String
//
//    enum CodingKeys: String, CodingKey {
//        case userID = "user_id"
//        case elementID = "element_id"
//        case isLiked = "is_liked"
//        case likes
//    }
//}
//
//// MARK: - Meta
struct Meta: Codable {
    let status, message: String
}

