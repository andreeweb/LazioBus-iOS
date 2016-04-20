//
//  LBTrovaFermataTableViewCell.h
//  LazioBus
//
//  Created by Andrea Cerra on 14/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBTrovaFermataTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *shadowVie;
@property (weak, nonatomic) IBOutlet UILabel *detailState;
@property (weak, nonatomic) IBOutlet UILabel *state;

//for translations
@property (weak, nonatomic) IBOutlet UILabel *direzioneLabel;
@property (weak, nonatomic) IBOutlet UILabel *orarioProgrammatoLabel;

@end
