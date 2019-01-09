//
//  MasterFaceTests.swift
//  MasterFaceTests
//
//  Created by Сергей Кротких on 07/01/2019.
//  Copyright © 2019 Сергей Кротких. All rights reserved.
//

import XCTest
//@testable import VideoViewModel

class MasterFaceTests: XCTestCase {

    class override func setUp() {
        print("The static setup method performed before all tests!")
        //let vv = VideoViewModel()
    }

    class override func tearDown() {
        print("The instance setup method performed after all test!")
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    override func setUp() {
        print("The instance setup method performed before test!")
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        print("The instance setup method performed after test!")
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
