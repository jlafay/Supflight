//
//  ViewController.h
//  Supflight
//
//  Created by Harmony on 15/06/2014.
//  Copyright (c) 2014 harmony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SupORM.h"

@interface ViewController : UIViewController
{
    NSTimer *timer;
    int second;
    int minute;
    int hour;
    int start;
    NSString *departure;
}
- (IBAction)start:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *chronoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel2;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;

@end
