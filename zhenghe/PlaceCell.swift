//
//  PlaceCell.swift
//  zhenghe
//
//  Created by Eric Loren on 11/23/16.
//  Copyright © 2016 Eric Loren. All rights reserved.
//

import UIKit
import CoreLocation

// Abstraction of cell data
protocol CellViewModelType {
    var name: String { get }
    var distance: String? { get }
}

// Implementation for Result
struct CellViewModel: CellViewModelType {

    let result: Result

    var name: String {
        return [result.name, result.adminName1, result.countryName]
            .filter { x in x != "" }
            .joined(separator: ", ")
    }

    var distance: String? {
        return CLLocation(latitude: CLLocationDegrees(result.lat),
                          longitude: CLLocationDegrees(result.lng))
            .distanceFromCurrentLocation?.asDistanceString
    }
}

protocol Identifier {
    static var identifier: String { get }
}

// TODO there's naturally a lot we could show here.
// For instance, geonames has codes for location type,
// e.g. "farm" or "populated place"
// so maybe an icon showing said types.
class PlaceCell: UITableViewCell {
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var distance: UILabel!
	@IBOutlet weak var adminDivision: UILabel!

    func bind(result: CellViewModelType) {

        self.textLabel?.text = result.name
        self.detailTextLabel?.text = result.distance
    }
}

extension PlaceCell: Identifier {
    static var identifier: String {
        return "PlaceCell"
    }
}
