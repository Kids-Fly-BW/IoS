//
//  TripTableViewCell.swift
//  KidsFly
//
//  Created by Keri Levesque on 3/5/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {

    //MARK: Properties
    var trip: Trip? {
        didSet {
            updateViews()
        }
    }
    //MARK: Outlets
    @IBOutlet weak var airlineLabel: UILabel!
    @IBOutlet weak var airportLabel: UILabel!
    @IBOutlet weak var kidsLabel: UILabel!
    @IBOutlet weak var flightLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func updateViews() {
        guard let trip = trip else { return }
        
        airlineLabel.text = trip.airline
        airportLabel.text = trip.airport
        kidsLabel.text = String(trip.childrenQty)
        flightLabel.text = trip.flightNumber
    }
}
