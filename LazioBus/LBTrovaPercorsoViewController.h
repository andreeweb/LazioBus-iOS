//
//  LBTrovaPercorsoViewController.h
//  LazioBus
//
//  Created by Andrea Cerra on 04/12/13.
//  Copyright (c) 2013 Andrea Cerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBTrovaPercorsoDetailView.h"
#import "LBTrovaIndirizzoTableController.h"
#import "LBStop.h"
#import "LBTrovaPercorsoDetailView.h"
#import "LBSpinner.h"
#import "LBResults.h"
#import "LBSession.h"
#import "LBUrl.h"

@interface LBTrovaPercorsoViewController : UIViewController<UIPickerViewDelegate>{
    
    GADBannerView *bannerView_;
    
    NSArray *cambiArray;
    LBSpinner *spinner;
    
    //connessione
    NSURLConnection *search;
    NSMutableData *receivedData;
}

- (IBAction)selectDeparture:(id)sender;
- (IBAction)selectArrival:(id)sender;
- (IBAction)resetButton:(id)sender;
- (IBAction)searchButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *selectDepartureButton;
@property (weak, nonatomic) IBOutlet UIButton *selectArrivalButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

//stop object passed from LBDepArrTableViewController
@property LBStop *departureStop;
@property LBStop *arrivalStop;

//data picker
@property(nonatomic,retain) UIView *pickerDataView;
@property(nonatomic,retain) UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *dataText;
- (IBAction)setDataPicker:(id)sender;

//cambi picker
@property(nonatomic,retain) UIView *pickerCambiView;
@property(nonatomic,retain) UIPickerView *cambiPicker;
@property (weak, nonatomic) IBOutlet UITextField *cambiText;
- (IBAction)setCambPicker:(id)sender;

//time picker
@property(nonatomic,retain) UIView *pickerTimeView;
@property(nonatomic,retain) UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UITextField *timeText;
- (IBAction)setTimPicker:(id)sender;


@end
