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
@property (nonatomic, copy) NSArray<DogBreed *> *options;
@property (nonatomic, assign) MemoryCardStatus status;
@property (nonatomic, copy) NSString *updatedDayTime; // 2022-09-09 UTC+8

@end

@implementation MemoryCard

+ (nonnull instancetype)cardWithDog:(nonnull Dog *)dog {
    MemoryCard *card = [[MemoryCard alloc] init];
    card.dog = dog;
    card.options = [self optionsWithCorrectOption:dog.breed];
    return card;
}

+ (NSArray<DogBreed *> *)optionsWithCorrectOption:(DogBreed *)correctOption {
    NSArray<DogBreed *> *allBreeds = [[DogManager sharedManager].allDogs valueForKey:@"breed"];

    // random gen three breed except correctOption
    NSMutableArray<DogBreed *> *options = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        DogBreed *option = allBreeds[arc4random_uniform((uint32_t)allBreeds.count)];
        while ([option isEqual:correctOption] || [options containsObject:option]) {
            option = allBreeds[arc4random_uniform((uint32_t)allBreeds.count)];
        }
        [options addObject:option];
    }

    return [options copy];
}

- (NSString *)imageURL {
    return self.dog.imageURLs.firstObject;
}

- (DogBreed *)correctOption {
    return self.dog.breed;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.dog = [coder decodeObjectForKey:@"dog"];
        self.options = [coder decodeObjectForKey:@"options"];
        self.status = [coder decodeIntegerForKey:@"status"];
        self.updatedDayTime = [coder decodeObjectForKey:@"updatedDayTime"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.dog forKey:@"dog"];
    [coder encodeObject:self.options forKey:@"options"];
    [coder encodeInteger:self.status forKey:@"status"];
    [coder encodeObject:self.updatedDayTime forKey:@"updatedDayTime"];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    MemoryCard *copy = [[[self class] allocWithZone:zone] init];
    if (copy) {
        copy.dog = [self.dog copyWithZone:zone];
        copy.options = [self.options copyWithZone:zone];
        copy.status = self.status;
        copy.updatedDayTime = [self.updatedDayTime copyWithZone:zone];
    }
    return copy;
}

@end

const NSUInteger CardToRememberInOneDay = 10;

@interface Memory ()

@property (nonatomic, assign) NSUInteger totalCountToRemember;
@property (nonatomic, assign) NSUInteger currentCountRemembered;
@property (nonatomic, copy) NSDictionary<DogBreed *, MemoryCard *> *savedCards; // only save when call update memory card
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation Memory

@synthesize savedCards = _savedCards;

+ (nonnull instancetype)sharedMemory {
    static Memory *sharedMemory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMemory = [[self alloc] init];
    });
    return sharedMemory;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _serialQueue = dispatch_queue_create("com.doglovers.memory", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (nonnull NSArray<MemoryCard *> *)unfinishedCardsWithCount:(NSUInteger)count {

    // get all memory card from savedCards with status MemoryCardStatusWrong or MemoryCardStatusForget
    // alse added random cards from other unsaved card new from DogManager if count not enough of savedCard
    NSMutableArray<MemoryCard *> *unfinishedCards = [NSMutableArray array];
    for (MemoryCard *card in self.savedCards.allValues) {
        if (card.status == MemoryCardStatusWrong || card.status == MemoryCardStatusForget) {
            [unfinishedCards addObject:card];
        }
    }

    if (unfinishedCards.count >= count) {
        return [unfinishedCards subarrayWithRange:NSMakeRange(0, count)];
    }

    // alse added random cards from other unsaved card new from DogManager if count not enough of savedCard
    NSArray<Dog *> *allDogs = [DogManager sharedManager].allDogs;
    for (Dog *dog in allDogs) {
        if (unfinishedCards.count >= count) {
            break;
        }

        MemoryCard *card = [MemoryCard cardWithDog:dog];
        if (![self.savedCards.allKeys containsObject:card.correctOption]) {
            [unfinishedCards addObject:card];
        }
    }

    return unfinishedCards;
}

- (void)updateMemoryWithCard:(nonnull MemoryCard *)card statue:(MemoryCardStatus)status {
    dispatch_sync(self.serialQueue, ^{
        if (!_savedCards) {
            _savedCards = [self loadFromUserDefaults] ?: [NSDictionary new];
        }

        NSMutableDictionary<DogBreed *, MemoryCard *> *cards = [_savedCards mutableCopy];

        card.status = status;
        card.updatedDayTime = [self todayDate];
        cards[card.dog.breed] = card;

        _savedCards = cards.copy;
        [self saveToUserDefaults:_savedCards];
    });
}

- (NSUInteger)todayCountToRemember {
    NSUInteger totalRemainCountToRemember = self.totalCountToRemember - self.currentCountRemembered;
    NSUInteger todayCountToRememberInPlaned = totalRemainCountToRemember > CardToRememberInOneDay ? CardToRememberInOneDay : totalRemainCountToRemember;
    NSUInteger todayRemembered = self.todayCountRemembered;

    return todayCountToRememberInPlaned - todayRemembered;
}

- (NSUInteger)todayCountRemembered {
    return [[self.savedCards.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"status == %d AND updatedDayTime == %@",
                                                                                                    MemoryCardStatusCorrect, [self todayDate]]] count];
}

- (NSUInteger)currentCountRemembered {
    return [[self.savedCards.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"status == %d", MemoryCardStatusCorrect]] count];
}

- (NSUInteger)totalCountToRemember {
    return [DogManager sharedManager].allDogs.count;
}

- (NSString *)todayDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:[NSDate date]];
}

// use serial queue to manage savedCards
- (NSDictionary<DogBreed *, MemoryCard *> *)savedCards {
    dispatch_sync(self.serialQueue, ^{
        if (_savedCards != nil) {
            return;
        }

        NSDictionary<DogBreed *, MemoryCard *> *cards = [self loadFromUserDefaults];
        _savedCards = cards.copy;
    });

    return _savedCards;
}

- (void)setSavedCards:(NSDictionary<DogBreed *, MemoryCard *> *)savedCards {
    dispatch_sync(self.serialQueue, ^{
        [self saveToUserDefaults:[savedCards copy]];
    });
}

- (NSDictionary<DogBreed *, MemoryCard *> *)loadFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *savedCardsData = [defaults objectForKey:@"SavedCards"];
    NSError *error;
    NSDictionary<DogBreed *, MemoryCard *> *cards = [NSKeyedUnarchiver unarchiveObjectWithData:savedCardsData];
    
    // OPT: use NSKeyedUnarchiver unarchivedObjectOfClasses:fromData:error: to avoid warning
    // but this method do not return data and throw error: The data couldn’t be read because it isn’t in the correct format.
    // NSDictionary<DogBreed *, MemoryCard *> *cards =
    //     [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSDictionary class], [DogBreed class], [MemoryCard class], nil]
    //                                         fromData:savedCardsData
    //                                            error:&error];
    
    if (error) {
        NSLog(@"MemoryCard Load Error: %@", error.localizedDescription);
    }
    
    return cards;
}

- (void)saveToUserDefaults:(NSDictionary<DogBreed *, MemoryCard *> *)savedCards {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSError *error;
    NSData *savedCardsData = [NSKeyedArchiver archivedDataWithRootObject:savedCards requiringSecureCoding:YES error:&error];
    if (error) {
        NSLog(@"MemoryCard Save Error: %@", error.localizedDescription);
    }
    [defaults setObject:savedCardsData forKey:@"SavedCards"];
}

@end
