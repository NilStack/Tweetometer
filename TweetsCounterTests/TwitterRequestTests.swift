//
//  TweetsCounterTests.swift
//  TweetsCounterTests
//
//  Created by Patrick Balestra on 10/19/15.
//  Copyright © 2015 Patrick Balestra. All rights reserved.
//

@testable import TweetsCounter
import XCTest
import TwitterKit
import OHHTTPStubs

class TwitterRequestTests: XCTestCase {
    
    let userData = UserData()
    let timelineViewModel = TimelineViewModel()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoadUserProfileSuccessfully() {
        
        let expectation = expectationWithDescription("Receive profile information successfully.")
        
        _ = timelineViewModel.requestProfileInformation()
            .subscribe(onNext: { user in
                XCTAssertNotNil(user)
                XCTAssertEqual(user.userID, self.userData.userID)
                XCTAssertEqual(user.name, self.userData.name)
                XCTAssertEqual(user.screenName, self.userData.screenName)
                expectation.fulfill()
                }, onError: { error in
                    XCTFail("Failed in requesting the profile information with error: \(error)")
                }, onCompleted: nil, onDisposed: nil)
        
        waitForExpectationsWithTimeout(10.0) { error in
            XCTAssertNil(error, "Failed expectation \(expectation) with error \(error)")
        }
    }
    
    func testLoadUserProfileFailed() {
        stub(isHost(TwitterEndpoints().timeline.host)) { _ in
            let stubData = "Hello World!".dataUsingEncoding(NSUTF8StringEncoding)
            return OHHTTPStubsResponse(data: stubData!, statusCode:200, headers:nil)
        }
    }
}
