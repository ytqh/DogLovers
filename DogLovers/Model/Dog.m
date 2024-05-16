//
//  Dog.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "Dog.h"

@implementation DogBreed

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    DogBreed *breed = [[DogBreed alloc] init];
    breed.name = self.name;
    breed.subBreed = self.subBreed;
    return breed;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[DogBreed class]]) {
        return NO;
    }
    DogBreed *other = (DogBreed *)object;
    return [self.name isEqualToString:other.name] && (self.subBreed == nil || [self.subBreed isEqualToString:other.subBreed]);
}

- (NSString *)description {
    if (self.subBreed != nil) {
        return [NSString stringWithFormat:@"%@ %@", self.name, self.subBreed];
    }
    
    return self.name;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.subBreed = [coder decodeObjectForKey:@"subBreed"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.subBreed forKey:@"subBreed"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end

@implementation Dog

- (instancetype)copyWithZone:(nullable NSZone *)zone {
    Dog *dog = [[Dog alloc] init];
    dog.breed = [self.breed copy];
    dog.imageURLs = [self.imageURLs copy];
    return dog;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[Dog class]]) {
        return NO;
    }
    Dog *other = (Dog *)object;
    return [self.breed isEqual:other.breed];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.breed = [coder decodeObjectForKey:@"breed"];
        self.imageURLs = [coder decodeObjectForKey:@"imageURLs"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.breed forKey:@"breed"];
    [coder encodeObject:self.imageURLs forKey:@"imageURLs"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

// fetch at random imageURL from API: https://dog.ceo/api/breed/hound/afghan/images/random
- (void)fetchRandomImageURLsWithCompletion:(void (^)(NSError *_Nullable error))completion {
    NSString *urlStr = [NSString stringWithFormat:@"https://dog.ceo/api/breed/%@%@/images/random/3", self.breed.name,
                        self.breed.subBreed ? [NSString stringWithFormat:@"/%@", self.breed.subBreed] : @""];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error && completion) {
            // Handle error
            completion(error);
            return;
        }
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError && completion) {
            // Handle JSON parsing error
            completion(jsonError);
            return;
        }
        
        NSArray<NSString *> *images = json[@"message"];
        self.imageURLs = images;
        
        if (completion) {
            completion(nil);
        }
    }];
    [task resume];
}

@end

@interface DogManager ()

@property (nonatomic, copy) NSArray<Dog *> *allDogs;
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation DogManager

@synthesize allDogs = _allDogs;

+ (nonnull instancetype)sharedManager {
    static DogManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DogManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _serialQueue = dispatch_queue_create("com.doglovers.dogmanager", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (NSDictionary<DogBreed *, Dog *> *)dogWithBreed:(NSArray<DogBreed *> *)breeds {
    NSMutableDictionary<DogBreed *, Dog *> *result = [NSMutableDictionary dictionary];
    for (Dog *dog in self.allDogs) {
        for (DogBreed *breed in breeds) {
            if ([dog.breed isEqual:breed]) {
                result[breed] = dog;
                break;
            }
        }
    }
    return [result copy];
}

// query all breeds from https://dog.ceo/api/breeds/list/all
- (void)refreshDogCache:(nonnull void (^)(NSError *_Nullable __strong))completion {
    NSURL *url = [NSURL URLWithString:@"https://dog.ceo/api/breeds/list/all"];
    NSURLSessionDataTask *task =
    [[NSURLSession sharedSession] dataTaskWithURL:url
                                completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (error) {
            completion(error);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            completion(jsonError);
            return;
        }
        
        NSDictionary *breedsDict = json[@"message"];
        NSMutableArray<Dog *> *dogs = [NSMutableArray array];
        for (NSString *name in breedsDict) {
            
            if ([breedsDict[name] count] == 0) {
                Dog *dog = [[Dog alloc] init];
                DogBreed *breed = [[DogBreed alloc] init];
                breed.name = name;
                dog.breed = breed;
                [dogs addObject:dog];
                continue;
            }
            
            for (NSString *subBreed in breedsDict[name]) {
                Dog *dog = [[Dog alloc] init];
                DogBreed *breed = [[DogBreed alloc] init];
                breed.name = name;
                breed.subBreed = subBreed;
                dog.breed = breed;
                [dogs addObject:dog];
            }
        }
        
        self.allDogs = dogs;
        
        [self refreshDogImagesWithDogs:dogs
                            completion:^(NSArray<Dog *> *_Nonnull dogs, NSError *_Nullable error) {
            self.allDogs = dogs;
        }];
        
        completion(nil);
    }];
    [task resume];
}

- (void)refreshDogImagesWithDogs:(nonnull NSArray<Dog *> *)dogs
                      completion:(nonnull void (^)(NSArray<Dog *> *_Nonnull __strong, NSError *_Nullable __strong))completion {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSMutableArray<Dog *> *updatedDogs = [NSMutableArray arrayWithArray:dogs];
    
    for (NSInteger i = 0; i < updatedDogs.count; i += 10) {
        NSRange range = NSMakeRange(i, MIN(10, updatedDogs.count - i));
        NSArray<Dog *> *batch = [updatedDogs subarrayWithRange:range];
        
        for (Dog *dog in batch) {
            dispatch_group_enter(group);
            dispatch_async(queue, ^{
                [dog fetchRandomImageURLsWithCompletion:^(NSError *_Nullable error) {
                    if (error) {
                        NSLog(@"fetch dog %@ image error: %@", dog, error);
                    }
                    dispatch_group_leave(group);
                }];
            });
        }
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion(updatedDogs, nil);
    });
}

// use serial queue to make thread safe
- (NSArray<Dog *> *)allDogs {
    __block NSArray<Dog *> *dogs;
    dispatch_sync(self.serialQueue, ^{
        if (_allDogs == nil) {
            dogs = [self loadFromUserDefault];
            _allDogs = dogs;
        } else {
            dogs = _allDogs;
        }
    });
    
    return dogs;
}

- (void)setAllDogs:(NSArray<Dog *> *)allDogs {
    dispatch_sync(self.serialQueue, ^{
        _allDogs = [allDogs copy];
        [self saveToUserDefault:allDogs];
    });
}

- (NSArray<Dog *> *)loadFromUserDefault {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"dogData"];
    
    NSError *error;
    NSArray<Dog *> *dogs = [NSKeyedUnarchiver unarchivedObjectOfClass:DogBreed.class fromData:data error:&error];
    
    if (error != nil) {
        NSLog(@"load breed from user defaults error: %@", error);
    }
    
    return dogs;
}

- (void)saveToUserDefault:(NSArray<Dog *> *)dogs {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSError *error;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dogs requiringSecureCoding:NO error:&error];
    
    if (error != nil) {
        NSLog(@"save dogs to user defaults error: %@", error);
        return;
    }
    
    [defaults setObject:data forKey:@"dogData"];
    return;
}

@end
