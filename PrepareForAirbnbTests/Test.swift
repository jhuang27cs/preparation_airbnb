//
//  Test.swift
//  PrepareForAirbnbTests
//
//  Created by Jie Huang on 2023/10/11.
//

import XCTest

final class Test: XCTestCase {

    func fetchDataFromNetwork(completion: @escaping (String) -> Void) {
            DispatchQueue.global().async {
                // Simulate a network request
                Thread.sleep(forTimeInterval: 2) // Simulate a delay
                
                let data = "Hello, world!"
                
                DispatchQueue.main.async {
                    completion(data)
                }
            }
        }
        
        func testAsyncNetworkRequest() {
            let expectation = XCTestExpectation(description: "Network Request Expectation")
            
            fetchDataFromNetwork { data in
                // This closure is called when the asynchronous operation is completed.
                XCTAssertEqual(data, "Hello, world!")
                expectation.fulfill()
            }
            
            // Wait for the expectation to be fulfilled, or timeout after a specified time.
            wait(for: [expectation], timeout: 5.0)
        }
}
