/*
 * This file is part of Zum.
 * 
 * Zum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Zum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Zum. If not, see <http://www.gnu.org/licenses/>.
 */

import XCTest
@testable import dragonfly

class dragonflyAddressTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testList() {
        
        let expectation = expectationWithDescription("testList")
        
        ApiAddressClient().list(1, rows: 22) { (addressData, response) in
            
            addressData?.data
            XCTAssertTrue(response.success)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(Constants.Api.kTimeout) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testNew() {
        
        let expectation = expectationWithDescription("testNew")
        
        let address = Address()
        
        address.label = "nome\(NSDate().timeIntervalSince1970 * 1000)"
        address.latitude = 19.9330183
        address.longitude = 43.936921
        address.city = "Belo Horizonte"
        address.zipCode = "30130174"
        address.state = "Minas Gerais"
        address.address = "Rua Sergipe"
        address.country = "Brasil"
        address.number = "1014"
        
        ApiAddressClient().new(address) { (response) in
            
            XCTAssertTrue(response.success)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(Constants.Api.kTimeout) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetAddress() {
        
        let expectation = expectationWithDescription("testGetAddress")
        
        ApiAddressClient().getAddress(60) { (addressData, response) in
            addressData?.data
            XCTAssertTrue(response.success)
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(Constants.Api.kTimeout) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
}
