//
//  TodayViewController.swift
//  TodayWeather
//
//  Created by Ban Nguyen Ngoc on 8/28/17.
//  Copyright © 2017 xxxxxx. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureDescriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
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
            self?.weatherImageView?.image = image
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
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
