//
//  TestUI.swift
//  PrepareForAirbnbUITests
//
//  Created by Jie Huang on 2023/10/11.
//

import XCTest

final class TestUI: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        let searchSearchField = app.searchFields["Search"]
        searchSearchField.tap()
        app/*@START_MENU_TOKEN@*/.keyboards.keys["A"]/*[[".keyboards.keys[\"A\"]",".keys[\"A\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.tap()
        app.keyboards.keys["s"].tap()
        XCUIApplication()/*@START_MENU_TOKEN@*/.keyboards.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[2,0]]@END_MENU_TOKEN@*/.tap()
        let cellLabel = app.tables.cells.staticTexts["Asian Flank Steak"]
        let cellLabel1 = app.tables.cells.staticTexts["Texas Flank Steak"]
        XCTAssertTrue(cellLabel.exists)
        XCTAssertFalse(cellLabel1.exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
