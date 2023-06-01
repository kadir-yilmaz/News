//
//  NewsViewModel.swift
//  News
//
//  Created by Kadir Yılmaz on 1.06.2023.
//

import Foundation

class NewsViewModel {
    private let menuTitles = ["Top", "Economy", "Bitcoin", "Science", "Health", "Sport", "Travel", "World"]
    
    func getMenuTitles() -> [String] {
        return menuTitles
    }
    
}
