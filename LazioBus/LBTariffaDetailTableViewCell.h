//
//  LBTariffaDetailTableViewCell.h
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBTariffaDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *departureLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivalLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *departureZone;
@property (weak, nonatomic) IBOutlet UILabel *arrivalZone;
@end
