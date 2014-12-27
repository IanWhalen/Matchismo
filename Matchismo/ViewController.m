//
//  ViewController.m
//  Matchismo
//
//  Created by Ian Mackenzie Whalen on 12/13/14.
//  Copyright (c) 2014 Ian Whalen. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface ViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeController;
@property (weak, nonatomic) IBOutlet UILabel *latestActionResultLabel;
@property (weak, nonatomic) IBOutlet UISlider *actionHistorySlider;
@end

@implementation ViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}
- (IBAction)matchModeController:(UISegmentedControl *)sender
{
    [self.game updateNumberOfCardsToMatch:sender.selectedSegmentIndex];
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)resetGameButton:(UIButton *)sender
{
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                              usingDeck:[self createDeck]];
    self.matchModeController.userInteractionEnabled = YES;
    self.matchModeController.enabled = YES;

    [self.game clearActionHistory];
    
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    self.matchModeController.userInteractionEnabled = NO;
    self.matchModeController.enabled = NO;

    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];

    self.latestActionResultLabel.alpha = 1;
    self.actionHistorySlider.value = 1;
    self.latestActionResultLabel.text = [NSString stringWithFormat:@"%@", self.game.latestActionResult];
    [self updateUI];
}
- (IBAction)actionHistorySlider:(UISlider *)sender {
    if ([self.game.actionHistory count] > 0) {
        self.latestActionResultLabel.alpha = .5;
        
        int index = floorf(sender.value * ([self.game.actionHistory count]-1));
        self.latestActionResultLabel.text = [NSString stringWithFormat:@"%@", self.game.actionHistory[index]];
    }
}

- (void)updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];

        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;

        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    }
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
