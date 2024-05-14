//
//  DogCardsController.h
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import <UIKit/UIKit.h>
#import "Memory.h"

NS_ASSUME_NONNULL_BEGIN

@interface DogCardsController : UIViewController

- (void)configureCards:(NSArray<MemoryCard *> *)cards;

@end

NS_ASSUME_NONNULL_END
