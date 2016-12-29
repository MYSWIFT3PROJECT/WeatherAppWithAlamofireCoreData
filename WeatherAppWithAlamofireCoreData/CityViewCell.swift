//
//  CityViewCell.swift
//  WeatherAppKosign
//
//  Created by iMac on 12/28/16.
//  Copyright © 2016 macOSX. All rights reserved.
//

import UIKit

class CityViewCell: UITableViewCell {

    
    @IBOutlet weak var cityName: UILabel!
    
    func configureCell(city: City){
        print("City: ", city.name)
        cityName.text = city.name
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
