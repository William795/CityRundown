//
//  ForecastController.swift
//  CityRundown
//
//  Created by William Moody on 8/20/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import Foundation
import MapKit

class ForecastController {
    
    static let shared = ForecastController()
    private init() {}
    
    // MARK: - Properties
    // DarkSky
    let darkSkyBaseURL = "https://api.darksky.net/forecast"
    let darkSkyAPIKey = "b5cf1b77f2157bd92303e17cb9350b9f"
    // General
    // SSOT
    var forecasts: [Forecast] = []
    
    func getForecastFor(cityName: String, location: CLLocationCoordinate2D, completion: @escaping (Forecast?) -> Void) {
        
        guard var url = URL(string: darkSkyBaseURL) else { completion(nil); return }
        
        url.appendPathComponent(darkSkyAPIKey)
        url.appendPathComponent("\(location.latitude),\(location.longitude)")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let excludeMinutelyQuery = URLQueryItem(name: "exclude", value: "minutely")
        let excludeHourlyQuery = URLQueryItem(name: "exclude", value: "hourly")
        
        components?.queryItems = [excludeMinutelyQuery, excludeHourlyQuery]
        
        guard let finalURL = components?.url else { completion(nil); return }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            print(finalURL)
            if let error = error {
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(nil)
                return
            }
            
            guard let data = data else { completion(nil); return }
            
            do {
                let forecast = try JSONDecoder().decode(Forecast.self, from: data)
                completion(forecast)
            } catch {
                print("Error decoding forecast: \(error.localizedDescription)")
                completion(nil)
                return
            }
            }.resume()
    }
}
