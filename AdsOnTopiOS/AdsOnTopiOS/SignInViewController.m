//
//  SignInViewController.m
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/21/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import "SignInViewController.h"


@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [GIDSignIn sharedInstance].uiDelegate = self;
    // Uncomment to automatically sign in the user.
//    [[GIDSignIn sharedInstance] signInSilently];
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
