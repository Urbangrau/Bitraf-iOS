//
//  BITMeetup.h
//  Bitraf
//
//  Created by Alexander Alemayhu on 19.04.14.
//  Copyright (c) 2014 Bitraf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BITMeetup : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *description;

+(BITMeetup *) withDict:(NSDictionary *)dict;
-(id) initWithDict:(NSDictionary *)dict;
@end
