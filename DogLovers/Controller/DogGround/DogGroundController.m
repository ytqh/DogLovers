//
//  DogGroundController.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "DogGroundController.h"

@interface DogGroundController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressTitle;
@property (weak, nonatomic) IBOutlet UILabel *progressNumTitle;
@property (weak, nonatomic) IBOutlet UITableView *dogsTableView;

@end

@implementation DogGroundController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// TODO: set up data with DogLovers
- (void)setupViews {

}

@end
