//
//  Location.swift
//  WeatherAppKosign
//
//  Created by macOSX on 12/27/16.
//  Copyright © 2016 macOSX. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
