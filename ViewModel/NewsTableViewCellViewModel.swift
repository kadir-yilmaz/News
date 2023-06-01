//
//  NewsTableViewCellViewModel.swift
//  News
//
//  Created by Kadir Yılmaz on 25.05.2023.
//

import Foundation

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data?
    
    init(title: String, subtitle: String, imageURL: URL?, imageData: Data? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.imageData = imageData
    }
}
