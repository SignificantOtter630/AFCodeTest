//
//  CustomCardTests.swift
//  ANF Code TestTests
//
//  Created by Louis on 4/11/25.
//

import XCTest
@testable import ANF_Code_Test

class CustomCardTests: XCTestCase {
    var mockServiceManager = MockServiceManager()
    var customCard = CustomCard()
    var customCardVM: CustomCardViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let mockDataModel = DataModel(
            title: "titleString",
            backgroundImage: "backgroundImageString",
            content: nil,
            promoMessage: "promoMessageString",
            topDescription: "topDesriptionString",
            bottomDescription: "bottomDescriptionString"
        )
        let mockLocalDataModel = LocalDataModel(from: mockDataModel)
        customCardVM = CustomCardViewModel(dataModel: mockLocalDataModel, serviceManager: mockServiceManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWillFetchImage() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        customCardVM.fetchImage { _ in
            XCTAssert(self.mockServiceManager.didfetchImageModel)
        }
    }
    
    func testWillGrabLocalImageIfItExists() throws {
        let mockDataModel = DataModel(title: "", backgroundImage: "anf-20160527-app-m-shirts.jpg", content: nil, promoMessage: "", topDescription: "", bottomDescription: "")
        let mockLocalDataModel = LocalDataModel(from: mockDataModel)
        // check that LocalDataModel grabs the local image automatically
        XCTAssert(mockLocalDataModel.backgroundImage != nil)
    }
}
