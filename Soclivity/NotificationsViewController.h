//
//  NotificationsViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitingOnYouView.h"
#import "MBProgressHUD.h"

@class MBProgressHUD;
@protocol NotificationsScreenViewDelegate <NSObject>

@optional
- (void)showLeft:(id)sender;
@end

@interface NotificationsViewController : UIViewController<WaitingOnYouDelegate,MBProgressHUDDelegate>{
    id <NotificationsScreenViewDelegate>delegate;
    IBOutlet UILabel *waitingOnYouLabel;
    IBOutlet UIImageView*notificationImageView;
    IBOutlet UIImageView*socFadedImageView;
    
    NSMutableData *responsedata;
    
    NSMutableArray *arrnotification;
    
    UIActionSheet * loadingActionSheet;
    
    MBProgressHUD *HUD;
}
@property (nonatomic,retain)id <NotificationsScreenViewDelegate>delegate;
@property(nonatomic, retain) NSMutableData *responsedata;
@property(nonatomic, retain) NSMutableArray *arrnotification;

-(IBAction)profileSliderPressed:(id)sender;
//-(NSMutableArray*) SetUpNotifications;

-(void)startAnimation;
-(void)hideMBProgress;

@end
