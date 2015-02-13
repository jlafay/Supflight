//
//  SupORM.h
//  SupORM
//
//  Created by Harmony on 25/03/2014.
//  Copyright (c) 2014 harmony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "ActiveRecordProtocol.h"

@interface SupORM : NSObject <ActiveRecordProtocol>
{
@private
    FMDatabase * db;
    Class c;
    unsigned long identifier;
    NSString * cName;
    BOOL alReadyExist;
    NSMutableDictionary * dictionnary;
    NSMutableArray  * arrayName;
    NSMutableArray * arrayTypeDB;
    NSMutableArray * arrayType;
}

-(id)initWithClass:(Class)cls;
-(void)insertObject;
-(NSArray*)load;
@end