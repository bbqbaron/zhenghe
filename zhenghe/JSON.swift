//
//  JSON.swift
//  zhenghe
//
//  Created by Eric Loren on 11/23/16.
//  Copyright © 2016 Eric Loren. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JsonResult {

    static func fromJSON(json: Any) -> [Result] {
		let body = JSON(json)

        // TODO: Move string constant out to enum
		guard let places = body["geonames"].array else {
			return []
		}

		return places
			.map { result in JsonResult(json: result) }
            // Neater, flatMap unwraps optionals and drops nil
            .flatMap { $0 }
//			.filter { result in result != nil}
//			.map { result in result! }
	}
}
