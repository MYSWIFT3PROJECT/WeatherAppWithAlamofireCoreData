//
//  ViewController.swift
//  WeatherAppKosign
//
//  Created by macOSX on 12/27/16.
//  Copyright © 2016 macOSX. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import MMDrawerController
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate{
    //Header section
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityDescription: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var WeatherDay: UILabel!
    //TableView
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    func updateMainUI() {
        WeatherDay.text = currentWeather.date
     
        cityName.text = currentWeather.cityName
        cityDescription.text = currentWeather.weatherType
        maxTemp.text = "\(currentWeather.currentTemp)"
        cityImage.image = UIImage(named: currentWeather.weatherType)
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
        
    }
    @IBAction func leftSideButton(_ sender: Any) {
        
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        currentWeather = CurrentWeather()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {
                self.downloadForecastData {
                    self.updateMainUI()
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }

    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            print(response.result.value)
            completed()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weathercell", for: indexPath) as? TableViewCell{
        let forecast = forecasts[indexPath.row]
        cell.configureCell(forecast: forecast)
        return cell
            }else{
        return TableViewCell()
    }
}
   
}
