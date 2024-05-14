//
//  DogCardView.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/14.
//

#import "DogCardView.h"
#import <SDWebImage/SDWebImage.h>

@interface DogCardData ()

@property (nonatomic, copy) Dog *dog;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSArray<DogBreed *> *options;
@property (nonatomic, copy) DogBreed *correctOption;

@end

@implementation DogCardData

- (instancetype)initWithCard:(MemoryCard *)card {
    self = [super init];
    if (self) {
        self.dog = card.dog;
        self.imageURL = card.imageURL;
        self.options = card.options;
        self.correctOption = card.correctOption;
    }

    return self;
}

@end

@interface DogCardView ()

@property (weak, nonatomic) IBOutlet UIImageView *dogImage;
@property (weak, nonatomic) IBOutlet UITableView *choiceTableView;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@property (nonatomic, weak) id<DogCardViewDelegate> delegate;
@property (nonatomic, weak) id<DogCardViewDataSource> dataSource;

@property (readonly) DogCardData *currentCard;
@property (readonly) NSUInteger currentIndex;

@end

@implementation DogCardView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"DogCardView" owner:self options:nil] firstObject];
        xibView.frame = self.bounds;
        xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:xibView];
    }

    return self;
}

- (void)reload {
    // TODO: set data;
    [self.dogImage sd_setImageWithURL:[NSURL URLWithString:self.currentCard.imageURL]];
}

- (DogCardData *)currentCard {
    return [self.dataSource dogCardView:self cardDataAtIndex:self.currentIndex];
}

@end
