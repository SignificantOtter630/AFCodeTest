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
    var mockServiceManager = MockServiceManager()
    var mainVM: MainViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mainVM = MainViewModel(isUsingLocalJson: true, serviceManager: MockServiceManager())
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainVC = storyboard.instantiateViewController(identifier: "Main") { coder in
            return MainViewController(coder: coder)
        }
        
        mainVC.viewModel = mainVM
        mainVC.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCanFetchLocalData() throws {
        XCTAssert(mainVM.localDataModels != nil)
        XCTAssert(mainVC.viewModel.localDataModels.count == 10)
        
    }
    
    func testWillFetchData() throws {
        mainVM.isUsingLocalJson = false
        mainVM.startFetchingData {
            XCTAssert(self.mockServiceManager.didFetchDataModel)
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockServiceManager: ServiceProtocol {
    var didfetchImageModel = false
    func fetchImage(imageString: String, completion: @escaping (UIImage?) -> Void) {
        didfetchImageModel = true
    }
    
    var didFetchDataModel = false
    func fetchDataModel(completion: @escaping ([LocalDataModel]) -> ()) {
        didFetchDataModel = true
    }
}
