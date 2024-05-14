//
//  Memory.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "Memory.h"
#import <SDWebImage/SDWebImage.h>

@interface MemoryCard ()

@property (nonatomic, copy) Dog *dog;

@end

@implementation MemoryCard

+ (nonnull instancetype)cardWithDog:(nonnull Dog *)dog {
    MemoryCard *card = [[MemoryCard alloc] init];
    card.dog = dog;
    return card;
}

- (NSString *)imageURL {
    return self.dog.imageURLs.firstObject;
}

- (NSArray<DogBreed *> *)options {
    // TODO: random gen four options
    NSMutableArray<DogBreed *> *options = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        DogBreed *option = [DogBreed new];
        option.name = [NSString stringWithFormat:@"Option %d", i + 1];
        option.subBreed = [NSString stringWithFormat:@"SubOption %d", i + 1];
        [options addObject:option];
    }
    return [options copy];
}

@end

@interface Memory ()

@property (nonatomic, assign) NSUInteger totalCountToRemember;
@property (nonatomic, assign) NSUInteger currentCountRemembered;

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

- (nonnull NSArray<MemoryCard *> *)unfinishedCardsWithCount:(NSUInteger)count {

    // TODO: Mock
    NSMutableArray<MemoryCard *> *cards = [NSMutableArray array];

    NSArray<NSString *> *totalImages = @[
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_1007.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_1007.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4420.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4426.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4434.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4450.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4464.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4467.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4497.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4501.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4511.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4517.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4521.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4583.jpg",
        @"https://images.dog.ceo/breeds/hound-afghan/n02088094_4586.jpg",
    ];
    
    for (int i = 0; i < count; i++) {
        Dog *dog = [[Dog alloc] init];
        DogBreed *breed = [DogBreed new];
        breed.name = [NSString stringWithFormat:@"Dog %d", i + 1];
        breed.subBreed = [NSString stringWithFormat:@"SubDog %d", i + 1];
        dog.breed = breed;

        NSUInteger randomIndex = arc4random_uniform((uint32_t)totalImages.count);
        dog.imageURLs = @[ totalImages[randomIndex] ];

        MemoryCard *card = [MemoryCard cardWithDog:dog];
        [cards addObject:card];
    }

    return [cards copy];
}

- (nonnull NSError *)updateMemoryWithCard:(nonnull MemoryCard *)card statue:(MemoryCardStatus)status {
    return nil;
}

- (NSUInteger)todayCountToRemember {
    return 4;
}

- (NSUInteger)todayCountRemembered {
    return 1;
}

- (NSUInteger)currentCountRemembered {
    return 100;
}

- (NSUInteger)totalCountToRemember {
    return 400;
}

@end
