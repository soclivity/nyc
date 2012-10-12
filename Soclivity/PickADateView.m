//
//  PickADateView.m
//  Soclivity
//
//  Created by Kanav on 10/10/12.
//
//

#import "PickADateView.h"
#import "SoclivityUtilities.h"
@implementation PickADateView
@synthesize delegate,editActivity;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(IBAction)crossButtonClicked:(id)sender{
    [delegate dismissPicker:sender];
}

-(IBAction)tickButtonPressed:(id)sender{
    
    NSDate *activityDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"ActivityDate"];
    
    if(activityDate==nil){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Select A Date To Continue" message:nil
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        [alert release];
        return;
        
        
    }
    else{

    
        [delegate activityDateSelected:[[NSUserDefaults standardUserDefaults] valueForKey:@"ActivityDate"]];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(editActivity){
        pickADateLabel.text=@"Change date";
    }
    else

    pickADateLabel.text=@"Pick a date";
    
    pickADateLabel.font=[UIFont fontWithName:@"Helvetica-Condensed-Bold" size:18];
    pickADateLabel.textColor=[UIColor whiteColor];
    pickADateLabel.backgroundColor=[UIColor clearColor];
    pickADateLabel.shadowColor = [UIColor blackColor];
    pickADateLabel.shadowOffset = CGSizeMake(0,-1);

    
    calendarDate=[[CalendarDateView alloc]initWithFrame:CGRectMake(0, 44, 320,254)];
    calendarDate.KALDelegate=self;
    calendarDate.pickADateForActivity=TRUE;
    [self addSubview:calendarDate];


}


@end
