//
//  MainViewControllerTests.swift
//  ANF Code TestTests
//
//  Created by Louis on 4/10/25.
//

import XCTest
@testable import ANF_Code_Test

class MainViewControllerTests: XCTestCase {
    var mainVC: MainViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mainVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as? MainViewController
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        mainVC.viewModel.isUsingLocalJson = true
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
