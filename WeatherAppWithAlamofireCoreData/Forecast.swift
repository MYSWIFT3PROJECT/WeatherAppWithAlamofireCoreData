//
//  Forecast.swift
//  WeatherAppKosign
//
//  Created by macOSX on 12/27/16.
//  Copyright © 2016 macOSX. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
class Forecast {
    var _date:String!
    var _weatherType:String!
    var _maxTemp:String!
    var _minTemp:String!
    
    var date:String{
        if _date == nil{
              _date = ""
        }
        return _date
    }
    var weatherType:String{
        if _weatherType == nil{
            _weatherType = ""
        }
        return _weatherType
    }
    var maxTemp:String{
        if _maxTemp == nil{
            _maxTemp = ""
        }
        return _maxTemp
    }
    var minTemp:String{
        if _minTemp == nil{
            _minTemp = ""
        }
        return _minTemp
    }
    init(weatherDict:Dictionary<String, AnyObject>) {
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject> {
            
            if let min = temp["min"] as? Double {
                
                let kelvinToFarenheitPreDivision = (min * (9/5) - 459.67)
                
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                self._minTemp = "\(kelvinToFarenheit)\(" °F")"
            }
            
            if let max = temp["max"] as? Double {
                
                let kelvinToFarenheitPreDivision = (max * (9/5) - 459.67)
                
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                self._maxTemp = "\(kelvinToFarenheit)\(" °F")"
                
            }
            
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "dddd"
            dateFormatter.timeStyle = .none
            self._date  = unixConvertedDate.dayOfTheWeek()
        }
    }
}


extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}





