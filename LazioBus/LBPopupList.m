//
//  LBPopupList.m
//  LazioBus
//
//  Created by Andrea Cerra on 14/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBPopupList.h"

@interface LBPopupList ()

@end

@implementation LBPopupList
@synthesize pathsArray, parent, selectTimesLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [selectTimesLabel setText:NSLocalizedString(@"Seleziona orario", @"")];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Popup view */
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [pathsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [cell setBackgroundColor:[UIColor clearColor]];
    [[cell textLabel] setFont:[UIFont systemFontOfSize:15.0]];
    [[cell textLabel] setTextColor:[UIColor blackColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [[cell textLabel] setText:[[pathsArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBOrariTableViewController *list = [[LBOrariTableViewController alloc] initWithNibName:@"LBOrariTableViewController" bundle:nil];
    [list setAction:@"pdfList"];
    [list setPdfArray:[LBPDF getPDFList]];
    
    NSString *path = [@"http://" stringByAppendingString:[NSString stringWithFormat:@"%@",
                                                        [[pathsArray objectAtIndex:indexPath.row] objectForKey:@"path"]]];
    path = [path stringByReplacingOccurrencesOfString: @" " withString:@"%20"];
    
    [list setPath:path];
    
    [parent.navigationController pushViewController:list animated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];

}

- (IBAction)closeAction:(id)sender {
    
    [UIView transitionWithView:self.view.superview
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^ {
                        [self dismissViewControllerAnimated:NO completion:nil];
                    }
                    completion:nil];
}

@end
