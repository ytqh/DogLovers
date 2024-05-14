//
//  DogCardView.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/14.
//

#import "DogCardView.h"

@interface DogCardView ()

@property (weak, nonatomic) IBOutlet UIImageView *dogImage;
@property (weak, nonatomic) IBOutlet UITableView *choiceTableView;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@end

@implementation DogCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:@"DogCardView"
                                                              owner:self
                                                            options:nil] firstObject];
        xibView.frame = self.bounds;
        xibView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview: xibView];
    }
    
    return self;
}

@end
