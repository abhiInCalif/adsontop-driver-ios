//
//  DashboardViewController.m
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/27/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import "DashboardViewController.h"
#import "DataLayer.h"
#import "RestLayer.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    Driver* d = [DataLayer getDriver];
    self.driverName.text = d.name; // set the name
    NSURL* imageUrl = [NSURL URLWithString:d.image];
    // use NSURL to set image
    [self.driverPicture sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"profile.png"]];
    // get the statistics information by requesting the driver information again!
    [self callServer:nil];
    [NSTimer scheduledTimerWithTimeInterval:15.0f
            target:self selector:@selector(callServer:) userInfo:nil repeats:YES];
}

-(void)callServer:(NSTimer*)timer {
    Driver* d = [DataLayer getDriver];
    AFHTTPSessionManager* driverManager = [RestLayer getDriver:d.google_userid];
    [driverManager GET:@"" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Got driver data for dashboard update!");
        NSDictionary* responseDict = responseObject;
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"0.#"];
        NSNumber* numberValue = responseDict[@"campaign"];
        if ([numberValue isEqual:[NSNumber numberWithInt:1]]) {
            // in a trial period!
            self.inTrialLabel.text = @"Inactive";
            self.xOfYMiles.text = [NSString stringWithFormat:@"%@ miles", [fmt stringFromNumber:responseDict[@"miles_driven_in_current_campaign"]]];
            // make the progress view width proportional to the percentage of the trial complete.
            CGRect currentProgressViewRect = self.innerProgressView.frame;
            CGRect outerProgressViewRect = self.outerProgressView.frame;
            int daysLeftInTrial = [DataLayer daysLeftInTrial];
            int daysFinished = 30 - daysLeftInTrial;
            float percentage = daysFinished / 30.0;
            currentProgressViewRect.size.width = percentage * (outerProgressViewRect.size.width);
            self.innerProgressView.frame = currentProgressViewRect;
            self.percentageGoalReached.text = [NSString stringWithFormat:@"%@%%", [fmt stringFromNumber:[NSNumber numberWithFloat:(100 * percentage)]]];
        } else {
            self.inTrialLabel.text = @"In campaign";
            self.xOfYMiles.text = [NSString stringWithFormat:@"%@ of %@ miles", [fmt stringFromNumber:responseDict[@"miles_driven_in_current_campaign"]],
                                   [fmt stringFromNumber:responseDict[@"campaign_goal_mileage"]]];
            // make the progress view width proportional to the percentage comlete of the goal.
            CGRect currentProgressViewRect = self.innerProgressView.frame;
            CGRect outerProgressViewRect = self.outerProgressView.frame;
            NSNumber* miles_driven = responseDict[@"miles_driven_in_current_campaign"];
            float miles_driven_f = [miles_driven floatValue];
            NSNumber* campaign_goal = responseDict[@"campaign_goal_mileage"];
            float campaign_goal_f = [campaign_goal floatValue];
            float percentage =  MIN(miles_driven_f / campaign_goal_f, 1);
            currentProgressViewRect.size.width = percentage * (outerProgressViewRect.size.width);
            self.innerProgressView.frame = currentProgressViewRect;
            self.percentageGoalReached.text = [NSString stringWithFormat:@"%@%%", [fmt stringFromNumber:[NSNumber numberWithFloat:(100 * percentage)]]];
        }
        
        NSInteger hour = [responseDict[@"hours_driven_in_current_campaign"] intValue];
        NSInteger minute = [responseDict[@"minutes_driven_in_current_campaign"] intValue];
        if (hour < 10 && minute < 10) {
            self.hoursWithSign.text = [NSString stringWithFormat:@"0%ld:0%ld", (long)hour, (long)minute];
        } else if (hour >= 10 && minute < 10) {
            self.hoursWithSign.text = [NSString stringWithFormat:@"%ld:0%ld", (long)hour, (long)minute];
        } else if (hour < 10 && minute >= 10) {
            self.hoursWithSign.text = [NSString stringWithFormat:@"0%ld:%ld", (long)hour, (long)minute];
        } else {
            self.hoursWithSign.text = [NSString stringWithFormat:@"%ld:%ld", (long)hour, (long)minute];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Driver Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

//-(void)viewDidAppear:(BOOL)animated {
//    int daysLeft = [DataLayer daysLeftInTrial];
////    int daysLeft = 0;
//    if (daysLeft > 0) {
//        // modal push time!
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"TrialNotComplete"];
//        [self addChildViewController:viewController];
//        viewController.view.bounds = self.view.bounds;
//        [self.view addSubview:viewController.view];
//        [viewController didMoveToParentViewController:self];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
