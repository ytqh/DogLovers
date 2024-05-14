//
//  DogCardsController.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "DogCardsController.h"
#import "DogCardView.h"

@interface DogCardsController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *progessNaviItem;
@property (weak, nonatomic) IBOutlet DogCardView *CardView;

@end

@implementation DogCardsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)popupController:(id)sender {
    
    // TODO: save current status?
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
