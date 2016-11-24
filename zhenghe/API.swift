//
//  API.swift
//  zhenghe
//
//  Created by Eric Loren on 11/23/16.
//  Copyright © 2016 Eric Loren. All rights reserved.
//

import Foundation
import RxSwift

class API {

	let language = Locale.current.languageCode ?? "en"

	internal func doSearch(search: String) -> Observable<[Result]> {
		guard let request = constructRequest(search) else {
			return Observable.just([])
		}

		return URLSession.shared.rx.json(request: request)
			.map { (json: Any) -> [Result] in
				Result.fromJSON(json: json)
			}
	}

	// TODO URL from data, not code!
	internal func constructRequest(_ search: String) -> URLRequest? {
		// TODO the geonames name search doesn't magically resolve combinations of, say, region
		// and place name. it would be good to intelligently split the search string
		// so that a search for "boston ma" would return Boston, which it currently doesn't.

		// TODO there's further sanitization of search strings to be done here,
		// for characters that can URL encode but are nonsense. 
		// e.g., There don't appear to be any places with "!" in their names.
		guard
			let cleaned = search.addingPercentEncoding(withAllowedCharacters: .alphanumerics),
			let url = URL(
				// TODO better to use formal URL construction
				string: "http://api.geonames.org/searchJSON?name=\(cleaned)&username=bbqbaron&maxRows=20&lang=\(language)"
			)
		else {
			print("Unencodable search string: \(search)")
			return nil
		}

		// TODO this is name search only. what if we parallelize searches by name and pure q?
		// wasteful of network resources, probably. perhaps give them an option to control search fields.
		// TODO pagination interface?
		// get 20 rows to save data, assuming that most people will have a relatively specific idea of what they're after
		return URLRequest(url: url)
	}

	// it would be interesting if perhaps too persnickety to optimize away already-empty searches.
	// that is, if i've searched for "floob" and gotten nothing, it's _probably_ the case that
	// "flooba" won't return anything, so why bother?
	// however, it turns out that "Foo L" returns nothing, while "Foo Lake" returns Foo Lake.
	// the search doesn't necessarily behave in the way it would have to to support the idea.
	internal func search(searches: Observable<String>) -> Observable<[Result]> {
		// dispatch new searches a minimum of half a second apart
		return searches
			.sample(Observable<Int>.timer(0, period: 0.5, scheduler: MainScheduler.instance))
			// .flatMapLatest will discard any event emitted by searches that have been superseded. this lovely function even cancels observables that have not emitted by the time they are superseded.
			.flatMapLatest(doSearch)
			.catchError { error in
				print("Search failed")
				print(error)

				return Observable.just([])
			}
	}
}
