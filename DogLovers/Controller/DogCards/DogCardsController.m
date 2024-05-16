//
//  DogCardsController.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "DogCardsController.h"
#import "DogCardView.h"
#import "Memory.h"
#import <SDWebImage/SDWebImage.h>

@interface DogCardsController () <DogCardViewDelegate, DogCardViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *progessNaviItem;
@property (weak, nonatomic) IBOutlet DogCardView *cardView;

@property (copy, nonatomic) NSArray<MemoryCard *> *cards;
@property (copy, nonatomic) NSArray<DogCardData *> *cardDatas;

@property (readonly) Memory *memory;

@end

@implementation DogCardsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.cardView.delegate = self;
    self.cardView.dataSource = self;
    
    [self preLoadCardData];

    [self reload];
}

- (IBAction)popupController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)dogCardView:(nonnull DogCardView *)view didSelectedOption:(DogBreed *)option atIndex:(NSUInteger)index withStatus:(DogCardSelectStatus)status {

    MemoryCard *card = self.cards[index];
    MemoryCardStatus cardStatus = MemoryCardStatusWrong;

    if (status == DogCardForget) {
        cardStatus = MemoryCardStatusForget;
    } else if ([option isEqual:card.correctOption]) {
        cardStatus = MemoryCardStatusCorrect;
    }

    [self.memory updateMemoryWithCard:self.cards[index] statue:cardStatus];

    if (index >= self.cardDatas.count - 1) {
        // TODO: show a warm feedback
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [view nextCard];
        [self reload];
    }
}

- (nonnull DogCardData *)dogCardView:(nonnull DogCardView *)view cardDataAtIndex:(NSUInteger)index {
    DogCardData *data = self.cardDatas[index];
    return data;
}

- (NSUInteger)numberOfCardsInDogCardView:(nonnull DogCardView *)view {
    return self.cardDatas.count;
}

#pragma mark - Memory Handle Logic

- (void)reload {
    [self.progessNaviItem setTitle:[NSString stringWithFormat:@"%lu/%lu", self.memory.todayCountRemembered, self.memory.todayCountToRemember]];
    [self.cardView reload];
}

- (Memory *)memory {
    return [Memory sharedMemory];
}

#pragma mark - Data Preload

- (void)preLoadCardData {
    for (MemoryCard *card in self.cards) {
        [card.dog fetchRandomImageURLsWithCompletion:nil];
    }

    MemoryCard *curCard = self.cards.firstObject;

    NSMutableArray<NSURL *> *urls = [NSMutableArray array];
    NSArray<NSString *> *urlStrs = [self.cards valueForKey:@"imageURL"];

    for (NSString *url in urlStrs) {
        if (![url isKindOfClass:NSNull.class]) {
            [urls addObject:[NSURL URLWithString:url]];
        }
    }

    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];

    __weak typeof(self) weakSelf = self;
    [curCard.dog fetchRandomImageURLsWithCompletion:^(NSError *_Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf reload];
        });
    }];
}

@end
