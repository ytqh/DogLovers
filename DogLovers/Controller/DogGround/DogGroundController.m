//
//  DogGroundController.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "DogGroundController.h"
#import "DogCardsController.h"

@interface DogGroundController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressNumTitle;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *trophyImage;
@property (weak, nonatomic) IBOutlet UILabel *gameText;

@property (readonly) NSArray<MemoryCard *> *todayCards;
@property (readonly) Memory *memory;
@property (readonly) CGFloat progress;

@end

@implementation DogGroundController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupViews];
    [self reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *nav = segue.destinationViewController;

    if (![nav isKindOfClass:UINavigationController.class]) {
        return;
    }

    if (![nav.childViewControllers.firstObject isKindOfClass:DogCardsController.class]) {
        return;
    }

    DogCardsController *cardController = nav.childViewControllers.firstObject;
    [cardController configureCards:self.todayCards];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self reloadData];
}

- (void)setupViews {
    [self.playButton setTitle:@"See you tommorrow!" forState:UIControlStateDisabled];
//    [self.playButton.titleLabel setFont:[UIFont fontWithName:@"chalkduster" size:20]];
}

- (void)reloadData {
    [self.progressView setProgress:self.progress];
    [self.progressNumTitle setText:[NSString stringWithFormat:@"%lu / %lu", self.memory.currentCountRemembered, self.memory.totalCountToRemember]];
    
    if (self.memory.todayCountToRemember == 0) {
        self.playButton.enabled = NO;
        self.trophyImage.alpha = 1.0;
        [self.gameText setText:[NSString stringWithFormat:@"Great!\nYou've learned %lu new puppies!", self.memory.todayCountRemembered]];
    } else {
        self.playButton.enabled = YES;
        self.trophyImage.alpha = 0.4;
        [self.gameText setText:@"10 puppies a day!"];
        [self.playButton setTitle:[NSString stringWithFormat:@"%lu Remaining", self.memory.todayCountToRemember] forState:UIControlStateNormal];
    }
}

#pragma mark - Progress Logic

- (Memory *)memory {
    return [Memory sharedMemory];
}

- (CGFloat)progress {
    return (CGFloat)self.memory.currentCountRemembered / (CGFloat)self.memory.totalCountToRemember;
}

- (NSArray<MemoryCard *> *)todayCards {
    return [self.memory unfinishedCardsWithCount:self.memory.todayCountToRemember];
}

@end
