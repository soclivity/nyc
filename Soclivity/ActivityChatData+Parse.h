//
//  ActivityChatData+Parse.h
//  Soclivity
//
//  Created by Kanav Gupta on 08/03/13.
//
//
#import  <Foundation/Foundation.h>
#import "ActivityChatData.h"
@interface ActivityChatData (Parse)

+(NSMutableArray*)PlayersChatPertainingToActivity:(NSArray*)ACTArray;

@end
