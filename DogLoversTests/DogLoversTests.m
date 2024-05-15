//
//  DogLoversTests.m
//  DogLoversTests
//
//  Created by 雨田 on 2024/5/11.
//

#import <XCTest/XCTest.h>
#import "Dog.h"

@interface DogLoversTests : XCTestCase

@end

@implementation DogLoversTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDogDataFetchErrorNil {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Dog data fetch"];

    [[DogManager sharedManager] refreshDogCache:^(NSError *_Nullable error) {
        XCTAssertNil(error, @"Error should be nil");
        XCTAssertGreaterThan([DogManager sharedManager].allDogs.count, 10, @"Dogs count should be greater than 10");
        XCTAssertGreaterThan([DogManager sharedManager].allDogs.lastObject.imageURLs.count, 0, @"Dogs imageURLs count should be greater than 2");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end
