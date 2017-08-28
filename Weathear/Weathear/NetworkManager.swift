//
//  NetworkManager.swift
//  Weathear
//
//  Created by Ban Nguyen Ngoc on 8/28/17.
//  Copyright © 2017 ban9ban3. All rights reserved.
//

import Foundation
import CoreLocation

public class NetworkManager {

    public static let shared = NetworkManager()

    fileprivate typealias ResponseHandle = (_ isSuccess: Bool, _ result: Any?, _ error: Error?) -> Void

    private init() {}

    public func searchWeather(coordinate: CLLocationCoordinate2D, completion: ((Bool, LocationWeather?) -> Void)?) {
        let query = "select * from weather.forecast where woeid in (SELECT woeid FROM geo.places WHERE text=\"(\(coordinate.latitude),\(coordinate.longitude))\")"
        callAPI(query: query) { (isSuccess, result, error) in
            if isSuccess {
                guard let result = result as? [String: Any],
                        let query = result["query"] as? [String: Any],
                        let results = query["results"] as? [String: Any],
                        let channel = results["channel"] as? [String: Any],
                        let location = LocationWeather(channelDic: channel) else {
                    completion?(false, nil)
                    return
                }
                completion?(true, location)
            } else {
                completion?(false,nil)
            }
        }
    }

    fileprivate func callAPI(query: String, completion: ResponseHandle?) {
        let baseURL = "https://query.yahooapis.com/v1/public/yql?format=json"
        var fullURL = baseURL + "&q=\(query)"
        fullURL = fullURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: fullURL) {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                var result: Any? = nil
                do {
                    if let data = data {
                        result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    }
                } catch let err {
                    print("JSONSerialization error: \(err)")
                }
                DispatchQueue.main.async {
                    completion?(error == nil, result, error)
                }
            })
            task.resume()
        } else {
            completion?(false, nil, nil)
        }
    }

}
