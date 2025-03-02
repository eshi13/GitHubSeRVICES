//
//  PersistenceManager.swift
//  GifFollowers
//
//  Created by Eshita Sharma on 02/03/25.
//

import Foundation

enum PersistenceAction {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favourites = "favourites"
    }
    
    static func retrieveFavourite(completed: @escaping (Result<[Follower], GFErrorMessage>) -> Void) {
        guard let favouritesData = defaults.object(forKey: Keys.favourites) as? Data else {
            completed(.success([]))
            return
        } 
        
        do {
            let decoder = JSONDecoder()
            let followers = try decoder.decode([Follower].self, from: favouritesData)
            completed(.success(followers))
        } catch {
            completed(.failure(.unableToFavourite))
        }
    }
    
    static func saveFavourites(favourites: [Follower]) -> GFErrorMessage? {
        do {
            let encoder = JSONEncoder()
            let encodedFavourite = try encoder.encode(favourites)
            defaults.setValue(encodedFavourite, forKey: Keys.favourites)
            return nil
        } catch {
            return .unableToFavourite
        }
    }
    
    static func updateWith(favourite: Follower, actionType: PersistenceAction, completed: @escaping (GFErrorMessage?) -> Void) {
        retrieveFavourite { result in
           
            switch result {
            case .success(let favourites):
                var retreivedFav = favourites
                switch actionType {
                case .add:
                    guard !retreivedFav.contains(favourite) else {
                        completed(.alreadyfavourite)
                        return
                    }
                    retreivedFav.append(favourite)
                case .remove:
                    retreivedFav.removeAll(where: {
                        $0.login == favourite.login
                    })
                }
                completed(saveFavourites(favourites: retreivedFav))
            case .failure(let error):
                completed(error)
            }
        }
    }
}
