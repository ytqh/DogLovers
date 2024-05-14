//
//  Dog.h
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DogBreed : NSObject <NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy, nullable) NSString *subBreed;

@end

@interface Dog : NSObject

@property (nonatomic, copy) DogBreed *breed;
@property (nonatomic, copy) NSArray<NSString *> *imageURLs;

@end

@interface DogManager : NSObject

@property (nonatomic, copy, readonly) NSArray<DogBreed *> *allBreeds;

+ (instancetype)sharedManager;

// refresh dog cache
- (void)refreshDogCache:(void (^)(NSError *_Nullable error))completion;

// query dog with breed
// return nil if not found
- (NSDictionary<DogBreed *, Dog *> *)dogWithBreed:(NSArray<DogBreed *> *)breeds;

// refreshDogImages randomly select 3 images for each dog
- (void)refreshDogImagesWithDogs:(NSArray<Dog *> *)dogs completion:(void (^)(NSArray<Dog *> *dogs, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
