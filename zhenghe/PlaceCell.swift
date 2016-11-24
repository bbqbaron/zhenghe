//
//  PlaceCell.swift
//  zhenghe
//
//  Created by Eric Loren on 11/23/16.
//  Copyright © 2016 Eric Loren. All rights reserved.
//

import UIKit

// TODO there's naturally a lot we could show here.
// For instance, geonames has codes for location type,
// e.g. "farm" or "populated place"
// so maybe an icon showing said types.
class PlaceCell: UITableViewCell {
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var distance: UILabel!
	@IBOutlet weak var adminDivision: UILabel!
}
