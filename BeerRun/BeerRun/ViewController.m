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



- (IBAction)minusButtonPressed:(id)sender {
    
    double value = [[_mileRangeField text] intValue];
    
    if(value >= 1)
        [_mileRangeField setText:[NSString stringWithFormat:@"%d", (int)value - 1]];
}

- (IBAction)plusButtonPressed:(id)sender {
    double value = [[_mileRangeField text] intValue];
    
    [_mileRangeField setText:[NSString stringWithFormat:@"%d", (int)value + 1]];
}



- (IBAction)runPressed:(id)sender {
    [self performSegueWithIdentifier:@"runSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [(MapViewController *)[segue destinationViewController] setMileRange:[[_mileRangeField text] intValue]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"runSegue" sender:self];
    return YES;
}



//- (IBAction)musicButton:(id)sender {
//    //Create an instance of MPMusicPlayerController
//    MPMusicPlayerController* myPlayer = [MPMusicPlayerController applicationMusicPlayer];
//    
//    //Create a query that will return all songs by The Beatles grouped by album
//    //[query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:@"The Beatles" forProperty:MPMediaItemPropertyArtist comparisonType:MPMediaPredicateComparisonEqualTo]];
//    //[query setGroupingType:MPMediaGroupingAlbum];
//    
//    
//    MPMediaQuery* query = [MPMediaQuery songsQuery];
//    NSArray *songs = [query items];
//    MPMediaItem *randomTrack = [songs objectAtIndex:arc4random_uniform([songs count])];
//    
//    
//    //Pass the query to the player
//    [myPlayer setQueueWithQuery:query];
//    [myPlayer setShuffleMode:MPMusicShuffleModeAlbums];
//    //Start playing and set a label text to the name and image to the cover art of the song that is playing
//    [myPlayer play];
//    //_someLabel.text = [myPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
//    //_someImageView.image = [myPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
//}



@end
