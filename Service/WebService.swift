//
//  APICaller.swift
//  News
//
//  Created by Kadir Yılmaz on 25.05.2023.
//

import Foundation

final class WebService {
    
    static let shared = WebService()
    private init() {}
    
    struct Constants {
        
        static let topHeadingURL = URL(string: "https://newsapi.org/v2/top-headlines?country=US&apiKey=73957d545ac54072b5101718949b7c52")
        
        static let economyURL = URL(string: "https://newsapi.org/v2/everything?q=finance&apiKey=73957d545ac54072b5101718949b7c52")
        
        static let bitcoinURL = URL(string: "https://newsapi.org/v2/everything?q=bitcoin&apiKey=73957d545ac54072b5101718949b7c52")
        
        
        static let scienceURL = URL(string: "https://newsapi.org/v2/everything?q=science&apiKey=73957d545ac54072b5101718949b7c52")
        
        static let healthURL = URL(string: "https://newsapi.org/v2/everything?q=health&apiKey=73957d545ac54072b5101718949b7c52")
        
        static let sportURL = URL(string: "https://newsapi.org/v2/everything?q=sport&apiKey=73957d545ac54072b5101718949b7c52")
        
        static let travelURL = URL(string: "https://newsapi.org/v2/everything?q=travel&apiKey=73957d545ac54072b5101718949b7c52")
        
        static let worldURL = URL(string: "https://newsapi.org/v2/everything?q=world&apiKey=73957d545ac54072b5101718949b7c52")
    }
    
    public func getTopStories(for topic: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        var url: URL?
        
        switch topic {
        case "Top":
            url = Constants.topHeadingURL
        case "Economy":
            url = Constants.economyURL
        case "Bitcoin":
            url = Constants.bitcoinURL
        case "Science":
            url = Constants.scienceURL
        case "Health":
            url = Constants.healthURL
        case "Sport":
            url = Constants.sportURL
        case "Travel":
            url = Constants.travelURL
        case "World":
            url = Constants.worldURL
        default:
            break
        }
        
        guard let apiUrl = url else {
            let error = NSError(domain: "Invalid URL", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: apiUrl) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }

}
