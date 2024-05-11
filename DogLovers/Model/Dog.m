//
//  Dog.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "Dog.h"

@implementation DogBreed
@end

@implementation Dog
@end

@interface DogManager ()

@property (nonatomic, copy) NSArray<DogBreed *> *allBreeds;

@end

@implementation DogManager

+ (nonnull instancetype)sharedManager {
    static DogManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DogManager alloc] init];
    });
    return sharedInstance;
}

- (NSDictionary<DogBreed *, Dog *> *)dogWithBreed:(NSArray<DogBreed *> *)breeds {
    return nil;
}

- (void)refreshDogCache:(nonnull void (^)(NSError *_Nullable __strong))completion {
}

- (void)refreshDogImagesWithDogs:(nonnull NSArray<Dog *> *)dogs
                      completion:(nonnull void (^)(NSArray<Dog *> *_Nonnull __strong, NSError *_Nullable __strong))completion {
}

@end
