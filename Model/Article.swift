//
//  Article.swift
//  News
//
//  Created by Kadir Yılmaz on 25.05.2023.
//

import Foundation

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

