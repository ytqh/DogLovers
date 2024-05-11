//
//  Game.h
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GameProgressStatus) {
    GameBrownMetal,
    GameSilverMetal,
    GameGoldMetal,
};

@interface Game : NSObject

@property (nonatomic, assign, readonly) GameProgressStatus status;
@property (nonatomic, assign, readonly) CGFloat progressValue; // 0.0 - 1.0

+ (instancetype)sharedGame;

@end

NS_ASSUME_NONNULL_END
