//
//  WeatherData.swift
//  Clima
//
//  Created by Diogo Henriques on 24/11/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

struct WeatherData: Decodable {
    let coord: Coordinates?
    let weather: [Weather?]
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: [String: Int]?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
}

struct Coordinates: Decodable {
    let lon: Double?
    let lat: Double?
}

struct Weather: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Decodable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let pressure: Double?
    let humidity: Double?
    let sea_level: Double?
    let grnd_level: Double?
}

struct Wind: Decodable {
    let speed: Double?
    let deg: Double?
    let gust: Double?
}

struct Clouds: Decodable {
    let all: Int?
}

struct Sys: Decodable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}


//    "coord":{
//        "lon":-0.1257,
//        "lat":51.5085

//    },
//    "weather":[
//        {
//            "id":803,
//            "main":"Clouds",
//            "description":"broken clouds",
//            "icon":"04d"
//        }
//    ],
//    "base":"stations",
//    "main":{
//        "temp":6.98,
//        "feels_like":5.46,
//        "temp_min":6.42,
//        "temp_max":7.75,
//        "pressure":991,
//        "humidity":89,
//        "sea_level":991,
//        "grnd_level":987
//    },
//    "visibility":10000,
//    "wind":{
//        "speed":2.24,
//        "deg":44,
//        "gust":3.58
//    },
//    "clouds":{
//        "all":75
//    },
//    "dt":1763989881,
//    "sys":{
//        "type":2,
//        "id":2075535,
//        "country":"GB",
//        "sunrise":1763969622,
//        "sunset":1764000067
//    },
//    "timezone":0,
//    "id":2643743,
//    "name":"London",
//    "cod":200
//
