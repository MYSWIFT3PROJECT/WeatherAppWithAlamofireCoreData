//
//  TableViewCell.swift
//  WeatherAppKosign
//
//  Created by macOSX on 12/27/16.
//  Copyright © 2016 macOSX. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    //Outletcell
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    func configureCell(forecast: Forecast) {
        minTemp.text = "\(forecast.minTemp)"
        maxTemp.text = "\(forecast.maxTemp)"
        currentTemp.text = forecast.weatherType
        currentImage.image = UIImage(named: forecast.weatherType)
        currentDay.text = forecast.date
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
