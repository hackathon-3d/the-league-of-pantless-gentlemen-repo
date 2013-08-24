//
//  ViewController.h
//  BeerRun
//
//  Created by Jonathan Spohn on 8/23/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIStepper *stepper;
@property (strong, nonatomic) IBOutlet UITextField *mileRangeField;
@property (strong, nonatomic) IBOutlet UIButton *runButton;

@end
