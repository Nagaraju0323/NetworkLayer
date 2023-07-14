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

// MARK: - Datum
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

// MARK: - Meta
struct Meta: Codable {
    let status, message: String
}
