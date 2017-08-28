//
//  TodayViewController.swift
//  TodayWeather
//
//  Created by Ban Nguyen Ngoc on 8/28/17.
//  Copyright © 2017 ban9ban3. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation
import Weathear

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var cityLabel: UILabel?
    @IBOutlet weak var countryLabel: UILabel?
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var temperatureDescriptionLabel: UILabel?
    @IBOutlet weak var weatherImageView: UIImageView!

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
    }

    func searchLocation(coordinate: CLLocationCoordinate2D) {
        NetworkManager.shared.searchWeather(coordinate: coordinate) { [weak self] (isSuccess, location) in
            guard let location = location else {
                return
            }
            self?.cityLabel?.text = location.city
            self?.countryLabel?.text = location.region + ", " + location.country
            self?.temperatureLabel?.text = location.condition.temp + "°F"
            self?.temperatureDescriptionLabel?.text = location.condition.text
            let image = UIImage(named: "vector_weather_icon_\(location.condition.code)") ?? UIImage(named: "vector_weather_icon_41") ?? UIImage()
            self?.weatherImageView.image = image
        }
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
}

extension TodayViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status.rawValue)
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
