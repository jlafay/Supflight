//
//  FlightTableViewController.m
//  Supflight
//
//  Created by Harmony on 19/06/2014.
//  Copyright (c) 2014 harmony. All rights reserved.
//

#import "FlightTableViewController.h"
#import "SupORM.h"
#import "Flight.h"
#import "FlightDetailViewController.h"

@interface FlightTableViewController ()

@end

@implementation FlightTableViewController
@synthesize arrItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Flight * flight = [[Flight alloc] init];
    NSArray * dbArray = [flight load];
    NSMutableArray * arrItemsString = [NSMutableArray array];
    NSString *objectString;
    for (Flight * object in dbArray)
    {
        objectString = [NSString stringWithFormat:@"%@ - %@ - %@", object->departure, object->arrival, object->duration];
        
        [arrItemsString addObject:objectString];
    }
    arrItems = arrItemsString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [arrItems objectAtIndex:indexPath.row];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"detailSegue"])
    {
        NSInteger selectedIndex = [[self.tableView indexPathForSelectedRow] row];
        FlightDetailViewController *fdvc = [segue destinationViewController];
        fdvc.texteAAfficher = [NSString stringWithFormat:@"%@", [arrItems objectAtIndex:selectedIndex]];
    }
}


@end
