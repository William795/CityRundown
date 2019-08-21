//
//  Forecast.swift
//  CityRundown
//
//  Created by William Moody on 8/19/19.
//  Copyright © 2019 William Moody. All rights reserved.
//

import Foundation
import MapKit

// MARK: - Forecast
struct Forecast: Codable {
    let daily: Daily
}

// MARK: - Daily
struct Daily: Codable {
    let data: [DailyData]
}

// MARK: - Daily Forecast Data
struct DailyData: Codable {
    let summary: String
    let precipProbability: Double
    let temperatureHigh: Double
    let temperatureLow: Double
}

extension Forecast {
    init?(dictionary: [String:Any]) {
        
        let dailyDataOne = DailyData(summary: dictionary["todayForecastSummary"] as! String, precipProbability: dictionary["todayForecastRainChance"] as! Double, temperatureHigh: dictionary["todayForecastHighTemp"] as! Double, temperatureLow: dictionary["todayForecastLowTemp"] as! Double)
        let dailyDataTwo = DailyData(summary: dictionary["tomorrowForecastSummary"] as! String, precipProbability: dictionary["tomorrowForecastRainChance"] as! Double, temperatureHigh: dictionary["tomorrowForecastHighTemp"] as! Double, temperatureLow: dictionary["tomorrowForecastLowTemp"] as! Double)
        let dailyDataThree = DailyData(summary: dictionary["dayAfterTomorrowForecastSummary"] as! String, precipProbability: dictionary["dayAfterTomorrowForecastRainChance"] as! Double, temperatureHigh: dictionary["dayAfterTomorrowForecastHighTemp"] as! Double, temperatureLow: dictionary["dayAfterTomorrowForecastLowTemp"] as! Double)
        let daily = Daily(data: [dailyDataOne, dailyDataTwo, dailyDataThree])
        self.init(daily: daily)
    }
}
