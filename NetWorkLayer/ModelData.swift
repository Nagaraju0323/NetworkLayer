//
//  ModelData.swift
//  NetWorkLayer
//
//  Created by Nagaraju on 04/07/23.
//

import Foundation
//struct Languges: Codable {
//    let data: [Datum]
//    let meta: Meta
//}

//// MARK: - Datum
struct Datum: Codable,Equatable {
    let langID, langName, langCode, orientation: String
    let statusID: String

    enum CodingKeys: String, CodingKey {
        case langID = "lang_id"
        case langName = "lang_name"
        case langCode = "lang_code"
        case orientation = "orientation"
        case statusID = "status_id"
    }
    
    var DatumItems:Datum{
        return Datum(langID: langID, langName:langName , langCode: langCode, orientation: orientation, statusID: statusID)
    }
}

//// MARK: - Meta
struct Meta: Codable {
    let status, message: String
}

//
//struct Languges: Codable {
//    let firstName, lastName: String
//    let subjectID, id: Int
//
//    enum CodingKeys: String, CodingKey {
//        case firstName = "first name"
//        case lastName = "last name"
//        case subjectID = "subjectId"
//        case id
//    }
//}

//
////
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
//struct Meta: Codable {
//    let status, message: String
//}



// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

//// MARK: - Welcome
//struct Languges: Codable {
//    let quotes: Quotes
//    let meta: Meta
//}
//
//// MARK: - Meta
//struct Meta: Codable {
//    let status, currentPage, perPage, message: String
//
//    enum CodingKeys: String, CodingKey {
//        case status
//        case currentPage = "current_page"
//        case perPage = "per_page"
//        case message
//    }
//}
//
//// MARK: - Quotes
//struct Quotes: Codable {
//    let totalQuotes: Int
//    let quotes: [Quote]
//
//    enum CodingKeys: String, CodingKey {
//        case totalQuotes = "total_quotes"
//        case quotes
//    }
//}
//
//// MARK: - Quote
//struct Quote: Codable {
//    let quotesID, authorName, quoteDesc, createdAt: String
//    let statusID: String
//
//    enum CodingKeys: String, CodingKey {
//        case quotesID = "quotes_id"
//        case authorName = "author_name"
//        case quoteDesc = "quote_desc"
//        case createdAt = "created_at"
//        case statusID = "status_id"
//    }
//}


struct Languges: Codable {
    let tokenType, accessToken: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
}
