//
//  TestViewController.m
//  BeerRun
//
//  Created by Jonathan Spohn on 8/24/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if(_callTimer)
    {
        [_callTimer invalidate];
        _callTimer=nil;
    }
    _callTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(die) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)die
{
    [self dismissViewControllerAnimated:NO completion:nil];
   
}

@end
