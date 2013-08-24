//
//  TaxiTable.h
//  BeerRun
//
//  Created by Jonathan Spohn on 8/24/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GooglePlacesAPIClient.h"
#import "AppDelegate.h"

@interface TaxiTable : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *taxiList;

@end
