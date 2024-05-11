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

@interface MemoryCard : NSObject

@property (nonatomic, copy, readonly) Dog *dog;
@property (nonatomic, copy, readonly) NSString *imageURL;
@property (nonatomic, copy, readonly) NSArray<DogBreed *> *options;
@property (nonatomic, copy, readonly) DogBreed *correctOption;
@property (nonatomic, assign, readonly) MemoryCardStatus status;

+ (instancetype)cardWithDog:(Dog *)dog;

@end

@interface Memory : NSObject

// TODO: 2024-05-11 艾宾浩斯记忆曲线的实现代码

@property (nonatomic, assign, readonly) NSUInteger totalCountToRemember;
@property (nonatomic, assign, readonly) NSUInteger currentCountRemembered;
@property (nonatomic, strong, readonly) NSDate *finishDate;

+ (instancetype)sharedMemory;

// update memory status with card and status
// return err if not success
- (NSError *)updateMemoryWithCard:(MemoryCard *)card statue:(MemoryCardStatus)status;

// return random cards with count
- (NSArray<MemoryCard *> *)randomCardsWithCount:(NSUInteger)count;

// return today remembered count based on pervious memory status
- (NSUInteger)todayRememberedCount;

// OPT: configure finshed date to memory; currently set to next 30 days after open this application
- (void)configureFinishedDate:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
