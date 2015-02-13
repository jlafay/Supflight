//
//  ViewController.m
//  Supflight
//
//  Created by Harmony on 15/06/2014.
//  Copyright (c) 2014 harmony. All rights reserved.
//

#import "ViewController.h"
#import "Flight.h"
#import "SupORM.h"
#include <stdlib.h>
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize chronoLabel;
@synthesize dateLabel;
@synthesize dateLabel2;
@synthesize durationLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    second = 0;
    minute = 0;
    hour = 0;
    start = 0;
}

-(void)chrono
{
    second++;
    if (second == 60) {
        second = 0;
        minute ++;
        if (minute == 60) {
            minute = 0;
            hour++;
        }
        chronoLabel.text = [NSString stringWithFormat: @"%i:%i:%i",hour, minute, second];
    }
    else {
        chronoLabel.text = [NSString stringWithFormat: @"%i:%i:%i",hour, minute, second];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(id)sender {
    if(start == 0){
        NSDate *date = [NSDate date];
        NSDateFormatter *miseEnForme = [[NSDateFormatter alloc] init];
        
        [miseEnForme setTimeStyle:NSDateFormatterMediumStyle];
        
        [miseEnForme setDateStyle:NSDateFormatterMediumStyle];
        
        NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
        [miseEnForme setLocale:frLocale];
        
        NSString *dateName = @"Departure : ";
        NSString *dateFormated = [miseEnForme stringFromDate:date];
        departure = [NSString stringWithFormat:@"%@%@",dateName,dateFormated];
        dateLabel.text = [NSString stringWithFormat:@"%@%@",dateName,dateFormated];
        dateLabel2.text = @"";
        durationLabel.text = @"";
        
        chronoLabel.text = [NSString stringWithFormat: @"%i:%i:%i",hour, minute, second];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(chrono) userInfo:nil repeats:YES];
        start = 1;
    }
    else {
        [timer invalidate];
        timer = nil;
        NSDate *date2 = [NSDate date];
        NSDateFormatter *miseEnForme2 = [[NSDateFormatter alloc] init];
        
        [miseEnForme2 setTimeStyle:NSDateFormatterMediumStyle];
        
        [miseEnForme2 setDateStyle:NSDateFormatterMediumStyle];
        
        NSLocale *frLocale2 = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
        [miseEnForme2 setLocale:frLocale2];
        
        NSString *dateName2 = @"Arrival : ";
        NSString *dateFormated2 = [miseEnForme2 stringFromDate:date2];
        dateLabel2.text = [NSString stringWithFormat:@"%@%@",dateName2,dateFormated2];
        durationLabel.text = [NSString stringWithFormat: @"Duration : %i:%i:%i",hour, minute, second];
        
        Flight * flight = [[Flight alloc] init];
        flight.flightName = @"flight";
        flight->departure = departure;
        flight->arrival = [NSString stringWithFormat:@"%@%@",dateName2,dateFormated2];
        flight->duration = [NSString stringWithFormat: @"Duration : %i:%i:%i",hour, minute, second];
        [flight insertObject];
        
        second = 0;
        minute = 0;
        hour = 0;
        chronoLabel.text = [NSString stringWithFormat: @"%i:%i:%i",hour, minute, second];
        start = 0;
    }
}

/*
 UIButton *monBouton = [UIButton buttonWithType:UIButtonTypeRoundedRect ];
 [monBouton setFrame:CGRectMake(100.0f, 100.0f, 100.0f, 20.0f)];
 [monBouton setTitle: @"Mon bouton" forState: UIControlStateNormal];
 [monBouton addTarget:self action:@selector(startStop) forControlEvents:UIControlEventTouchUpInside];
 [self.view addSubview: monBouton];
- (void)startStop {
    if(start == 0){
        NSDate *date = [NSDate date];
        NSDateFormatter *miseEnForme = [[NSDateFormatter alloc] init];
        
        [miseEnForme setTimeStyle:NSDateFormatterMediumStyle];
        
        [miseEnForme setDateStyle:NSDateFormatterMediumStyle];
        
        NSLocale *frLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"fr_FR"];
        [miseEnForme setLocale:frLocale];
        
        NSString *dateName = @"Departure : ";
        NSString *dateFormated = [miseEnForme stringFromDate:date];
        dateLabel.text = [NSString stringWithFormat:@"%@%@",dateName,dateFormated];
        
        chronoLabel.text = [NSString stringWithFormat: @"%i:%i:%i",hour, minute, second];
        timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(chrono) userInfo:nil repeats:YES];
        start = 1;
    }
    else {
        dateLabel.text = @"fin";
        start = 0;
    }
}
*/

@end
