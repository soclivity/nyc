//
//  UpComingCompletedEventsViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityListView.h"
#import "NotifyAnimationView.h"
@class MainServiceManager;
@class SoclivityManager;
@protocol UpcomingCompletedEvnetsViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end


@interface UpComingCompletedEventsViewController : UIViewController<ActivityListViewDelegate,NotifyAnimationViewDelegate>{
    id <UpcomingCompletedEvnetsViewDelegate>delegate;
    IBOutlet UILabel *activititesLabel;
     UIButton *organizedButton;
     UIButton*invitedButton;
     UIButton *goingButton;
     UIButton *completedButton;
    IBOutlet ActivityListView *activityListView;
    MainServiceManager *devServer;
    SoclivityManager *SOC;
    BOOL isNotSettings;
    IBOutlet UIButton *profileButton;
    IBOutlet UIButton *backActivityButton;
    NSArray *myActivitiesArray;
    NSArray *invitedToArray;
    NSArray *compeletedArray;
    NSArray *goingToArray;
    BOOL isNotLoggedInUser;
    NSInteger player2Id;
    IBOutlet UIButton *btnnotify;
}
@property (nonatomic,retain)id <UpcomingCompletedEvnetsViewDelegate>delegate;
@property (nonatomic,retain) ActivityListView *activityListView;
@property (nonatomic,assign)NSInteger player2Id;
@property (nonatomic,assign) BOOL isNotLoggedInUser;
@property(nonatomic,assign)BOOL isNotSettings;
@property (nonatomic,retain)NSArray *myActivitiesArray;
@property (nonatomic,retain)NSArray *invitedToArray;
@property (nonatomic,retain)NSArray *compeletedArray;
@property (nonatomic,retain)NSArray *goingToArray;

-(IBAction)profileSliderPressed:(id)sender;
-(void)organizedButtonPressed:(id)sender;
-(void)goingButtonPressed:(id)sender;
-(void)completedButtonPressed:(id)sender;
-(IBAction)backButtonPressed:(id)sender;

@end
