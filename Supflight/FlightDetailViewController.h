//
//  FlightDetailViewController.h
//  Supflight
//
//  Created by Harmony on 19/06/2014.
//  Copyright (c) 2014 harmony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlightDetailViewController : UIViewController

@property (strong, nonatomic) id texteAAfficher;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *donneeRecue;

@end

