//
//  Memory.h
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import <Foundation/Foundation.h>
#import "Dog.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MemoryCardStatus) {
    MemoryCardStatusForget,
    MemoryCardStatusWrong,
    MemoryCardStatusCorrect,
};

@interface MemoryCard : NSObject <NSCopying, NSSecureCoding>

@property (nonatomic, copy, readonly) Dog *dog;
@property (nonatomic, copy, readonly) NSString *imageURL;
@property (nonatomic, copy, readonly) NSArray<DogBreed *> *options;
@property (nonatomic, copy, readonly) DogBreed *correctOption;
@property (nonatomic, assign, readonly) MemoryCardStatus status;

+ (instancetype)cardWithDog:(Dog *)dog;

@end

@interface Memory : NSObject

// OPT: Implementation code of Ebbinghaus memory curve

@property (nonatomic, assign, readonly) NSUInteger totalCountToRemember;
@property (nonatomic, assign, readonly) NSUInteger currentCountRemembered;

@property (nonatomic, assign, readonly) NSUInteger todayCountToRemember;
@property (nonatomic, assign, readonly) NSUInteger todayCountRemembered;

+ (instancetype)sharedMemory;

- (void)updateMemoryWithCard:(MemoryCard *)card statue:(MemoryCardStatus)status;

- (NSArray<MemoryCard *> *)unfinishedCardsWithCount:(NSUInteger)count;

- (void)resetAllProgress;

@end

NS_ASSUME_NONNULL_END
