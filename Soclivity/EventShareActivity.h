//
//  EventShareActivity.h
//  Soclivity
//
//  Created by Kanav Gupta on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventShareActivity : NSObject{
    
    NSString *localIdentifier;
}
-(void)sendEvent;
@end
