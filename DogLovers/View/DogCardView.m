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
@property (nonatomic, copy) NSArray<DogBreed *> *options;
@property (nonatomic, copy) DogBreed *correctOption;

@end

@implementation DogCardData

- (instancetype)initWithCard:(MemoryCard *)card {
    self = [super init];
    if (self) {
        self.dog = card.dog;
        self.options = card.options;
        self.correctOption = card.correctOption;
    }

    return self;
}

- (NSString *)imageURL {
    return self.dog.imageURLs.firstObject;
}

@end

static NSString *const DogChoiceReuseIdentifier = @"DogCardView";

@interface DogCardView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *dogImage;
@property (weak, nonatomic) IBOutlet UITableView *choiceTableView;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@property (nonatomic, weak) id<DogCardViewDelegate> delegate;
@property (nonatomic, weak) id<DogCardViewDataSource> dataSource;

@property (readonly) DogCardData *currentCard;
@property (nonatomic, assign) NSUInteger currentIndex;

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

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.choiceTableView.delegate = self;
    self.choiceTableView.dataSource = self;
    [self.choiceTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:DogChoiceReuseIdentifier];
}

- (void)reload {
    [self.dogImage sd_setImageWithURL:[NSURL URLWithString:self.currentCard.imageURL]];
    [self.choiceTableView reloadData];
}

- (DogCardData *)currentCard {
    return [self.dataSource dogCardView:self cardDataAtIndex:self.currentIndex];
}

- (void)nextCard {
    self.currentIndex += 1;
    if (self.currentCard.imageURL.length == 0) {
        __weak typeof(self) weakSelf = self;
        [self.currentCard.dog fetchRandomImageURLsWithCompletion:^(NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf reload];
            });
        }];
    } else {
        [self reload];
    }
}

#pragma mark - UITableViewDelegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentCard.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DogChoiceReuseIdentifier forIndexPath:indexPath];

    UIListContentConfiguration *content = cell.defaultContentConfiguration;
    content.text = [self.currentCard.options[indexPath.row] description];
    cell.contentConfiguration = content;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.height / self.currentCard.options.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DogBreed *selectedOption = self.currentCard.options[indexPath.row];
    BOOL isCorrectOption = [selectedOption isEqual:self.currentCard.correctOption];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIListContentConfiguration *content = cell.defaultContentConfiguration;
    NSString *contentStr = [NSString stringWithFormat:@"%@ %@", selectedOption, isCorrectOption ? @"✅" : @"❌"];
    content.text = contentStr;
    cell.contentConfiguration = content;
    cell.selected = YES;
    [cell setNeedsDisplay];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.delegate dogCardView:self didSelectedOption:selectedOption atIndex:self.currentIndex withStatus:DogCardSelected];
    });
}

- (IBAction)forget:(id)sender {
    [self.delegate dogCardView:self didSelectedOption:nil atIndex:self.currentIndex withStatus:DogCardForget];
}

@end
