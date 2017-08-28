//
//  LocationWeather.swift
//  Weathear
//
//  Created by Ban Nguyen Ngoc on 8/28/17.
//  Copyright © 2017 ban9ban3. All rights reserved.
//

import Foundation

public class LocationWeather {

    public let city: String
    public let country: String
    public let region: String
    public let condition: ConditionWeather

    public init?(channelDic: [String: Any]) {
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

public class ConditionWeather {

    public let code: String
    public let temp: String
    public let text: String

    public init?(dic: [String: String]) {
        guard let code = dic["code"] else {
            return nil
        }
        self.code = code
        temp = dic["temp"] ?? ""
        text = dic["text"] ?? ""
    }

}
