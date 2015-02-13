//
//  SupORM.m
//  SupORM
//
//  Created by Harmony on 25/03/2014.
//  Copyright (c) 2014 harmony. All rights reserved.
//

#import "SupORM.h"
#import "FMDatabase.h"
#import <objc/runtime.h>
#import <objc/NSObjCRuntime.h>
#import <Foundation/Foundation.h>


@implementation SupORM

-(instancetype)initWithClass:(Class)cls
{
    if((self = [super init])){
        /*
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"SupORM.sqlite"];
        db = [FMDatabase databaseWithPath:writableDBPath];
        */
        db = [FMDatabase databaseWithPath:@"/Users/harmony/Desktop/Supfligh/SupFlight.sqlite"];
        
        self->c = cls;
        self->identifier = 0;
        self->cName = NSStringFromClass(self->c);
        self->alReadyExist = NO;
        [self loadClassMembers];
    }
    
    return self;
}

-(void)loadClassMembers
{
    dictionnary = [[NSMutableDictionary alloc] init];
    arrayName = [[NSMutableArray alloc] init];
    arrayTypeDB = [[NSMutableArray alloc] init];
    arrayType = [[NSMutableArray alloc] init];
    
    unsigned int counter  = 0;
    const char * name;
    const char * attribute;
    objc_property_t * p;
    Ivar * ivar;
    int i;
    
    p = class_copyPropertyList(self->c, &counter);
    for (i=0; i < counter; i++){
        objc_property_t aProp = p[i];
        name = property_getName(aProp);
        attribute = property_getAttributes(aProp);
        [self->dictionnary setObject:[NSString stringWithUTF8String:attribute] forKey:[NSString stringWithUTF8String:name]];
    }
    
    ivar = class_copyIvarList(self->c, &counter);
    for (i=0; i<counter; i++){
        Ivar aIvar = ivar[i];
        name = ivar_getName(aIvar);
        attribute = ivar_getTypeEncoding(aIvar);
        
        if(name[0] != '_'){
            [self->dictionnary setObject:[NSString stringWithUTF8String:attribute] forKey:[NSString stringWithUTF8String:name]];
        }
    }
    
    for (NSString * key in dictionnary){
        if([self convertTypeDB:[dictionnary objectForKey:key]] != nil){
            [arrayName addObject:key];
            [arrayTypeDB addObject:[self convertTypeDB:[dictionnary objectForKey:key]]];
            [arrayType addObject:[self convertType:[dictionnary objectForKey:key]]];
        }
    }
}

-(NSString *)convertTypeDB:(NSString *)attrib
{
    if ([attrib isEqualToString:@"I"]|| [attrib isEqualToString:@"i"] || [attrib isEqualToString:@"l"] || [attrib isEqualToString:@"L"]||[attrib isEqualToString:@"B"]){
        return @"INTEGER";
    }
    else if ([attrib isEqualToString:@"f"] || [attrib isEqualToString:@"d"]){
        return @"REAL";
    }
    else if (![attrib isEqualToString:@"@\"NSString\""]){
        NSScanner * scan = [NSScanner scannerWithString:attrib];
            
        NSCharacterSet * ignored = [NSCharacterSet characterSetWithCharactersInString:@"T"];
        [scan setCharactersToBeSkipped:ignored];
        NSString * testType;
        [scan scanUpToString:@"," intoString:&testType];
        if ([testType length] == 1){
            return [self convertTypeDB:testType];
        }
    }
    else{
        return @"TEXT";
    }
    
    return nil;
}

-(NSString *)convertType:(NSString * )attri
{
    NSMutableString * type =  [[NSMutableString alloc] init];
    [type setString:@"N"];
    
    if ([attri length] == 1){
        if([attri isEqualToString:@"I"] || [attri isEqualToString:@"i"])
        {
            [type setString:@"I"];
        }
        
        if([attri isEqualToString:@"l"] || [attri isEqualToString:@"L"])
        {
            [type setString:@"L"];
        }
        
        if([attri isEqualToString:@"B"])
        {
            [type setString:@"B" ];
        }
        
        if([attri isEqualToString:@"f"])
        {
            [type setString :@"F"];
        }
        
        if([attri isEqualToString:@"d"])
        {
            [type setString: @"B"];
        }
    }
    if ([attri isEqualToString:@"@\"NSString\""]){
        [type setString:@"NSS"];
    }
    
    return type;
}

-(void)insertObject
{
    if (alReadyExist){
        if ([db open]){
            NSMutableString * prepStatement = [NSMutableString stringWithFormat:@"INSERT INTO %@ VALUES (", self ->cName];
            
            for (int i= 0; i < [arrayName count]; i++){
                if(i != 0){
                    [prepStatement appendString:@","];
                }
                if (![[arrayType objectAtIndex:i] isEqualToString:@"NSS"]){
                    [prepStatement appendString:[NSString stringWithFormat:@" %@ ", [self valueForKey:[arrayName objectAtIndex:i]]]];
                }
                else{
                    [prepStatement appendString:[NSString stringWithFormat:@" '%@' ", [self valueForKey:[arrayName objectAtIndex:i]]]];
                }
            }
            [prepStatement appendString:@",null);"];
            [db executeUpdate:prepStatement];
            
            FMResultSet * rS = [db executeQuery:[NSString stringWithFormat:@"SELECT identifier_%@ FROM %@ ORDER BY identifier_%@",self->cName, self->cName, self->cName]];
            if([rS next]){
                self->identifier = [rS longForColumnIndex:0];
            }
            
            [db close];
        }
    }
    else{
        if ([db open]){
            
            NSString * preStatement = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@';",NSStringFromClass(self->c)];
            FMResultSet *rSet = [db executeQuery:preStatement];
            if (![rSet next]){
                NSMutableString * createTable = [NSMutableString stringWithFormat:@"CREATE TABLE %@ (", self->cName];
                for (int i= 0; i < [arrayName count]; i++){
                    if(i != 0){
                        [createTable appendString:@","];
                    }
                    [createTable appendString:[NSString stringWithFormat:@"%@ %@", [arrayName objectAtIndex:i], [arrayTypeDB objectAtIndex:i]]];
                }
                [createTable appendString:[NSString stringWithFormat:@",identifier_%@ INTEGER PRIMARY KEY);",self->cName]];
                [db executeUpdate:createTable];
            }
            self->alReadyExist = YES;
            [db close];
        }
        [self insertObject];
    }
}

-(NSArray *)load
{
    NSMutableString * select = [NSMutableString stringWithFormat:@"SELECT * FROM  %@;", self->cName];
    NSMutableArray * final = [[NSMutableArray alloc] init];
    
    if ([db open])
    {
        FMResultSet * resultSet = [db executeQuery:select];
        while ([resultSet next]){
            id tmp = [[NSClassFromString(self->cName) alloc]init];
            
            for (int i= 0; i < [arrayName count]; i++){
                NSString *type = [arrayType objectAtIndex:i];
                
                if([type isEqualToString:@"I"])
                {
                    [tmp setValue:[NSNumber numberWithInteger:[resultSet intForColumnIndex:i]] forKeyPath:[arrayName objectAtIndex:i]];
                }
                
                if([type isEqualToString:@"L"])
                {
                    [tmp setValue:[NSNumber numberWithLong:[resultSet longForColumnIndex:i]] forKeyPath:[arrayName objectAtIndex:i]];
                }
                
                if([type isEqualToString:@"B"])
                {
                    [tmp setValue:[NSNumber numberWithInteger:[resultSet intForColumnIndex:i]] forKeyPath:[arrayName objectAtIndex:i]];
                }
                
                if([type isEqualToString:@"F"])
                {
                    [tmp setValue:[NSNumber numberWithFloat:[resultSet doubleForColumnIndex:i]] forKeyPath:[arrayName objectAtIndex:i]];
                }
                
                if([type isEqualToString:@"D"])
                {
                    [tmp setValue:[NSNumber numberWithDouble:[resultSet doubleForColumnIndex:i]] forKeyPath:[arrayName objectAtIndex:i]];
                }
                if ([type isEqualToString:@"NSS"])
                {
                    [tmp setValue:[resultSet stringForColumnIndex:i] forKeyPath:[arrayName objectAtIndex:i]];
                }

            }
            
            [final addObject:tmp];
        }
    }
    return final;
}

@end

