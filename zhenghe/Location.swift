//
//  Location.swift
//  zhenghe
//
//  Created by Eric Loren on 11/23/16.
//  Copyright © 2016 Eric Loren. All rights reserved.
//

import CoreLocation

class Location {

	struct Unit {
		let fromMeters: Double
		let label: String
	}

	static let manager = CLLocationManager()
	static let units: Unit = Locale.current.usesMetricSystem ?
		Unit(fromMeters: 0.001, label: "km") :
		Unit(fromMeters: 0.000621371, label: "mi")

	// XXX the simulator needs to be told to simulate a location in order to return anything, so for simplicity I've provided a fallback.
	// Naturally, a real user may not have provided location permissions,
	// but I wanted to let a local tester see it without mucking around too much.
	// Hence, the optional return type.
	static func getCurrent() -> CLLocation? {
		return manager.location ??
			CLLocation(
				latitude: CLLocationDegrees(43), longitude: CLLocationDegrees(-71)
			)
	}

	static func distanceString(_ meters: Double) -> String {
		let inUnits = round(100 * meters * units.fromMeters) / 100

		return "\(inUnits) \(units.label)"
	}

	static func distanceFrom(lat: Float, lng: Float) -> String {
		guard let distance: Double = metersFrom(lat: lat, lng: lng) else {
			return ""
		}

		return distanceString(distance)
	}

	static func metersFrom(lat: Float, lng: Float) -> Double? {
		guard let current = getCurrent() else {
			return nil
		}

		let other = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))

		return current.distance(from: other)
	}
}
