//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Ian Mackenzie Whalen on 12/23/14.
//  Copyright (c) 2014 Ian Whalen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)updateNumberOfCardsToMatch:(NSUInteger)index;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)clearActionHistory;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSString *latestActionResult;
@property (nonatomic, readonly) NSMutableArray *actionHistory;

@end
