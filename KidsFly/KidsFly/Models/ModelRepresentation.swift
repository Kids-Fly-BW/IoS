//
//  ModelRepresentation.swift
//  KidsFly
//
//  Created by Keri Levesque on 3/5/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import Foundation
import UIKit

struct TripRepresentation: Equatable, Codable {
    var identifier: String?
    var airport: String?
    var airline: String?
    var completedStatus: Bool?
    var flightNumber: String?
    var departureTime: Date?
    var childrenQty: Int?
    var carryOnQty: Int?
    var checkedBagQty: Int?
}
