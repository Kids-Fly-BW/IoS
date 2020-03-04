//
//  ModelRepresentations.swift
//  KidsFly
//
//  Created by Keri Levesque on 3/4/20.
//  Copyright © 2020 Keri Levesque. All rights reserved.
//

import Foundation

struct TripRepresentation: Equatable, Codable {
    var identifier: String?
    var airport: String?
    var airline: String?
    var flight: String?
    var childrenQty: Int?
    var carryOnQty: Int?
    var checkedBagQty: Int?
}
