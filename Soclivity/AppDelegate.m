//
//  AppDelegate.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "WelcomeScreenViewController.h"
#import "FacebookLogin.h"
#import "InfoActivityClass.h"
#import "DetailInfoActivityClass.h"
#import "SoclivityUtilities.h"
#import "SoclivitySqliteClass.h"
static NSString* kAppId = @"160726900680967";//kanav
#define kShowAlertKey @"ShowAlert"
#define kRemoteNotificationReceivedNotification @"RemoteNotificationReceivedWhileRunning"
#define kRemoteNotificationBackgroundNotification @"RemoteNotificationReceivedWhileBackground"

@implementation UINavigationBar (CustomImage)

- (void)drawRect:(CGRect)rect {
	UIColor *color = [UIColor clearColor];
	UIImage *img;
    img  = [UIImage imageNamed: @"S01.2_blackbar.png"];
	[img drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	self.tintColor  = color;
}

@end
@implementation AppDelegate
@synthesize navigationController;
@synthesize window = _window;
@synthesize menuController;
@synthesize facebook;
@synthesize userPermissions;
@synthesize resetSuccess;
@synthesize globalSlideController;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logged_in_user_id"];
    
    if ( [[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"]==NULL)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"Waiting_On_You_Count"];
    }//END if ( [[NSUserDefaults standardUserDefaults] valueForKey:@"Waiting_On_You_Count"]==NULL)
    
    //[self setUpActivityDataList];
    [SoclivitySqliteClass copyDatabaseIfNeeded];
	BOOL openSuccessful=[SoclivitySqliteClass openDatabase:[SoclivitySqliteClass getDBPath]];
	if(openSuccessful)
		
     [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSString *nibNameBundle=nil;
    if([SoclivityUtilities deviceType] & iPhone5){
        nibNameBundle=@"WelcomeScreenViewControllerIphone5";
    }
    else{
        nibNameBundle=@"WelcomeScreenViewController";
    }
    WelcomeScreenViewController *welcomeScreenViewController=[[WelcomeScreenViewController alloc]initWithNibName:nibNameBundle bundle:nil];
    navigationController=[[UINavigationController alloc]initWithRootViewController:welcomeScreenViewController];
    [welcomeScreenViewController release];
    UINavigationBar *NavBar = [navigationController navigationBar];
    
    if ([NavBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        // set globablly for all UINavBars
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed: @"S01.2_blackbar.png"] forBarMetrics:UIBarMetricsDefault];
        
        // could optionally set for just this navBar
        //[navBar setBackgroundImage:...
    }


    
    [navigationController setNavigationBarHidden:YES];
    [self.window addSubview:navigationController.view];

    [self.window makeKeyAndVisible];
    [self registerForNotifications];
    return YES;
}

-(void)registerForNotifications {
	UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:type];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    NSString *token = [[NSString stringWithFormat:@"%@",deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"device_token"];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	NSDictionary* notifUserInfo = Nil;
	if (!_appIsInbackground) {
		
		NSArray *notifArray = [NSArray arrayWithObject:kShowAlertKey];
		notifUserInfo = [[NSDictionary alloc] initWithObjects:notifArray forKeys:notifArray];
	}
    else{
        NSNotification* notification = [NSNotification notificationWithName:kRemoteNotificationBackgroundNotification object:userInfo userInfo:notifUserInfo];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        [notifUserInfo release];
    }
	NSNotification* notification = [NSNotification notificationWithName:kRemoteNotificationReceivedNotification object:userInfo userInfo:notifUserInfo];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
	[notifUserInfo release];
}



-(void)setUpActivityDataList{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Activities" withExtension:@"plist"];
    NSArray *playDictionariesArray = [[NSArray alloc ] initWithContentsOfURL:url];
    NSMutableArray *playsArray = [NSMutableArray arrayWithCapacity:[playDictionariesArray count]];
    
    for (NSDictionary *playDictionary in playDictionariesArray) {
        
        InfoActivityClass *play = [[InfoActivityClass alloc] init];
        play.activityName = [playDictionary objectForKey:@"activityName"];
        play.organizerName=[playDictionary objectForKey:@"organizerName"];
        NSNumber * n = [playDictionary objectForKey:@"type"];
        play.type= [n intValue];
        NSNumber * DOS = [playDictionary objectForKey:@"DOS"];
        play.DOS= [DOS intValue];
        play.distance=[playDictionary objectForKey:@"distance"];
        play.goingCount=[playDictionary objectForKey:@"goingCount"];
        play.where_lat=[playDictionary objectForKey:@"Latitude"];
        play.where_lng=[playDictionary objectForKey:@"Longitude"];
        play.when=[playDictionary objectForKey:@"Date"];
        if([SoclivityUtilities ValidActivityDate:play.when]){
        NSString *message=[SoclivityUtilities NetworkTime:play];
        NSLog(@"message=%@",message);
        NSArray *quotationDictionaries = [playDictionary objectForKey:@"detailQuotations"];
        NSMutableArray *quotations = [NSMutableArray arrayWithCapacity:[quotationDictionaries count]];
        
        for (NSDictionary *quotationDictionary in quotationDictionaries) {
            
            DetailInfoActivityClass *quotation = [[DetailInfoActivityClass alloc] init];
            [quotation setValuesForKeysWithDictionary:quotationDictionary];
            
            [quotations addObject:quotation];
            [quotation release];
        }
        play.quotations = quotations;
        
        [playsArray addObject:play];
        [play release];
        }
    }
    
    [SoclivityUtilities setPlayerActivities:playsArray];
    [playDictionariesArray release];

}


-(FacebookLogin*)SetUpFacebook{
    FacebookLogin *login=[[FacebookLogin alloc]init];

    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:login];
    
    // Check and retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    
    // Initialize user permissions
    userPermissions = [[NSMutableDictionary alloc] initWithCapacity:1];
    [login setUpPermissions];
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    // Check App ID:
    // This is really a warning for the developer, this should not
    // happen in a completed app
    if (!kAppId) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Setup Error"
                                  message:@"Missing app ID. You cannot run the app until you provide this in the code."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil,
                                  nil];
        [alertView show];
        [alertView release];
    } else {
        // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
        // be opened, doing a simple check without local app id factored in here
        NSString *url = [NSString stringWithFormat:@"fb%@://authorize",kAppId];
        BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
        NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
        if ([aBundleURLTypes isKindOfClass:[NSArray class]] &&
            ([aBundleURLTypes count] > 0)) {
            NSDictionary* aBundleURLTypes0 = [aBundleURLTypes objectAtIndex:0];
            if ([aBundleURLTypes0 isKindOfClass:[NSDictionary class]]) {
                NSArray* aBundleURLSchemes = [aBundleURLTypes0 objectForKey:@"CFBundleURLSchemes"];
                if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                    ([aBundleURLSchemes count] > 0)) {
                    NSString *scheme = [aBundleURLSchemes objectAtIndex:0];
                    if ([scheme isKindOfClass:[NSString class]] &&
                        [url hasPrefix:scheme]) {
                        bSchemeInPlist = YES;
                    }
                }
            }
        }
        // Check if the authorization callback will work
        BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
        if (!bSchemeInPlist || !bCanOpenUrl) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Setup Error"
                                      message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,
                                      nil];
            [alertView show];
            [alertView release];
        }
    }
    return login;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[self facebook] extendAccessTokenIfNeeded];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url];
}
@end
