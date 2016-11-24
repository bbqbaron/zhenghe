//
//  zhengheTests.swift
//  zhengheTests
//
//  Created by Eric Loren on 11/23/16.
//  Copyright © 2016 Eric Loren. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftyJSON
import XCTest

@testable import zhenghe

class APITest: XCTestCase {

	func searchAny(search: String) {
		let expect = expectation(description: "search \(search)")

		API().search(searches: Observable.just(search)).subscribe(onNext: { json in
			expect.fulfill()
		})

		waitForExpectations(timeout: 20)
	}

	func testSearch() {
		searchAny(search: "foo")
	}

	func testPeopleDontOnlyUseLetters() {
		searchAny(search: "let's explore!")
	}

	func testUTF8() {
		searchAny(search: "上海在哪里")
	}

	func testParseJSON() {
		let json: JSON = ["name": "foo", "lat": "2342.234", "lng": "4234.1231123", "adminName1": "bartown", "countryName": "bazlandia"]

		let result = Result(json: json)

		XCTAssertEqual("foo", result?.name)
		XCTAssertEqual(2342.234, result?.lat)
		XCTAssertEqual(4234.1231123, result?.lng)
		XCTAssertEqual("bartown", result?.adminName1)
		XCTAssertEqual("bazlandia", result?.countryName)
	}

	func testParseRealResults() {
		let expect = expectation(description: "nonempty results")

		API().search(searches: Observable.just("foo")).subscribe(onNext: {
				results in

				XCTAssertGreaterThan(results.count, 0)

				expect.fulfill()
		})

		waitForExpectations(timeout: 20)
	}

}
