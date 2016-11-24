//
//  JSON.swift
//  zhenghe
//
//  Created by Eric Loren on 11/23/16.
//  Copyright © 2016 Eric Loren. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol FromJSON {
	init?(json: JSON)
}

extension Result: FromJSON {
	init?(json: JSON) {
		guard
			let name = json["name"].string,
			let lat = Float(json["lat"].string ?? ""),
			let lng = Float(json["lng"].string ?? ""),
			let adminName1 = json["adminName1"].string,
			let countryName = json["countryName"].string
		else {
			return nil
		}

		self.init(adminName1: adminName1, countryName: countryName, name: name, lat: lat, lng: lng)
	}

	static func fromJSON(json: Any) -> [Result] {
		let body = JSON(json)

		guard let places = body["geonames"].array else {
			return []
		}

		return places
			.map { result in Result(json: result) }
			.filter { result in result != nil}
			.map { result in result! }
	}
}
