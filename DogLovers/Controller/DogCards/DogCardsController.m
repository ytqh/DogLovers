//
//  DogCardsController.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "DogCardsController.h"
#import "DogCardView.h"
#import "Memory.h"

@interface DogCardsController () <DogCardViewDelegate, DogCardViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *progessNaviItem;
@property (weak, nonatomic) IBOutlet DogCardView *cardView;

@property (copy, nonatomic) NSArray<MemoryCard *> *cards;
@property (copy, nonatomic) NSArray<DogCardData *> *cardDatas;

@end

@implementation DogCardsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cardView.delegate = self;
    self.cardView.dataSource = self;
}

- (IBAction)popupController:(id)sender {
    
    // TODO: save current status?
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    // TODO: overall save status in case data loss;
}

- (void)configureCards:(NSArray<MemoryCard *> *)cards {
    self.cards = cards;
    NSMutableArray<DogCardData *> *cardDatas = [[NSMutableArray alloc] init];
    for (MemoryCard *card in cards) {
        DogCardData *data = [[DogCardData alloc] initWithCard:card];
        [cardDatas addObject:data];
    }
    
    self.cardDatas = cardDatas;
}

#pragma mark - Card Delegate && DataSource

- (void)dogCardView:(nonnull DogCardView *)view didSelectedOption:(nonnull DogBreed *)option atIndex:(NSUInteger)index withStatus:(DogCardSelectStatus)status { 
    
    // TODO: update memory data
    
    // TODO: when finished all cards, dismiss the controller or give an finished view to give warm feedback.
}

- (nonnull DogCardData *)dogCardView:(nonnull DogCardView *)view cardDataAtIndex:(NSUInteger)index { 
    DogCardData *data = self.cardDatas[index];
    return data;
}

- (NSUInteger)numberOfCardsInDogCardView:(nonnull DogCardView *)view { 
    return self.cardDatas.count;
}

#pragma mark - Memory Handle Logic

@end
