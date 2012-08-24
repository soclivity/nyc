//
//  ActivityEventViewController.m
//  Soclivity
//
//  Created by Kanav Gupta on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityEventViewController.h"
#import "SoclivityUtilities.h"
#import "InfoActivityClass.h"
#import "SoclivitySqliteClass.h"
#import "SoclivityManager.h"
#import "InvitesViewController.h"
#define kDeleteActivity 12
@implementation ActivityEventViewController
@synthesize activityInfo,scrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear in slide View Controller Called");
    
    [self.navigationController.navigationBar setHidden:YES];
}
#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    toggleFriends=TRUE;
    SOC=[SoclivityManager SharedInstance];
    lastIndex=-1;
    


    scrollView.indicatorStyle=UIScrollViewIndicatorStyleBlack;
    scrollView.clipsToBounds = YES;
    
    
    if([activityInfo.goingCount intValue]==0){
        scrollView.scrollEnabled=NO;
    }
    else{
    scrollView.scrollEnabled = YES;
    }
    
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator =NO;
    scrollView.alwaysBounceVertical= YES;
    scrollView.delegate = self;
    scrollView.bounces=NO;
    
    eventView.delegate=self;
    participantListTableView.tableActivityInfo=activityInfo;
    participantListTableView.activityLinkIndex=activityInfo.activityRelationType;
    participantListTableView.participantTableView.bounces=NO;
    if(page==0){
        participantListTableView.participantTableView.scrollEnabled=NO;
    }
     participantListTableView.participantTableView.clipsToBounds=YES;
    
    
    for (int i = 0; i < 2; i++) {
		CGRect frame;
		frame.origin.x = 0;
		frame.origin.y = self.scrollView.frame.size.height* i+44.0f;
		frame.size = self.scrollView.frame.size;
		
        switch (i) {
            case 0:
            {
                eventView.frame=CGRectMake(0, 0, 640, 329);
                [self.scrollView addSubview:eventView];
                
             }
                break;
            case 1:
            {
                int delta=0;

                UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, delta, 320, 47)];
                headerView.backgroundColor=[UIColor clearColor];
                UIImageView *participantBarImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"S05_participantBar.png"]];
                participantBarImgView.frame=CGRectMake(0, delta, 320, 47);
                [headerView addSubview:participantBarImgView];
                
                UIButton *pArrowButton=[UIButton buttonWithType:UIButtonTypeCustom];
                pArrowButton.frame=CGRectMake(2,delta+4,33,40);
                [pArrowButton setBackgroundImage:[UIImage imageNamed:@"S05_participantArrow"] forState:UIControlStateNormal];
                [pArrowButton addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                pArrowButton.tag=103;
                [headerView addSubview:pArrowButton];
                
                
                
                
                // People going section in the participant bar
                goingButton=[UIButton buttonWithType:UIButtonTypeCustom];
                goingButton.frame=CGRectMake(35,delta,55,47);
                [goingButton addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                goingButton.tag=104;
                [headerView addSubview:goingButton];
                
                
                CGRect goingCountLabelRect=CGRectMake(35,delta+11,55,12);
                UILabel *goingCountLabel=[[UILabel alloc] initWithFrame:goingCountLabelRect];
                goingCountLabel.textAlignment=UITextAlignmentCenter;
                goingCountLabel.text=[NSString stringWithFormat:@"%@",activityInfo.goingCount];
                goingCountLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
                goingCountLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                goingCountLabel.tag=235;
                goingCountLabel.backgroundColor=[UIColor clearColor];
                
                
                CGRect goingLabelTextRect=CGRectMake(35,delta+26,55,12);
                UILabel *goingTextLabel=[[UILabel alloc] initWithFrame:goingLabelTextRect];
                goingTextLabel.textAlignment=UITextAlignmentCenter;
                goingTextLabel.text=[NSString stringWithFormat:@"GOING"];
                goingTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:12];
                goingTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                goingTextLabel.tag=236;
                goingTextLabel.backgroundColor=[UIColor clearColor];
                
                if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount>0){
                
                    goingCountLabel.text=[NSString stringWithFormat:@"%d",activityInfo.pendingRequestCount];
                    goingTextLabel.text=[NSString stringWithFormat:@"REQUESTS"];
                    goingCountLabel.textColor=[UIColor redColor];
                    goingTextLabel.textColor=[UIColor redColor];

               }
                
                [headerView addSubview:goingCountLabel];
                [headerView addSubview:goingTextLabel];
                [goingCountLabel release];
                [goingTextLabel release];
                
                // Friends going section in the participant bar
                DOS1Button=[UIButton buttonWithType:UIButtonTypeCustom];
                DOS1Button.frame=CGRectMake(95,delta,75,47);
                [DOS1Button addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                DOS1Button.tag=105;
                [headerView addSubview:DOS1Button];
                
                CGRect DOS_1LabelRect=CGRectMake(100,delta+11,25,12);
                UILabel *DOS_1countLabel=[[UILabel alloc] initWithFrame:DOS_1LabelRect];
                DOS_1countLabel.textAlignment=UITextAlignmentRight;
                DOS_1countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS1];
                DOS_1countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                DOS_1countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_1countLabel.tag=237;
                DOS_1countLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:DOS_1countLabel];
                [DOS_1countLabel release];
                
                UIImageView *DOS_1ImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallDOS1.png"]];
                DOS_1ImageView.frame=CGRectMake(129, delta+11, 19, 11);
                DOS_1ImageView.tag=238;
                [headerView addSubview:DOS_1ImageView];
                [DOS_1ImageView release];
                
                CGRect friendsLabelTextRect=CGRectMake(104,delta+26,55,12);
                UILabel *friendsTextLabel=[[UILabel alloc] initWithFrame:friendsLabelTextRect];
                friendsTextLabel.textAlignment=UITextAlignmentCenter;
                friendsTextLabel.text=[NSString stringWithFormat:@"FRIENDS"];
                friendsTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                friendsTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                friendsTextLabel.tag=239;
                friendsTextLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:friendsTextLabel];
                [friendsTextLabel release];
                
                // People you may know section in the participant bar
                DOS2Button=[UIButton buttonWithType:UIButtonTypeCustom];
                DOS2Button.frame=CGRectMake(175,delta,75,47);
                [DOS2Button addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                DOS2Button.tag=106;
                [headerView addSubview:DOS2Button];
                
                CGRect DOS_2LabelRect=CGRectMake(180,delta+11,25,12);
                UILabel *DOS_2countLabel=[[UILabel alloc] initWithFrame:DOS_2LabelRect];
                DOS_2countLabel.textAlignment=UITextAlignmentRight;
                DOS_2countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS2];
                DOS_2countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                DOS_2countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_2countLabel.tag=240;
                DOS_2countLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:DOS_2countLabel];
                [DOS_2countLabel release];
                
                UIImageView *DOS_2ImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"smallDOS2.png"]];
                DOS_2ImageView.frame=CGRectMake(209, delta+11, 19, 11);
                DOS_2ImageView.tag=241;
                [headerView addSubview:DOS_2ImageView];
                [DOS_2ImageView release];
                
                CGRect mayknowLabelTextRect=CGRectMake(181,delta+26,65,12);
                UILabel *mayknowTextLabel=[[UILabel alloc] initWithFrame:mayknowLabelTextRect];
                mayknowTextLabel.textAlignment=UITextAlignmentCenter;
                mayknowTextLabel.text=[NSString stringWithFormat:@"MAY KNOW"];
                mayknowTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                mayknowTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                mayknowTextLabel.tag=242;
                mayknowTextLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:mayknowTextLabel];
                [mayknowTextLabel release];
                
                
                // Other section in the participant bar
                DOS3Button=[UIButton buttonWithType:UIButtonTypeCustom];
                DOS3Button.frame=CGRectMake(257,delta,75,47);
                [DOS3Button addTarget:self action:@selector(ButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
                DOS3Button.tag=107;
                [headerView addSubview:DOS3Button];
                
                
                CGRect DOS_3LabelRect=CGRectMake(262,delta+11,55,12);
                UILabel *DOS_3countLabel=[[UILabel alloc] initWithFrame:DOS_3LabelRect];
                DOS_3countLabel.textAlignment=UITextAlignmentCenter;
                DOS_3countLabel.text=[NSString stringWithFormat:@"%d",activityInfo.DOS3];
                DOS_3countLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                DOS_3countLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                DOS_3countLabel.tag=243;
                DOS_3countLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:DOS_3countLabel];
                [DOS_3countLabel release];
                
                
                CGRect othersLabelTextRect=CGRectMake(262,delta+26,55,12);
                UILabel *othersTextLabel=[[UILabel alloc] initWithFrame:othersLabelTextRect];
                othersTextLabel.textAlignment=UITextAlignmentCenter;
                othersTextLabel.text=[NSString stringWithFormat:@"OTHERS"];
                othersTextLabel.font=[UIFont fontWithName:@"Helvetica-Condensed" size:12];
                othersTextLabel.textColor=[SoclivityUtilities returnTextFontColor:5];
                othersTextLabel.tag=244;
                othersTextLabel.backgroundColor=[UIColor clearColor];
                [headerView addSubview:othersTextLabel];
                [othersTextLabel release];
                participantListTableView.participantTableView.tableHeaderView=headerView;
                [participantListTableView setFrame:CGRectMake(0, 329, 320, 423)];
                [self.scrollView addSubview:participantListTableView];
            }
                break;
                
        }		
	}

    // Activity label
    activityNameLabel.text=[NSString stringWithFormat:@"%@",activityInfo.activityName];
    activityNameLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    activityNameLabel.textColor=[UIColor whiteColor];
    activityNameLabel.backgroundColor=[UIColor clearColor];
    activityNameLabel.shadowColor = [UIColor blackColor];
    activityNameLabel.shadowOffset = CGSizeMake(0,-1);

    [eventView loadViewWithActivityDetails:activityInfo];
    
    [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];

    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,705);


    // Do any additional setup after loading the view from its nib.
}

-(void)BottonBarButtonHideAndShow:(NSInteger)type{
    
    switch (type) {
            //join 
        case 1:
        {
            cancelRequestActivityButton.hidden=YES;
            addEventButton.hidden=NO;
            organizerEditButton.hidden=YES;
            goingActivityButton.hidden=YES;
            notGoingActivityButton.hidden=YES;
            inviteUsersToActivityButton.hidden=YES;
            leaveActivityButton.hidden=YES;
            chatButton.hidden=YES;
            
            
        }
            break;
            //pending request
        case 2:
        {
            cancelRequestActivityButton.hidden=NO;
            addEventButton.hidden=YES;
            organizerEditButton.hidden=YES;
            inviteUsersToActivityButton.hidden=YES;
            goingActivityButton.hidden=YES;
            notGoingActivityButton.hidden=YES;
            leaveActivityButton.hidden=YES;
            chatButton.hidden=YES;

            
            
            
        }
            break;
            
            //invited
        case 3:
        {
            cancelRequestActivityButton.hidden=YES;
            addEventButton.hidden=YES;
            organizerEditButton.hidden=YES;
            goingActivityButton.hidden=NO;
            notGoingActivityButton.hidden=NO;
            chatButton.hidden=YES;
            inviteUsersToActivityButton.hidden=YES;
            leaveActivityButton.hidden=YES;

            
            
            
            
        }
            break;
            
            // going/not Going
        case 4:
        {
            cancelRequestActivityButton.hidden=YES;
            addEventButton.hidden=YES;
            chatButton.hidden=YES;
            organizerEditButton.hidden=NO;
            goingActivityButton.hidden=YES;
            notGoingActivityButton.hidden=YES;
            leaveActivityButton.hidden=YES;

            
            if([activityInfo.access isEqualToString:@"public"])
                inviteUsersToActivityButton.hidden=NO;
            
            else
                inviteUsersToActivityButton.hidden=YES;
            
            
            
        }
            break;
            
            
            
            //going
        case 5:
        {
            cancelRequestActivityButton.hidden=YES;
            addEventButton.hidden=YES;
            chatButton.hidden=NO;
            organizerEditButton.hidden=YES;
            goingActivityButton.hidden=YES;
            notGoingActivityButton.hidden=YES;
            leaveActivityButton.hidden=NO;

            if([activityInfo.access isEqualToString:@"public"])
                inviteUsersToActivityButton.hidden=NO;
            
            else
                inviteUsersToActivityButton.hidden=YES;
            
            
            
        }
            break;
            
            
            
            
            //organizer
        case 6:
        {
            cancelRequestActivityButton.hidden=YES;
            addEventButton.hidden=YES;
            chatButton.hidden=NO;
            notGoingActivityButton.hidden=YES;
            organizerEditButton.hidden=NO;
            goingActivityButton.hidden=YES;
            inviteUsersToActivityButton.hidden=NO;
            leaveActivityButton.hidden=YES;

            
            
            
            
        }
            break;
    }
}
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ButtonTapped:(UIButton*)sender{
    
    int tag=sender.tag;
    NSLog(@"tag=%d",tag);
    if(page==0){
        
        
        if(activityInfo.activityRelationType==6){
            
            if(activityInfo.pendingRequestCount==0 && [activityInfo.goingCount intValue]==0){
                
                return;
            }
            else{
                [self scrollViewToTheTopOrBottom];
            }
        }
        else{
        if([activityInfo.goingCount intValue]==0)
            return;
        else{
            [self scrollViewToTheTopOrBottom];
        }
        
        }
        
    }
        
    
    
    
    switch (sender.tag) {
        case 103:
        {
            if(page==1){
                [self scrollViewToTheTopOrBottom];
            }
        }
            break;
        case 104:
        {
             [self highlightSelection:0];
             if(lastIndex!=-1){
                           
               
                participantListTableView.noLine=FALSE;
                 [participantListTableView openAllSectionsExceptOne];
                toggleFriends=TRUE;
                lastIndex=-1;
            }
            
        }
            break;
        case 105:
        {
            int section_105;
            if(lastIndex!=0){
           //this section may be zero or one 
                if(activityInfo.DOS1!=0)
                {
                    [self highlightSelection:1];
                    
                    if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount!=0){
                        //we need to check the pending Requests
                        section_105=1;
                        
                    }
                    else{
                        section_105=0;
                    }
                    if(toggleFriends){
                        toggleFriends=FALSE;
                         [participantListTableView collapseSectionsExceptOne:section_105];
                         lastIndex=0;
                    }
                    
                    else{
                        [participantListTableView alternateBetweenSectionsWithCollapseOrExpand:section_105];
                        lastIndex=0;

                    }
                }
            
            }
        }
            break;
        case 107:
        {
            int section_107;
            if(activityInfo.activityRelationType==6 || activityInfo.activityRelationType==4){
            if(lastIndex!=2){  
                
                if(activityInfo.DOS3!=0)
                {
                    [self highlightSelection:3];
                    if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1!=0 && activityInfo.DOS2!=0){
                        //we need to check the pending Requests
                        section_107=3;
                        
                    }
                    else if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1!=0 && activityInfo.DOS2==0){
                        section_107=2;
                    }
                    else if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1==0 && activityInfo.DOS2!=0){
                        section_107=2;
                    }
                    else if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount==0 && activityInfo.DOS1!=0 && activityInfo.DOS2!=0){
                        section_107=2;
                    }
                    else if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount==0 && activityInfo.DOS1!=0 && activityInfo.DOS2==0){
                        section_107=1;
                    }
                    else if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount==0 && activityInfo.DOS1==0 && activityInfo.DOS2!=0){
                        section_107=1;
                    }
                    else if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1==0 && activityInfo.DOS2==0){
                        section_107=1;
                    }
                    else {
                        section_107=0;
                    }
                    if(toggleFriends){
                        toggleFriends=FALSE;
                        [participantListTableView collapseSectionsExceptOne:section_107];
                        lastIndex=2;
                    }
                    
                    else{
                        [participantListTableView alternateBetweenSectionsWithCollapseOrExpand:section_107];
                        lastIndex=2;
                    }
                }
            }
            }
        }
            break;
        case 106:
        {
            int section_106;
            if(lastIndex!=1){  
            
                if(activityInfo.DOS2!=0)
                {
                    [self highlightSelection:2];
                    if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1!=0){
                        //we need to check the pending Requests
                        section_106=2;
                        
                    }
                    else if(activityInfo.activityRelationType==6 && activityInfo.pendingRequestCount!=0 && activityInfo.DOS1==0){
                        section_106=1;
                    }
                    else if(activityInfo.DOS1==0){
                         section_106=0;
                    }
                    else if(activityInfo.DOS1!=0){
                        section_106=1;
                    }
                    if(toggleFriends){
                        toggleFriends=FALSE;
                        [participantListTableView collapseSectionsExceptOne:section_106];
                        lastIndex=1;
                    }
                    
                    else{
                        [participantListTableView alternateBetweenSectionsWithCollapseOrExpand:section_106];
                        lastIndex=1;
                    }
                }
            
            }
        }
            break;

            
        default:
            break;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    if (!pageControlBeingUsed) {
		
        // Switch the indicator when more than 50% of the previous/next view is visible
		CGFloat pageWidth = self.scrollView.frame.size.height;
		page = floor((self.scrollView.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
        
        switch (page) {
            case 1:
            {
                [(UIButton*)[self.scrollView viewWithTag:103] setFrame:CGRectMake(2, 3, 33, 40)];//343
                [(UIButton*)[self.scrollView viewWithTag:103] setBackgroundImage:[UIImage imageNamed:@"S05_participantDownArrow.png"] forState:UIControlStateNormal];
                participantListTableView.participantTableView.scrollEnabled=YES;
            }
                break;
                
                
            case 0:
            {
                [(UIButton*)[self.scrollView viewWithTag:103] setFrame:CGRectMake(2,4,33,40)];//343
                [(UIButton*)[self.scrollView viewWithTag:103] setBackgroundImage:[UIImage imageNamed:@"S05_participantArrow.png"] forState:UIControlStateNormal];
                participantListTableView.participantTableView.scrollEnabled=NO;

            }
                break;

                
        }
    }
    
    if(activityInfo.pendingRequestCount==0 && [activityInfo.goingCount intValue]==0 && page==0){
        self.scrollView.scrollEnabled=NO;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

-(void)scrollViewToTheTopOrBottom{
    
    CGRect frame;
    frame.origin.x = 0;
    frame.origin.y = self.scrollView.frame.size.height;
    frame.size = self.scrollView.frame.size;
    
    switch (page) {
        case 0:
        {
            frame.origin.y = 376;
        }
            break;
            
        case 1:
        {
            frame.origin.y = 0;
        }
            break;
    }
    
	[self.scrollView scrollRectToVisible:frame animated:YES];
}


-(IBAction)addEventActivityPressed:(id)sender{
    
    
    
    
    
    switch (activityInfo.activityRelationType) {
        case 1:
        {
            //cancelRequestActivityButton.hidden=NO;
            //addEventButton.hidden=YES;
            activityInfo.activityRelationType=2;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];

            
        }
            break;
            
        case 2:
        {
            activityInfo.activityRelationType=1;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];
            
        }
            break;
        case 3:
        {
            activityInfo.activityRelationType=1;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];
            
        }
            break;
        case 4:
        {
            activityInfo.activityRelationType=1;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];
            
        }
            break;
        case 5:
        {
            activityInfo.activityRelationType=1;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];
            
        }
            break;
        case 6:
        {
            activityInfo.activityRelationType=1;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];
            
        }
            break;

    }
    
    
}

-(IBAction)leaveEventActivityPressed:(id)sender{
    
    switch (activityInfo.activityRelationType) {
            
        case 1:
        {

            
            
        }
            break;
            
        case 2:
        {

            
            
        }
            break;
    
        case 3:
        {
            
        }
            break;
            
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;

            
        case 6:
        {
            
        }
            break;
    }
    
    
}
-(IBAction)createANewActivityButtonPressed:(id)sender{
    
    
}

-(IBAction)goingActivityButtonPressed:(id)sender{
    
}
-(IBAction)notGoingActivityButtonPressed:(id)sender{
    
}
-(IBAction)inviteUsersButton:(id)sender{
    
    InvitesViewController *invitesViewController=[[InvitesViewController alloc] initWithNibName:@"InvitesViewController" bundle:nil];
    invitesViewController.activityName=[NSString stringWithFormat:@"%@",activityInfo.activityName];
    invitesViewController.num_of_slots=activityInfo.num_of_people;
    invitesViewController.inviteFriends=YES;
	[[self navigationController] pushViewController:invitesViewController animated:YES];
    [invitesViewController release];

}
-(IBAction)editButtonClicked:(id)sender{
    
    crossEditButton.hidden=NO;
    tickEditButton.hidden=NO;
    backButton.hidden=YES;
    newActivityButton.hidden=YES;
    deleteActivityButton.hidden=NO;
    inviteUsersToActivityButton.hidden=YES;
    chatButton.hidden=YES;
    eventView.calendarDateEditArrow.hidden=NO;
    eventView.timeEditArrow.hidden=NO;
    eventView.editMarkerButton.hidden=NO;
    
    [participantListTableView.participantTableView reloadData];
}

-(IBAction)crossClickedByOrganizer:(id)sender{
    crossEditButton.hidden=YES;
    tickEditButton.hidden=YES;
    backButton.hidden=NO;
    newActivityButton.hidden=NO;
    deleteActivityButton.hidden=YES;
    inviteUsersToActivityButton.hidden=NO;
    chatButton.hidden=NO;
    eventView.calendarDateEditArrow.hidden=YES;
    eventView.timeEditArrow.hidden=YES;
    eventView.editMarkerButton.hidden=YES;
    [eventView.addressSearchBar resignFirstResponder];
    [participantListTableView.participantTableView reloadData];

}

-(IBAction)tickClickedByOrganizer:(id)sender{

    crossEditButton.hidden=YES;
    tickEditButton.hidden=YES;
    backButton.hidden=NO;
    newActivityButton.hidden=NO;
    deleteActivityButton.hidden=YES;
    inviteUsersToActivityButton.hidden=NO;
    chatButton.hidden=NO;
    eventView.calendarDateEditArrow.hidden=YES;
    eventView.timeEditArrow.hidden=YES;
    eventView.editMarkerButton.hidden=YES;
     [eventView.addressSearchBar resignFirstResponder];
    [participantListTableView.participantTableView reloadData];

}

-(IBAction)chatButtonPressed:(id)sender{
    
    if(!footerActivated){
        footerActivated=TRUE;
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:staticView cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        
        [scrollView setHidden:YES];
        [chatView setHidden:NO];
        [UIView commitAnimations];
        
        
        context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:chatButton cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        
        
        [UIView commitAnimations];
    }
    else{
        footerActivated=FALSE;
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:staticView cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        
        [scrollView setHidden:NO];
        [chatView setHidden:YES];
        [UIView commitAnimations];
        
        context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:chatButton cache:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationDelegate:self];
        
        [UIView commitAnimations];
    }
    
}
-(IBAction)deleteActivtyPressed:(id)sender{
    
    if(activityInfo.activityRelationType==6){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete the Activity"
                                                    message:nil
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
    alert.tag=kDeleteActivity;
    [alert show];
    [alert release];
    return;
    }

}
-(IBAction)cancelRequestButtonPressed:(id)sender{
    
switch (activityInfo.activityRelationType) {
        case 2:
        {
            activityInfo.activityRelationType=1;
            [self BottonBarButtonHideAndShow:activityInfo.activityRelationType];
            
        }
            break;
    }
    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)dealloc{
    [super dealloc];
    [eventView release];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)highlightSelection:(int)selection {
    
    // Highlight only the item selected and remove highlights from the other areas
    
    // Unhighlight all the other selections
    DOS1Button.backgroundColor = [UIColor clearColor];
    DOS2Button.backgroundColor = [UIColor clearColor];
    DOS3Button.backgroundColor = [UIColor clearColor];
    
    // Highlight just the 'Going' or 'Requests' section
    switch (selection) {
        case 1:
            DOS1Button.backgroundColor = [UIColor blackColor];
            DOS1Button.alpha = 0.1;
            break;
        case 2:
            DOS2Button.backgroundColor = [UIColor blackColor];
            DOS2Button.alpha = 0.1;
            break;
        case 3:
            DOS3Button.backgroundColor = [UIColor blackColor];
            DOS3Button.alpha = 0.1;
        default:
            break;
    }    
}
-(void)slideInTransitionToLocationView{
    
    
    if(activityInfo.activityRelationType==6)
      editButtonForMapView.hidden=NO;//check for organizer
    
    
    currentLocationInMap.hidden=NO;
    
    scrollView.scrollEnabled=NO;
    backButton.hidden=YES;
    [participantListTableView setHidden:YES];
    backToActivityFromMapButton.hidden=NO;
    chatButton.hidden=NO;
    newActivityButton.hidden=YES;
    organizerEditButton.hidden=YES;
    inviteUsersToActivityButton.hidden=YES;
    [eventView.addressSearchBar setHidden:YES];
    eventView.frame=CGRectMake(0, 0, 640, 376);
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut  | UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            eventView.transform = CGAffineTransformMakeTranslation(-320.0f, 0.0f);
            
        } completion:^(BOOL finished) {
            
            
        }];
        
}
-(IBAction)backToActivityAnimateTransition:(id)sender{
    
    if(activityInfo.activityRelationType==6)
      editButtonForMapView.hidden=YES;//check for organizer

        currentLocationInMap.hidden=YES;
    
    if(footerActivated){
        
        footerActivated=FALSE;
        chatView.hidden=YES;
        scrollView.hidden=NO;
    }
    scrollView.scrollEnabled=YES;
    backButton.hidden=NO;
    backToActivityFromMapButton.hidden=YES;
    newActivityButton.hidden=NO;
    organizerEditButton.hidden=NO;
    inviteUsersToActivityButton.hidden=NO;
    locationEditLeftCrossButton.hidden=YES;
    locationEditRightCheckButton.hidden=YES;
     [participantListTableView setHidden:NO];
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        eventView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        
    }];

}
-(IBAction)crossClickedInLocationEdit:(id)sender{
    
    
    if(activityInfo.activityRelationType==6)
        editButtonForMapView.hidden=NO;//check for organizer
    
    locationEditLeftCrossButton.hidden=YES;
    locationEditRightCheckButton.hidden=YES;
    backToActivityFromMapButton.hidden=NO;
    chatButton.hidden=NO;
    [eventView.addressSearchBar setHidden:YES];
    [eventView hideSearchBarAndAnimateWithListViewInMiddle];
    [eventView cancelClicked];
    eventView.editMode=FALSE;
    [eventView setUpLabelViewElements:NO];
    eventView.firstALineddressLabel.text=activityInfo.where_address;
    eventView.secondLineAddressLabel.text=activityInfo.where_zip;    
    eventView.activityInfoButton.hidden=NO;

    
}
-(IBAction)tickClickedInLocationEdit:(id)sender{
    
    if(activityInfo.activityRelationType==6)
        editButtonForMapView.hidden=NO;//check for organizer
    
    locationEditLeftCrossButton.hidden=YES;
    locationEditRightCheckButton.hidden=YES;
    backToActivityFromMapButton.hidden=NO;
    chatButton.hidden=NO;
    [eventView.addressSearchBar setHidden:YES];
    [eventView hideSearchBarAndAnimateWithListViewInMiddle];
    [eventView setNewLocation];
    eventView.activityInfoButton.hidden=NO;
    eventView.editMode=FALSE;


    
}

-(void)enableDisableTickOnTheTopRight:(BOOL)show{
    
    if(show)
     locationEditRightCheckButton.hidden=NO;
    else{
        locationEditRightCheckButton.hidden=YES;
        
    }
}

-(IBAction)editViewToChangeActivityLocation:(id)sender{
    locationEditLeftCrossButton.hidden=NO;
   
    backToActivityFromMapButton.hidden=YES;
    chatButton.hidden=YES;
    editButtonForMapView.hidden=YES;
    
    eventView.editMode=TRUE;
    eventView.addressSearchBar.text=@"";
    [eventView.addressSearchBar setHidden:NO];
    
    [eventView setUpLabelViewElements:YES];
    eventView.activityInfoButton.hidden=YES;

    [eventView showSearchBarAndAnimateWithListViewInMiddle];
    
    
}

-(IBAction)currentLocationBtnClicked:(id)sender{
    [eventView gotoLocation];
}
#pragma mark -
#pragma mark UIAlertView methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //[alertView resignFirstResponder];
    
    if(alertView.tag==kDeleteActivity){
        if (buttonIndex == 0) {
            //delete the Activity
            SOC.localCacheUpdate=TRUE;
            [SoclivitySqliteClass deleteActivityRecords:activityInfo.activityId];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
