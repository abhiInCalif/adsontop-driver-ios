//
//  DashboardViewController.h
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/27/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *driverPicture;
@property (weak, nonatomic) IBOutlet UILabel *driverName;
@property (weak, nonatomic) IBOutlet UIView *innerProgressView;
@property (weak, nonatomic) IBOutlet UIView *outerProgressView;
@property (weak, nonatomic) IBOutlet UILabel *percentageGoalReached;
@property (weak, nonatomic) IBOutlet UILabel *xOfYMiles;
@property (weak, nonatomic) IBOutlet UILabel *hoursWithSign;
@property (weak, nonatomic) IBOutlet UILabel *inTrialLabel;

@end
