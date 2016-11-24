//
//  LocationTest.swift
//  zhenghe
//
//  Created by Eric Loren on 11/23/16.
//  Copyright © 2016 Eric Loren. All rights reserved.
//

import CoreLocation
import Foundation
import XCTest

class LocationTest: XCTestCase {

	func makeLoc(_ lat: Float, lng: Float) -> CLLocation {
		return CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
	}

	func testSamePlace() {
		let location = makeLoc(40, lng: -70)

		XCTAssertEqual(
			location.distance(from: location),
			0
		)
	}

	func testMiles() {
		let portland = makeLoc(43.663988, lng: -70.257314)
		let boston = makeLoc(42.360278, lng: -71.060110)

		XCTAssertEqual(
			Location.distanceString(portland.distance(from: boston)),
			"98.76 mi"
		)
	}
}
