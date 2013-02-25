//
//  ActivityEventViewController.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventView.h"
#import "ParticipantListTableView.h"
#import "NotifyAnimationView.h"
#import "DetailedActivityInfoInvocation.h"
#import "ChatActivityView.h"
#import "CameraCustom.h"
@class InfoActivityClass;
@class SoclivityManager;
@class MainServiceManager;
@class MBProgressHUD;

@interface ActivityEventViewController : UIViewController<AddEventViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,ParticipantListDelegate,NotifyAnimationViewDelegate,DetailedActivityInfoInvocationDelegate,ChatActivityViewDelegate,UIActionSheetDelegate,CustomCameraUploadDelegate>{
    IBOutlet UIScrollView* scrollView;
    IBOutlet AddEventView *eventView;
    IBOutlet ParticipantListTableView *participantListTableView;
    InfoActivityClass *activityInfo;
    IBOutlet UIButton *chatButton;
    IBOutlet UILabel *activityNameLabel;
    IBOutlet UIButton *addEventButton;
    IBOutlet UIButton *leaveActivityButton;
    IBOutlet UIButton *cancelRequestActivityButton;
    IBOutlet UIButton *organizerEditButton;
    IBOutlet UIButton *goingActivityButton;
    IBOutlet UIButton *notGoingActivityButton;
    IBOutlet UIButton *inviteUsersToActivityButton;
    IBOutlet UIButton *blankInviteUsersAnimationButton;
    IBOutlet UIActivityIndicatorView *spinnerView;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *newActivityButton;
    UIButton *goingButton;
    UIButton *DOS1Button;
    UIButton *DOS3Button;
    UIButton *DOS2Button;
    UIImageView *DOS1ButtonHighlight;
    UIImageView *DOS2ButtonHighlight;
    UIImageView *DOS3ButtonHighlight;
    BOOL pageControlBeingUsed;
    int page;
    BOOL toggleFriends;
    int lastIndex;
    IBOutlet UIView *staticView;
    IBOutlet ChatActivityView *chatView;
    BOOL footerActivated;
    IBOutlet UIButton *backToActivityFromMapButton;
    SoclivityManager *SOC;
    IBOutlet UIButton *locationEditLeftCrossButton;
    IBOutlet UIButton *locationEditRightCheckButton;
    IBOutlet UIButton *currentLocationInMap;
    IBOutlet UIButton *editButtonForMapView;
    BOOL inTransition;
    MainServiceManager *devServer;
    MBProgressHUD *HUD;
    NSString *notId;
    
    //chat
    
    IBOutlet UIButton *enterChatTextButton;
    IBOutlet UILabel *commentChatLabel;
    IBOutlet UIButton *postChatImageButton;
    IBOutlet UILabel *imagePostChatlabel;
    CameraCustom *cameraUpload;
    
}
@property (nonatomic, retain) UIScrollView* scrollView;
@property (nonatomic,retain)InfoActivityClass *activityInfo;
-(IBAction)backButtonPressed:(id)sender;
-(IBAction)addEventActivityPressed:(id)sender;
-(IBAction)leaveEventActivityPressed:(id)sender;
-(IBAction)createANewActivityButtonPressed:(id)sender;
-(IBAction)goingActivityButtonPressed:(id)sender;
-(IBAction)notGoingActivityButtonPressed:(id)sender;
-(IBAction)inviteUsersButton:(id)sender;
-(IBAction)editButtonClicked:(id)sender;
-(IBAction)chatButtonPressed:(id)sender;
-(IBAction)cancelRequestButtonPressed:(id)sender;
-(void)scrollViewToTheTopOrBottom;
-(void)highlightSelection:(int)selection;
-(void)BottonBarButtonHideAndShow:(NSInteger)type;
-(IBAction)backToActivityAnimateTransition:(id)sender;
-(IBAction)crossClickedInLocationEdit:(id)sender;
-(IBAction)tickClickedInLocationEdit:(id)sender;
-(IBAction)currentLocationBtnClicked:(id)sender;
-(void)startAnimation:(int)type;
-(IBAction)editViewToChangeActivityLocation:(id)sender;
-(IBAction)enterChatTextButtonPressed:(id)sender;
-(IBAction)postImageOnChatScreenPressed:(id)sender;
@end
