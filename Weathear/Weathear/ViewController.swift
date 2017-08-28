//
//  ViewController.swift
//  Weathear
//
//  Created by Ban Nguyen Ngoc on 8/28/17.
//  Copyright © 2017 ban9ban3. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func searchLocation(coordinate: CLLocationCoordinate2D) {
        NetworkManager.shared.searchWeather(coordinate: coordinate) { (isSuccess, location) in
            guard let location = location else {
                return
            }
            print(location.city + " " + location.condition.temp + " " + location.condition.text)
            print("\n")
        }
    }

}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestCoordinate = locations.last?.coordinate else {
            return
        }
        searchLocation(coordinate: latestCoordinate)
    }

}
