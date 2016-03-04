//
//  TrialViewController.m
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/21/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import "TrialViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Driver.h"
#import "DataLayer.h"
#import "RestLayer.h"

@interface TrialViewController ()
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *milesInTrial;
@property (weak, nonatomic) IBOutlet UILabel *minHoursInTrial;

@end

@implementation TrialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    // update the amount of days left in the trial label.
    // get the driver record, and use the trial date item to compute number of days left in trial
    
//    int daysLeft = [DataLayer daysLeftInTrial];
    int daysLeft = 10;
    
    // depending on the number of days left in the trial we want to either launch a modal screen
    // that states that he should now go to the campaigns screen or update the number
    // and display the page.
    if (daysLeft <= 0) {
        // modal push time!
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"TrialEndPage"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
    NSString* days_till_trial_end = [NSString stringWithFormat:@"%i Days", daysLeft];
    self.daysLeftLabel.text = days_till_trial_end;
    
    // update the other fields
    Driver* d = [DataLayer getDriver];
    AFHTTPSessionManager* driverManager = [RestLayer getDriver:d.google_userid];
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.#"];
    [driverManager GET:@"" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Got the Driver data for trial page update");
        NSDictionary* responseDict = responseObject;
        NSInteger hour = [responseDict[@"hours_driven_in_current_campaign"] intValue];
        NSInteger minute = [responseDict[@"minutes_driven_in_current_campaign"] intValue];
        if (hour < 10 && minute < 10) {
            self.minHoursInTrial.text = [NSString stringWithFormat:@"0%ld:0%ld", (long)hour, (long)minute];
        } else if (hour >= 10 && minute < 10) {
            self.minHoursInTrial.text = [NSString stringWithFormat:@"%ld:0%ld", (long)hour, (long)minute];
        } else if (hour < 10 && minute >= 10) {
            self.minHoursInTrial.text = [NSString stringWithFormat:@"0%ld:%ld", (long)hour, (long)minute];
        } else {
            self.minHoursInTrial.text = [NSString stringWithFormat:@"%ld:%ld", (long)hour, (long)minute];
        }
        
        NSNumber* miles_driven = responseDict[@"miles_driven_in_current_campaign"];
        self.milesInTrial.text = [fmt stringFromNumber:miles_driven];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Driver Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

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
