//
//  LocationWeather.swift
//  Weathear
//
//  Created by Ban Nguyen Ngoc on 8/28/17.
//  Copyright © 2017 xxxxxx. All rights reserved.
//

import Foundation

class LocationWeather {
    
    let city: String
    let country: String
    let region: String
    let condition: ConditionWeather
    
    init?(channelDic: [String: Any]) {
        guard let locationDic = channelDic["location"] as? [String: String],
            let items = channelDic["item"] as? [String: Any],
            let conditionDic = items["condition"] as? [String: String],
            let condition = ConditionWeather(dic: conditionDic) else {
                return nil
        }
        city = locationDic["city"] ?? ""
        country = locationDic["country"] ?? ""
        region = locationDic["region"]?.trimmingCharacters(in: .whitespaces) ?? ""
        self.condition = condition
    }
    
}

class ConditionWeather {
    
    let code: String
    let temp: String
    let text: String
    
    init?(dic: [String: String]) {
        guard let code = dic["code"] else {
            return nil
        }
        self.code = code
        temp = dic["temp"] ?? ""
        text = dic["text"] ?? ""
    }
    
}
