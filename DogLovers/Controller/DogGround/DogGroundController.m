//
//  DogGroundController.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "DogGroundController.h"
#import "DogCardsController.h"

@interface DogGroundController ()

// TODO: Trophy

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressNumTitle;
@property (weak, nonatomic) IBOutlet UITableView *dogsTableView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

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
    
}

- (void)reloadData {
    [self.progressView setProgress:self.progress];
    [self.progressNumTitle setText:[NSString stringWithFormat:@"%lu / %lu", self.memory.currentCountRemembered, self.memory.totalCountToRemember]];
    [self.playButton setTitle:[NSString stringWithFormat:@"%lu Puppies Today!", self.memory.currentCountRemembered] forState:UIControlStateNormal];
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
