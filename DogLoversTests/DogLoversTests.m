//
//  DogLoversTests.m
//  DogLoversTests
//
//  Created by 雨田 on 2024/5/11.
//

#import <XCTest/XCTest.h>
#import "Dog.h"
#import "Memory.h"

@interface DogLoversTests : XCTestCase

@end

@implementation DogLoversTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[Memory sharedMemory] resetAllProgress];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [[Memory sharedMemory] resetAllProgress];
}

- (void)testDogDataFetchErrorNil {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Dog data fetch"];

    [[DogManager sharedManager] refreshDogCache:^(NSError *_Nullable error) {
        XCTAssertNil(error, @"Error should be nil");
        XCTAssertGreaterThan([DogManager sharedManager].allDogs.count, 10, @"Dogs count should be greater than 10");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testMemoryCardAllSaveOnToday {
    [self prefetchDogData];
    
    DogManager *dogManager = [DogManager sharedManager];
    Memory *memory = [Memory sharedMemory];
    [[Memory sharedMemory] resetAllProgress];

    XCTAssertEqual(memory.totalCountToRemember, dogManager.allDogs.count);
    XCTAssertEqual(memory.currentCountRemembered, 0);
    XCTAssertEqual(memory.todayCountToRemember, 10);
    XCTAssertEqual(memory.todayCountRemembered, 0);
    
    NSArray<MemoryCard *> *cards = [memory unfinishedCardsWithCount:10];
    for (MemoryCard *card in cards) {
        [memory updateMemoryWithCard:card statue:MemoryCardStatusCorrect];
    }
    
    XCTAssertEqual(memory.currentCountRemembered, 10);
    XCTAssertEqual(memory.todayCountToRemember, 0);
    XCTAssertEqual(memory.todayCountRemembered, 10);
}

- (void)testMemoryCard {
    
    [self prefetchDogData];
    
    DogManager *dogManager = [DogManager sharedManager];
    Memory *memory = [Memory sharedMemory];
    XCTAssertEqual(memory.totalCountToRemember, dogManager.allDogs.count);
    XCTAssertEqual(memory.currentCountRemembered, 0);
    XCTAssertEqual(memory.todayCountToRemember, 10);
    XCTAssertEqual(memory.todayCountRemembered, 0);
    
    NSArray<MemoryCard *> *cards = [memory unfinishedCardsWithCount:2];
    MemoryCard *card1 = cards.firstObject;
    MemoryCard *card2 = cards.lastObject;
    
    XCTAssertEqual(card1.options.count, 4);

    NSUInteger correctOption = 0;
    for (DogBreed *option in card1.options) {
        if ([option isEqual:card1.correctOption]) {
            correctOption += 1;
        }
    }
    XCTAssertEqual(correctOption, 1);
    
    [memory updateMemoryWithCard:card1 statue:MemoryCardStatusCorrect];
    [memory updateMemoryWithCard:card2 statue:MemoryCardStatusWrong];

    XCTAssertEqual(memory.totalCountToRemember, dogManager.allDogs.count);
    XCTAssertEqual(memory.currentCountRemembered, 1);
    XCTAssertEqual(memory.todayCountToRemember, 9);
    XCTAssertEqual(memory.todayCountRemembered, 1);
    
    [memory updateMemoryWithCard:card2 statue:MemoryCardStatusCorrect];
    XCTAssertEqual(memory.totalCountToRemember, dogManager.allDogs.count);
    XCTAssertEqual(memory.currentCountRemembered, 2);
    XCTAssertEqual(memory.todayCountToRemember, 8);
    XCTAssertEqual(memory.todayCountRemembered, 2);
}

- (void)prefetchDogData {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);

    [[DogManager sharedManager] refreshDogCache:^(NSError *error) {
        if (error) {
            NSLog(@"Error fetching data: %@", error);
        }

        dispatch_group_leave(group);
    }];

    // wait DogManager fetch all data for 3 seconds
    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)));
}

@end
