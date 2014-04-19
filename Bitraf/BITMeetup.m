//
//  BITMeetup.m
//  Bitraf
//
//  Created by Alexander Alemayhu on 19.04.14.
//  Copyright (c) 2014 Bitraf. All rights reserved.
//

#import "BITMeetup.h"

@implementation BITMeetup

+(BITMeetup *) withDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

-(id) initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        
        
        // Annoying that __NSCFString wont let me use longValue.
        _name = [dict objectForKey:@"name"];
        _description = [dict objectForKey:@"description"];
    }
    
    return self;
}

@end
