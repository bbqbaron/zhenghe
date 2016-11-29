//
//  Location.swift
//  zhenghe
//
//  Created by Eric Loren on 11/23/16.
//  Copyright © 2016 Eric Loren. All rights reserved.
//

import CoreLocation
import MapKit

// Abstraction of a location service (this is simplistic for now
// but just to demo principle)
protocol LocationManager {

    var location: CLLocation? { get }

}

// CLLocationManager conforms to our abstraction of location service
extension CLLocationManager: LocationManager {}

// Mock implementation for testing etc
struct MockLocationManager: LocationManager {
    
    let location: CLLocation? = CLLocation(
        latitude: CLLocationDegrees(43), longitude: CLLocationDegrees(-71)
    )

}

// Extend CLLocationDistance to provide formatted
// string of value
extension CLLocationDistance {

    // Configure a distance formatter, use static 
    // shared instance
    static let distanceFormatter: MKDistanceFormatter = {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        return formatter
    }()

    // Use formatter to get string
    var asDistanceString: String {
        return CLLocationDistance.distanceFormatter.string(fromDistance: self)
    }
}

// Extend CLLocation to provide distance from users
// current location
extension CLLocation {

    var distanceFromCurrentLocation: CLLocationDistance? {
        guard let current = Location.getCurrent() else {
			return nil
		}

		return current.distance(from: self)
    }
}

class Location {

    // Abstract location manager so we can use DI to configure alternative location
    // providers - for now just use mock implementation from above
    static let manager: LocationManager = MockLocationManager()

	static func getCurrent() -> CLLocation? {
		return manager.location
    }

}
