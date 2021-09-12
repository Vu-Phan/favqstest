//
//  CLLocation+Extension.swift
//  PiorridgeLibrary
//
//  Created by Vu Phan on 28/08/2019.
//

import UIKit
import CoreLocation

public extension CLLocation {
	func pr_midPoint(to: CLLocation) -> CLLocation {
		let fromCoord = self.coordinate
		let toCoord = to.coordinate
		let fromLat = Double.pi * fromCoord.latitude / 180.0
		let fromLong = Double.pi * fromCoord.longitude / 180.0
		let toLat = Double.pi * toCoord.latitude / 180.0
		let toLong = Double.pi * toCoord.longitude / 180.0

		// Formula
		//    Bx = cos φ2 ⋅ cos Δλ
		//    By = cos φ2 ⋅ sin Δλ
		//    φm = atan2( sin φ1 + sin φ2, √(cos φ1 + Bx)² + By² )
		//    λm = λ1 + atan2(By, cos(φ1)+Bx)
		// Source: http://www.movable-type.co.uk/scripts/latlong.html

		let bxLoc = cos(toLat) * cos(toLong - fromLong)
		let byLoc = cos(toLat) * sin(toLong - fromLong)
		let mlat = atan2(sin(fromLat) + sin(toLat),
						 sqrt((cos(fromLat) + bxLoc) * (cos(fromLat) + bxLoc) + (byLoc * byLoc)))
		let mlong = (fromLong) + atan2(byLoc,
									   cos(fromLat) + bxLoc)

		return CLLocation(latitude: (mlat * 180 / Double.pi), longitude: (mlong * 180 / Double.pi))
	}

	func pr_bearing(to destination: CLLocation) -> Double {
		// http://stackoverflow.com/questions/3925942/cllocation-category-for-calculating-bearing-w-haversine-function
		let lat1 = Double.pi * self.coordinate.latitude / 180.0
		let long1 = Double.pi * self.coordinate.longitude / 180.0
		let lat2 = Double.pi * destination.coordinate.latitude / 180.0
		let long2 = Double.pi * destination.coordinate.longitude / 180.0

		// Formula: θ = atan2( sin Δλ ⋅ cos φ2 , cos φ1 ⋅ sin φ2 − sin φ1 ⋅ cos φ2 ⋅ cos Δλ )
		// Source: http://www.movable-type.co.uk/scripts/latlong.html

		let rads = atan2(
			sin(long2 - long1) * cos(lat2),
			cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(long2 - long1))
		let degrees = rads * 180 / Double.pi

		return (degrees+360).truncatingRemainder(dividingBy: 360)
	}
}
