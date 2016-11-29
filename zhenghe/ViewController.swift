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
import CoreLocation

// TODO maybe a map interface? it kind of depends on whether this is meant to just search
// for anything anywhere, or nearby places of interest
class ViewController: UITableViewController {

	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var searching: UIActivityIndicatorView!

	// TODO this should be dependency-injected to better enable testing. Use protocols for abstraction :-)
    let api: API = LiveAPI()
    // Assuming you were using AliSoftware/Dip you could have
    // singleton container 'dip' configured at startup
    // and do something like
    // let api: API = try! dip.resolve()
    // Use of ! is not ideal though, you could make it optional
    // let api = (try? dip.resolve() as API)
    // and then code controller to display suitable message if api == nil
    
    
	let disposeBag = DisposeBag()

	func makePlaceCell(source: TableViewSectionedDataSource<SectionModel<String, Result>>, table: UITableView, indexPath: IndexPath, result: Result) -> UITableViewCell! {
		// force-casting makes me twitch, but research suggests that this is just what
		// you do without writing an extension of UITableView. do you know a better way?

		let cell = table.dequeueReusableCell(withIdentifier: PlaceCell.identifier, for: indexPath) as! PlaceCell // swiftlint:disable:this force_cast


        // Use some object to separate result model from cell. Ideally though you'd want to move this association
        // out of the VC - have a VM that returns array of cell view models rather than model (Result) instances.
        
        cell.bind(result: CellViewModel(result: result))
        
		return cell
	}

	override func viewDidLoad() {
		super.viewDidLoad()

        self.navigationItem.titleView = textField
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searching)
        
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
                // This whould ideally be moved out to separate
                // 'presenter' layer that has observer of search string
                // and provides observable of SectionModel thus
                // separating api from UI
                
				// there's only one section
				[
					SectionModel(
						model: "",
						// Closure here should probably moved into separate function
						items: results.sorted { first, second in
							// ick, sorry; there's really no reason the distance should be nullable from
							// call to call.
                            
                            (CLLocation(latitude: CLLocationDegrees(first.lat), longitude: CLLocationDegrees(first.lng)).distanceFromCurrentLocation ?? 0) <
                            (CLLocation(latitude: CLLocationDegrees(second.lat), longitude: CLLocationDegrees(second.lng)).distanceFromCurrentLocation ?? 0)
                        }
					)
				]
			// ensure main-thread dispatch of UI updates!
			}.asDriver(onErrorJustReturn: [])

		searchResults
			.map { _ in false }
			.drive(searching.rx.isAnimating)
			.addDisposableTo(disposeBag)

		searchResults
			.drive(tableView.rx.items(dataSource: dataSource))
			.addDisposableTo(disposeBag)
	}

}
