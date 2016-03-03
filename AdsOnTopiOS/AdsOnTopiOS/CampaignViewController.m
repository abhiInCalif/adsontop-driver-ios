//
//  CampaignViewController.m
//  AdsOnTopiOS
//
//  Created by Abhinav Khanna on 2/19/16.
//  Copyright © 2016 Abhinav Khanna. All rights reserved.
//

#import "CampaignViewController.h"
#import "CampaignSuperViewController.h"
#import "DataLayer.h"

@interface CampaignViewController ()

@end

@implementation CampaignViewController
@synthesize pageIdentifiers;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // check how many days left on the trial
    self.dataSource = self;
    self.pageIdentifiers = [[NSArray alloc] initWithObjects:@"CampaignSelectAccept", @"CampaignSelectDetail", nil];
}

-(void)viewDidAppear:(BOOL)animated {
//    int daysLeft = [DataLayer daysLeftInTrial];
    int daysLeft = 0;
    if (daysLeft > 0) {
        // modal push time!
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"TrialNotComplete"];
        [self presentViewController:viewController animated:YES completion:nil];
    } else {
        CampaignSuperViewController *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:Nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageIdentifiers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((CampaignSuperViewController*) viewController).index;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((CampaignSuperViewController*) viewController).index;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageIdentifiers count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (CampaignSuperViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= [self.pageIdentifiers count]) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    CampaignSuperViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:[self.pageIdentifiers objectAtIndex:index]];
    pageContentViewController.index = index;
    
    return pageContentViewController;
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
