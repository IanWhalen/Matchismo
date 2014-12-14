//
//  Deck.h
//  Matchismo
//
//  Created by Ian Mackenzie Whalen on 12/13/14.
//  Copyright (c) 2014 Ian Whalen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
