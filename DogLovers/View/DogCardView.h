//
//  DogCardView.h
//  DogLovers
//
//  Created by 雨田 on 2024/5/14.
//

#import <UIKit/UIKit.h>
#import "Memory.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DogCardSelectStatus) {
    DogCardSelected,
    DogCardForget,
};

@interface DogCardData : NSObject

@property (nonatomic, copy, readonly) Dog *dog;
@property (nonatomic, copy, readonly) NSString *imageURL;
@property (nonatomic, copy, readonly) NSArray<DogBreed *> *options;
@property (nonatomic, copy, readonly) DogBreed *correctOption;

- (instancetype)initWithCard:(MemoryCard *)card;

@end

@interface DogCardView : UIView

@property (nonatomic, assign, readonly) NSUInteger currentIndex;

- (void)reload;
- (void)nextCard;

@end

@protocol DogCardViewDelegate <NSObject>

- (void)dogCardView:(DogCardView *)view didSelectedOption:(nullable DogBreed *)option atIndex:(NSUInteger)index withStatus:(DogCardSelectStatus)status;

@end

@protocol DogCardViewDataSource <NSObject>

- (DogCardData *)dogCardView:(DogCardView *)view cardDataAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfCardsInDogCardView:(DogCardView *)view;

@end

@interface DogCardView (Delegate)

@property (nonatomic, weak) id<DogCardViewDelegate> delegate;
@property (nonatomic, weak) id<DogCardViewDataSource> dataSource;

@end


NS_ASSUME_NONNULL_END
