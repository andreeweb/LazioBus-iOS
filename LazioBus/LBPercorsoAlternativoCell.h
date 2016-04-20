//
//  LBPercorsoAlternativoCell.h
//  LazioBus
//
//  Created by Andrea Cerra on 04/12/13.
//  Copyright (c) 2013 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBPercorsoAlternativoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeTravelLabel;
@property (weak, nonatomic) IBOutlet UILabel *travelLengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberBusLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberTramLabel;
@property (weak, nonatomic) IBOutlet UILabel *walkLabel;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end
