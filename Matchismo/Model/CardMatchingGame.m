//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Ian Mackenzie Whalen on 12/23/14.
//  Copyright (c) 2014 Ian Whalen. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSUInteger numberOfCardsToMatch;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *chosenCards;
@end

@implementation CardMatchingGame

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}
- (NSMutableArray *)chosenCards
{
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i=0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
        self.score = 0;
        self.numberOfCardsToMatch = 2;
    }

    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];

    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
            [self.chosenCards removeObject:card];
        } else {
            self.score -= COST_TO_CHOOSE;

            card.chosen = YES;
            [self.chosenCards addObject:card];

            // only try to score if enough cards are now chosen
            if ([self.chosenCards count] == self.numberOfCardsToMatch) {
                [self compareChosenCards];
            }
        }
    } else {
    }
}
-(void)compareChosenCards
{
    // Get the most recently added card and an array containing all chosen cards
    // without the most recently added card
    NSRange range;
    range.location = 0;
    range.length = [self.chosenCards count] - 1;
    NSArray *chosenCardsWithoutLastCard = [self.chosenCards subarrayWithRange:range];
    Card *lastCard = [self.chosenCards lastObject];

    int matchScore = [lastCard match:chosenCardsWithoutLastCard];

    if (matchScore) {
        self.score += matchScore * MATCH_BONUS;
        for (Card *eachCard in self.chosenCards) {
            eachCard.matched = YES;
        }
        [self.chosenCards removeAllObjects];
    } else {
        self.score -= MISMATCH_PENALTY;

        Card *firstCard = [self.chosenCards firstObject];
        firstCard.chosen = NO;
        [self.chosenCards removeObject:firstCard];
    }
}

- (void)updateNumberOfCardsToMatch:(NSUInteger)index
{
    self.numberOfCardsToMatch = index + 2;
    NSLog(@"Now waiting until there are %ld cards chosen before matching", (long)self.numberOfCardsToMatch);
}

@end
