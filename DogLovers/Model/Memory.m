//
//  Memory.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "Memory.h"

@interface MemoryCard ()

@property (nonatomic, copy) Dog *dog;

@end

@implementation MemoryCard

+ (nonnull instancetype)cardWithDog:(nonnull Dog *)dog {
    MemoryCard *card = [[MemoryCard alloc] init];
    card.dog = dog;
    return card;
}

- (NSString *)getImageURL {
    return self.dog.imageURLs.firstObject;
}

@end

@interface Memory ()

@property (nonatomic, assign) NSUInteger totalCountToRemember;
@property (nonatomic, assign) NSUInteger currentCountRemembered;
@property (nonatomic, strong) NSDate *finishDate;

@end

@implementation Memory

+ (nonnull instancetype)sharedMemory {
    static Memory *sharedMemory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMemory = [[self alloc] init];
    });
    return sharedMemory;
}

- (nonnull NSArray<MemoryCard *> *)randomCardsWithCount:(NSUInteger)count {
    return nil;
}

- (nonnull NSError *)updateMemoryWithCard:(nonnull MemoryCard *)card statue:(MemoryCardStatus)status {
    return nil;
}

- (NSUInteger)todayRememberedCount {
    return 0;
}

- (void)configureFinishedDate:(nonnull NSDate *)date {
    self.finishDate = date;
}

@end
