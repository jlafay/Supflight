//
//  Flight.h
//  Supflight
//
//  Created by Harmony on 16/06/2014.
//  Copyright (c) 2014 harmony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupORM.h"

@interface Flight : SupORM
{
@public
    NSString *departure;
    NSString *arrival;
    NSString *duration;
}
-(id)init;
@property (nonatomic) NSString *flightName;
@end
