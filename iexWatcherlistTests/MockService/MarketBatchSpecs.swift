//
//  MarketBatchSpecs.swift
//  iexWatcherlistTests
//
//  Created by Xiang Liu on 3/7/21.
//

import XCTest

class MarketBatchSpecs: XCTestCase {
    
    var api: MockServiceApi!

    override func setUpWithError() throws {
        self.api = MockServiceApi()
    }

    override func tearDownWithError() throws {
        self.api = nil
    }

    func testDecodingMarketBatch() throws {
        let symbols: Set<String> = ["GGN", "GGG"]
        self.api.getQuotes(with: symbols, type: .all) { result in
            switch result {
            case .failure(_):
                XCTFail("decode market batch fail")
            case .success(let batches):
                XCTAssertEqual(batches.count, 2)
                XCTAssertEqual(batches.first!.quote.askPrice, nil)
                XCTAssertEqual(batches.first!.quote.bidPrice, nil)
                XCTAssertEqual(batches.first!.quote.latestPrice, 66.31)
                XCTAssertNil(batches.first!.quote.symbol.description)
                XCTAssert(symbols.contains(batches.first!.quote.symbol.symbol))
                /// History Price
                XCTAssertEqual(batches.first!.historyPrices.count, 19)
                XCTAssertEqual(batches.first!.historyPrices.first!.high, 73.21)
                XCTAssertEqual(batches.first!.historyPrices.first!.low, 71.83)
                XCTAssertNotEqual(batches.first!.historyPrices.first!.date, Date())
            }
            
        }
        
    }
}
