//
//  Game.m
//  DogLovers
//
//  Created by 雨田 on 2024/5/11.
//

#import "Game.h"

@implementation Game

+ (instancetype)sharedGame {
    static Game *sharedGame = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGame = [[self alloc] init];
    });
    return sharedGame;
}

- (CGFloat)progressValue {
    return 0.0;
}

- (GameProgressStatus)status {
    return GameBrownMetal;
}

@end
