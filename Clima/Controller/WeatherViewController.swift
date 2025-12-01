//
//  WeatherManager.swift
//  Clima
//
//  Created by Diogo Henriques on 24/11/2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchInputField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var closedWithtap: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInputField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

//MARK: - UITextField Delegate

extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchInputField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchInputField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // Allow ending editing if closed via background tap
        if closedWithtap { return true }
        
        if let text = textField.text, !text.isEmpty {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if closedWithtap { return }
        // Use searchInputField to get the weather for the city.
        if let city = searchInputField.text {
            weatherManager.fetchWeather(city: city)
        }
        
        searchInputField.text = ""
    }
}

//MARK: - Weather Manager Delegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.condition)
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            print(error)
            self.temperatureLabel.text = "Try Again"
            self.cityLabel.text = "Unable to fetch weather."
        }
    }
}

// MARK: - Location Manager Delegate

extension WeatherViewController: CLLocationManagerDelegate {
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            locationManager.stopUpdatingLocation()
            if #available(iOS 26.0, *) {
                
                if let request = MKReverseGeocodingRequest(location: lastLocation) {
                    request.getMapItems { mapItems, error in
                        if let error = error {
                            print("Error: \(error)")
                            return
                        }
                        
                        guard let firstItem = mapItems?.first else {
                            print("No map items returned.")
                            return
                        }

                        let placemark = firstItem.placemark
                        if let city = placemark.locality {
                            self.weatherManager.fetchWeather(city: city)
                        } else if let title = placemark.title {
                            // Fallback: Try parsing from title or use as-is
                            self.weatherManager.fetchWeather(city: title)
                        } else {
                            print("Could not extract a city from MKPlacemark.")
                        }
                    }
                }
            } else {
                // Fallback on earlier versions
                
                let geocoder = CLGeocoder()
                
                geocoder.reverseGeocodeLocation(lastLocation) { (placemarks, error) in
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }
                    
                    if let placemark = placemarks?.first, let city = placemark.locality {
                        self.weatherManager.fetchWeather(city: city)
                    }
                }//
            }
        }
        
        print(locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}


// MARK: - UIViewController

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        // Mark that dismissal was initiated by a background tap if applicable
        if let weatherVC = self as? WeatherViewController {
            weatherVC.closedWithtap = true
        }
        view.endEditing(true)
        
        // Reset the flag shortly after to avoid affecting future interactions
        if let weatherVC = self as? WeatherViewController {
            DispatchQueue.main.async { weatherVC.closedWithtap = false }
        }
    }
}
