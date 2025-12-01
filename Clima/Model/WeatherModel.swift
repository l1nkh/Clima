//
//  WeatherModel.swift
//  Clima
//
//  Created by Diogo Henriques on 24/11/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

struct WeatherModel{
    let cityName: String
    let temperature: Double
    let weatherId: Int
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    } 
    
    var condition: String {
        switch weatherId {
        case 200...232: // Thunderstorm
            return "cloud.bolt.rain"
        case 300...321: // Drizzle Rain
            return "cloud.drizzle"
        case 500...531: // Rain
            return "cloud.rain"
        case 600...622: // Snow
            return "snowflake"
        case 701...781: // Mist/Ash/Dust
            return "smoke"
        case 800: // Clear Sky
            return "sun.max"
        case 801...804: // Cloudy
            return "cloud"
        default:
            return "sun.max" // Defaults to sun
        }
    }
}
