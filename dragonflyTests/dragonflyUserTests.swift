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

class dragonflyUserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuth() {

        let expectation = expectationWithDescription("testAuth")
        
        ApiUserClient().auth("marco.furiatti@hotmart.com.br", password: "111111", callback: { (response) in
           
            XCTAssertTrue(response.success)
            expectation.fulfill()

        })
        
        waitForExpectationsWithTimeout(Constants.Api.kTimeout) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testMe() {
        
        let expectation = expectationWithDescription("testMe")
        
        ApiUserClient().me { (user, response) in
          
            XCTAssertNotNil(user, "Deve retornar o objeto")
            XCTAssertTrue(response.success, "Não deve retornar erro")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(Constants.Api.kTimeout) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testSignUp() {
        
        let expectation = expectationWithDescription("testSignUp")
        
        let user: User = User()
        
        user.password = "pwdpwd"
        user.name = "name"
        user.email = "email\(NSDate().timeIntervalSince1970 * 1000)@email.com"
        
        ApiUserClient().signUp(user) { (response) in
            
            XCTAssertTrue(response.success, "Não deve retornar erro")
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(Constants.Api.kTimeout) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testCheckEmail() {
        
        let expectation = expectationWithDescription("testCheckEmail")
        
        ApiUserClient().checkEmail("email\(NSDate().timeIntervalSince1970 * 1000)@email.com", callback: { (response) in
          
            XCTAssertTrue(response.httpCode == .httpNotFound404, "Não deve retornar erro")
            expectation.fulfill()
        })
        
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
