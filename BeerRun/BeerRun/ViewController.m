//
//  ViewController.m
//  BeerRun
//
//  Created by Jonathan Spohn on 8/23/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import "ViewController.h"
#import "MapViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];
    
    [_mileRangeField setText:[NSString stringWithFormat:@"%d", (int)value]];
}
- (IBAction)runPressed:(id)sender {
    [self performSegueWithIdentifier:@"runSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [(MapViewController *)[segue destinationViewController] setMileRange:[[_mileRangeField text] intValue]];
}


@end
