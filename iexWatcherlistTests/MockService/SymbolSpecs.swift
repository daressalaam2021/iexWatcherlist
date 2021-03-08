//
//  SymbolSpecs.swift
//  iexWatcherlistTests
//
//  Created by Xiang Liu on 3/7/21.
//

import XCTest

class SymbolSpecs: XCTestCase {
    
    var api: MockServiceApi!
    
    override func setUpWithError() throws {
        self.api = MockServiceApi()
    }
    
    override func tearDown() {
        self.api = nil
    }
    
    func testDecodingSymbols() throws {
        self.api.getSymbols(with: "appl") { result in
            switch result {
            case .failure(_):
                XCTFail("decode symbols error")
            case .success(let symbols):
                XCTAssertEqual(symbols.count, 10)
                XCTAssertEqual(symbols.first!.symbol, "APLE")
                XCTAssertNil(symbols.first!.companyName)
                XCTAssertNotEqual(symbols.first!.description, "")
            }
        }
    }
    
}
