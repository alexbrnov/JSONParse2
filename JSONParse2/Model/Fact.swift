//
//  Fact.swift
//  JSONParse2
//
//  Created by Alexandr Baranov on 12.11.2023.
//

import Foundation

struct CatFact: Codable {
    struct Status: Codable {
        let verified: Bool?
        let sentCount: Int?
    }
    let status: Status?
    let _id: String?
    let user: String?
    let text: String?
    let __v: Int?
    let source: String?
    let updatedAt: String?
    let type: String?
    let createdAt: String?
    let deleted: Bool?
    let used: Bool?
  
}
