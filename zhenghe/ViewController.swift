//
//  ViewController.swift
//  zhenghe
//
//  Created by Eric Loren on 11/23/16.
//  Copyright © 2016 Eric Loren. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// TODO maybe a map interface? it kind of depends on whether this is meant to just search
// for anything anywhere, or nearby places of interest
class ViewController: UIViewController {

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var searching: UIActivityIndicatorView!

	// TODO this should be dependency-injected to better enable testing
	let api = API()
	let disposeBag = DisposeBag()

	func makePlaceCell(source: TableViewSectionedDataSource<SectionModel<String, Result>>, table: UITableView, indexPath: IndexPath, result: Result) -> UITableViewCell! {
		// force-casting makes me twitch, but research suggests that this is just what
		// you do without writing an extension of UITableView. do you know a better way?

		let cell = table.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as! PlaceCell // swiftlint:disable:this force_cast

		cell.name.text = [result.name, result.adminName1, result.countryName]
			.filter { x in x != "" }
			.joined(separator: ", ")

		cell.distance.text = nil

		// WTB really good optional mapping syntax; I'm a Haskeller in private life : /
		cell.distance.text = Location.distanceFrom(lat: result.lat, lng: result.lng)

		return cell
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let textEvents = textField.rx.text.asObservable()
			.filter { x in x != nil && x != "" }
			.map { x in x! }

		let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Result>>()

		dataSource.configureCell = { source, table, indexPath, result in
			self.makePlaceCell(source: source, table: table, indexPath: indexPath, result: result)
		}

		// Separation of concerns is interesting here. I've chosen to have the VC tell itself that it requested a search, not make the API tell it when one's in progress. The timing isn't dead-on, though.
		textEvents
			.map { _ in true }
			.bindTo(searching.rx.isAnimating)
			.addDisposableTo(disposeBag)

		// TODO it would be good to have an attractive empty view here
		let searchResults = api.search(
				searches: textEvents
			).map { results in
				// there's only one section
				[
					SectionModel(
						model: "",
						items: results.sorted { first, second in
							// ick, sorry; there's really no reason the distance should be nullable from
							// call to call.
							(Location.metersFrom(lat: first.lat, lng: first.lng) ?? 0)
							< (Location.metersFrom(lat: second.lat, lng: second.lng) ?? 0)
						}
					)
				]
			// ensure main-thread dispatch of UI updates!
			}.observeOn(MainScheduler.instance)

		searchResults
			.map { _ in false }
			.bindTo(searching.rx.isAnimating)
			.addDisposableTo(disposeBag)

		searchResults
			.bindTo(tableView.rx.items(dataSource: dataSource))
			.addDisposableTo(disposeBag)
	}

}

