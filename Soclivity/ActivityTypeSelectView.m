//
//  ActivityTypeSelectView.m
//  Soclivity
//
//  Created by Kanav Gupta on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityTypeSelectView.h"
#import "GetPlayersClass.h"
@implementation ActivityTypeSelectView

@synthesize delegate,playerObj;

// Defining the transparency used to display the tick for activity categories selected
#define HIDDEN 0.2
#define SHOW 1.0

#define kPlay 0
#define kEat 1
#define kSee 2
#define kCreate 3
#define kLearn 4



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)getStartedClicked:(id)sender{
    [self MakeSureAtLeastOneActivitySelected];
}

-(IBAction)playActivityClicked:(id)sender{
    play=!play;

    if(play){
        playImageView.alpha=SHOW;
    }
    else{
        playImageView.alpha=HIDDEN;
    }
}
                                          
-(IBAction)eatActivityClicked:(id)sender{
    eat=!eat;
    
    if(eat){
        eatImageView.alpha=SHOW;
    }
    else{
        eatImageView.alpha=HIDDEN;
        
    }
}
-(IBAction)seeActivityClicked:(id)sender{
    see=!see;
    
    if(see){
        seeImageView.alpha=SHOW;
    }
    else{
        seeImageView.alpha=HIDDEN;
        
    }
}
-(IBAction)createActivityClicked:(id)sender{
    create=!create;
    
    if(create){
        createImageView.alpha=SHOW;
    }
    else{
        createImageView.alpha=HIDDEN;
        
    }
}
-(IBAction)learnActivityClicked:(id)sender{
    learn=!learn;
    
    if(learn){
        learnImageView.alpha=SHOW;
    }
    else{
        learnImageView.alpha=HIDDEN;
        
    }
}

-(void)MakeSureAtLeastOneActivitySelected{
    
    if(!play && !eat && !create && !see && !learn){
        NSLog(@"No Activity Selected");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nothing here interests you?"
                                                        message:@"C'mon, please select at least 1 activity type!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert show];
        [alert release];
        return;
    }
    else{
        NSString *activitySelect=nil;
        for(int i=0;i<5;i++){
            switch (i) {
                case kPlay:
                {
                    if(play){
                        if(activitySelect==nil)
                            activitySelect=[NSString stringWithFormat:@"1"];
                    }
                }
                    break;
                    
                case kEat:
                {
                    if(eat){
                        if(activitySelect==nil)
                            activitySelect=[NSString stringWithFormat:@"2"];
                        else{
                            activitySelect=[NSString stringWithFormat:@"%@,2",activitySelect];
                            
                        }
                    }
                }
                    break;
                case kSee:
                {
                    if(see){
                        if(activitySelect==nil)
                            activitySelect=[NSString stringWithFormat:@"3"];
                        else{
                            activitySelect=[NSString stringWithFormat:@"%@,3",activitySelect];
                            
                        }
                    }
                }
                    break;
                case kCreate:
                {
                    if(create){
                        if(activitySelect==nil)
                            activitySelect=[NSString stringWithFormat:@"4"];
                        else{
                            activitySelect=[NSString stringWithFormat:@"%@,4",activitySelect];
                            
                        }
                    }
                }
                    break;
                case kLearn:
                {
                    if(learn){
                        if(activitySelect==nil)
                            activitySelect=[NSString stringWithFormat:@"5"];
                        else{
                            activitySelect=[NSString stringWithFormat:@"%@,5",activitySelect];
                            
                        }
                    }
                }
                    break;


                    
            }
        }
        playerObj.activityTypes=activitySelect;
        [delegate pushHomeMapViewController];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}


@end
