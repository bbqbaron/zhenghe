//
//  Result.swift
//  zhenghe
//
//  Created by Eric Loren on 11/23/16.
//  Copyright © 2016 Eric Loren. All rights reserved.
//

import Foundation
import SwiftyJSON

// Abstract result data
protocol Result {
    var adminName1: String { get }
    var countryName: String { get }
    var name: String { get }
    var lat: Float { get }
    var lng: Float { get }
}

// Implementation that loads from JSON, we could have others
// that read from XML, CoreData etc.
struct JsonResult: Result {
	let adminName1: String
	let countryName: String
	let name: String
	let lat: Float
	let lng: Float

    init?(json: JSON) {
        guard
            // TODO: Extract these string constants, wrap in enum?
            let name = json["name"].string,
            let lat = Float(json["lat"].string ?? ""),
            let lng = Float(json["lng"].string ?? ""),
            let adminName1 = json["adminName1"].string,
            let countryName = json["countryName"].string
            else {
                return nil
            }
        self.adminName1 = adminName1
        self.countryName = countryName
        self.name = name
        self.lat = lat
        self.lng = lng
    }
}
