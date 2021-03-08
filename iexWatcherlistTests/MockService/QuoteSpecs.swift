//
//  QuoteSpecs.swift
//  iexWatcherlistTests
//
//  Created by Xiang Liu on 3/7/21.
//

import XCTest

class QuoteSpecs: XCTestCase {
    
    var api: MockServiceApi!
    
    override func setUpWithError() throws {
        self.api = MockServiceApi()
    }
    
    override func tearDownWithError() throws {
        self.api = nil
    }
    
    func testDecodingQuote() throws {
        let symbol = "twtr"
        self.api.getQuote(with: symbol) { result in
            switch result {
            case .failure(_):
                XCTFail("decode quote errors")
            case .success(let quote):
                XCTAssertEqual(quote.symbol.companyName, "Twitter Inc")
                XCTAssertEqual(quote.askPrice, nil)
                XCTAssertEqual(quote.bidPrice, nil)
                XCTAssertEqual(quote.latestPrice, 66.95)
                XCTAssertNil(quote.symbol.description)
                XCTAssertEqual(quote.symbol.symbol.lowercased(), symbol)
            }
            
        }
    }
    
}
