//
//  YelpController.swift
//  CityRundown
//
//  Created by William Moody on 8/15/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import UIKit

class YelpController {
    
    static let shared = YelpController()
    
    var businesses: [Business] = []
    
    func fetchPlaceYelp(WithLocation: String, completion: @escaping ([Business]?) -> ()) {
        
        
        guard let baseUrl = URL(string: "https://api.yelp.com/v3/businesses/search") else {return}
        
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        
        let locationQuerry = URLQueryItem(name: "location", value: WithLocation)
        let limitQuerry = URLQueryItem(name: "limit", value: "30")
        components?.queryItems = [locationQuerry, limitQuerry]
        guard let componentsUrl = components?.url else {return}
        
        var request = URLRequest(url: componentsUrl)
        
        request.httpMethod = "GET"
        request.addValue("Bearer DWP4GlwmouY1gzyM1tNStYB4PXVCekH_oPaeCuJwCzU1pIHCFST29tHFhtiws2q4TDmWK2N_W3uwF7cLjVTBmwnIoQ4TdN9Mmdxp71RS-Abp3TW5yF3l8wClXfkHXXYx", forHTTPHeaderField: "Authorization")
        
        print(request)
        URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
            if let error = error {
                print("error in datatask🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                return
            }
            guard let data = data else {return}
            
            do {
                let businessResults = try JSONDecoder().decode(YelpData.self, from: data)
                completion(businessResults.businesses)
            } catch {
                print(error.localizedDescription)
                return
            }
            }.resume()
    }
    
    func fetchYelpBusinessImage(business: Business, completion: @escaping ((UIImage?) -> Void)) {
        guard let finalUrl = URL(string: business.image_url ?? "") else {return}
        
        URLSession.shared.dataTask(with: finalUrl) { (data, _, error) in
            if let error = error {
                print("error in yelp inage fetch🚒🚒🚒🚒🚒\(error.localizedDescription) \(error) in function: \(#function)🚒🚒🚒🚒🚒")
                completion(nil)
                return
            }
            guard let data = data else {return}
            
            let image = UIImage(data: data)
            completion(image)
            }.resume()
    }
}
