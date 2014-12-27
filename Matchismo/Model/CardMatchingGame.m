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
@property (nonatomic, readwrite) NSString *latestActionResult;
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
    }
}
-(void)compareChosenCards
{
    // iterate through all cards but the last one, comparing to each following card
    int matchScore = 0;
    for (int i = 0; i < [self.chosenCards count]-1; i++) {
        NSRange range = NSMakeRange(i+1, [self.chosenCards count]-i-1);
        matchScore += [self.chosenCards[i] match:[self.chosenCards subarrayWithRange:range]];
    }

    if (matchScore) {
        self.score += matchScore * MATCH_BONUS;
        for (Card *eachCard in self.chosenCards) {
            eachCard.matched = YES;
        }
        [self updateLatestActionResultForScore:matchScore * MATCH_BONUS];

        [self.chosenCards removeAllObjects];
    } else {
        [self updateLatestActionResultForScore:0];
        self.score -= MISMATCH_PENALTY;

        Card *firstCard = [self.chosenCards firstObject];
        firstCard.chosen = NO;
        [self.chosenCards removeObject:firstCard];
    }
}

- (void)updateNumberOfCardsToMatch:(NSUInteger)index
{
    self.numberOfCardsToMatch = index + 2;
}
- (void)updateLatestActionResultForScore:(int)score
{
    NSMutableString *string = [NSMutableString stringWithString:@""];
    if (score == 0) {
        [string appendString:@"No match found amongst "];
        for (Card *card in self.chosenCards) {
            [string appendFormat:@"%@", card.contents];
        }
    } else {
        [string appendFormat:@"%d points for matching ", score];
        for (Card *card in self.chosenCards) {
            [string appendFormat:@"%@", card.contents];
        }
    }
    self.latestActionResult = string;
}

@end
