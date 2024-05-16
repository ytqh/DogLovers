//
//  Dog.h
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DogBreed : NSObject <NSCopying, NSSecureCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, nullable) NSString *subBreed;

@end

@interface Dog : NSObject <NSCopying, NSSecureCoding>

@property (nonatomic, copy) DogBreed *breed;
@property (nonatomic, copy) NSArray<NSString *> *imageURLs;

- (void)fetchRandomImageURLs;

@end

@interface DogManager : NSObject

@property (nonatomic, copy, readonly) NSArray<Dog *> *allDogs;

+ (instancetype)sharedManager;

// refresh dog cache
- (void)refreshDogCache:(void (^)(NSError *_Nullable error))completion;

// query dog with breed
// return nil if not found
- (NSDictionary<DogBreed *, Dog *> *)dogWithBreed:(NSArray<DogBreed *> *)breeds;

@end

NS_ASSUME_NONNULL_END
