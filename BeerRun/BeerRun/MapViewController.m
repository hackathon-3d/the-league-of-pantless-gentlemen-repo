//
//  MapViewController.m
//  BeerRun
//
//  Created by Jonathan Spohn on 8/23/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "GooglePlacesAPIClient.h"
#import "GooglePlacesAPIClientRequest.h"
#import "GooglePlacesAPIClientResponse.h"


@interface MapViewController ()

@end

#define METERS_PER_MILE 1609.344

@implementation MapViewController

UIAlertView *_alert;
UIActivityIndicatorView *_progress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self updateMapWithRoute];
    _alert = [[UIAlertView alloc] initWithTitle: @"Loading..." message: nil delegate:self cancelButtonTitle: nil otherButtonTitles: nil];
    _progress = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(125, 50, 30, 30)];
    _progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_alert addSubview: _progress];
    [_progress startAnimating];
    [_alert show];
    if(_callTimer)
    {
        [_callTimer invalidate];
        _callTimer=nil;
    }
    _callTimer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(centerMap) userInfo:nil repeats:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    //[self updateMapWithRoute];
      
}

-(void)viewWillDisappear:(BOOL)animated{
    //[_mapView removeOverlay:_routeLine];
}

-(void)updateMapWithRoute
{
    
    _locationManager = [(AppDelegate*)[UIApplication sharedApplication].delegate locationManager];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = _locationManager.location.coordinate.latitude;
    zoomLocation.longitude= _locationManager.location.coordinate.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    GooglePlacesAPIClient *googleClient = [[GooglePlacesAPIClient alloc] init];
    GooglePlacesAPIClientRequest *request = [[GooglePlacesAPIClientRequest alloc] init];
    request.location = zoomLocation;
    request.distance = _mileRange;

    request.callbackBlock = ^(GooglePlacesAPIClientResponse *response) {
        
        NSLog(@"Done: %i", response.distance);

        _arrRoutePoints = [[NSArray alloc] initWithArray:response.route];
        
        MKMapPoint * pointsArray = malloc(sizeof(CLLocationCoordinate2D)* [_arrRoutePoints count] );
        
        int i = 0;
        for(CLLocation *object in _arrRoutePoints){
            pointsArray[i] = MKMapPointForCoordinate(object.coordinate);
            NSLog(@"%f,%f",object.coordinate.latitude,object.coordinate.longitude);
            i++;
        }
        
        _routeLine = [MKPolyline polylineWithPoints:pointsArray count:i];
        free(pointsArray);
        
        //add an anotation at the destination
        // Add an annotation
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = [[_arrRoutePoints objectAtIndex:_arrRoutePoints.count -1] coordinate];
        point.title = response.barName;
        point.subtitle = @"Beer.";
        
        [self.mapView addAnnotation:point];
        
        [[self mapView] addOverlay:_routeLine];
        [_mapView setRegion:viewRegion animated:YES];
        //[self performSegueWithIdentifier:@"test" sender:self];
        
        
    
    
    };
    [googleClient queryGooglePlaces:request withGoogleType:@"bar"];
     

}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView* overlayView = nil;
    self.routeLineView = [[MKPolylineView alloc] initWithPolyline:[self routeLine]];
    [[self routeLineView] setFillColor:[UIColor colorWithRed:167/255.0f green:210/255.0f blue:244/255.0f alpha:1.0]];
    [[self routeLineView] setStrokeColor:[UIColor colorWithRed:106/255.0f green:151/255.0f blue:232/255.0f alpha:1.0]];
    [[self routeLineView] setLineWidth:15.0];
    [[self routeLineView] setLineCap:kCGLineCapRound];
    overlayView = [self routeLineView];
    return overlayView;
}

#pragma mark - taxi section

- (IBAction)taxiButtonPressed:(id)sender {

    UIAlertView *alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Confirm Taxi"];
    [alert setMessage:@"Are you really giving up and need a Taxi?"];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if ( buttonIndex == 0 && ![[alertView title] isEqualToString:@"No Route Found"] )
    {
        // Yes, do something
        //[self performSegueWithIdentifier:@"taxiSegue" sender:self];
        
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = _locationManager.location.coordinate.latitude;
        zoomLocation.longitude= _locationManager.location.coordinate.longitude;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = @"Taxi";
        request.region = viewRegion;
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
        
        [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if (error != nil) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                            message:[error localizedDescription]
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
                return;
            }
            
            if ([response.mapItems count] == 0) {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
                return;
            }
            
            NSArray *mapItemsArray = response.mapItems;
            NSDictionary *dictForDirections = @{MKLaunchOptionsMapTypeKey: [NSNumber numberWithInt:1], MKLaunchOptionsMapTypeKey: @2};
            
            [MKMapItem openMapsWithItems:mapItemsArray launchOptions:dictForDirections];
            
            //[self.searchDisplayController.searchResultsTableView reloadData];
        }];
        
    }
    else if (buttonIndex == 1)
    {
        // No
    }
}

- (void)centerMap
{
    [_alert dismissWithClickedButtonIndex:1 animated:YES];
    if ( _arrRoutePoints.count == 0 ) {
        _alert = [[UIAlertView alloc] initWithTitle: @"No Route Found" message: @"Could not find a suitable route. Please try again." delegate:self cancelButtonTitle: @"OK" otherButtonTitles: nil];
        //progress= [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(125, 50, 30, 30)];
        //progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        //[alert addSubview: progress];
        //[progress startAnimating];
        [_alert show];
        
    } else {
    
        MKCoordinateRegion region;
    
        CLLocationDegrees maxLat = -90;
        CLLocationDegrees maxLon = -180;
        CLLocationDegrees minLat = 90;
        CLLocationDegrees minLon = 180;
    
        for(int idx = 0; idx < _arrRoutePoints.count; idx++)
        {
            CLLocation* currentLocation = [_arrRoutePoints objectAtIndex:idx];
        
            if(currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if(currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
    
        
        }
    
        NSLog(@"%i", _arrRoutePoints.count);
    
        region.center.latitude     = (maxLat + minLat) / 2;
        region.center.longitude    = (maxLon + minLon) / 2;
        region.span.latitudeDelta  = maxLat - minLat + 0.03;
        region.span.longitudeDelta = maxLon - minLon + 0.03;
    
    
    
        [_mapView setRegion:region animated:YES];
        [self performSegueWithIdentifier:@"test" sender:self];
    }
    
}
- (IBAction)randomSong:(id)sender {
    //Create an instance of MPMusicPlayerController
    MPMusicPlayerController* myPlayer = [MPMusicPlayerController applicationMusicPlayer];

    //Create a query that will return all songs by The Beatles grouped by album
    //[query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:@"The Beatles" forProperty:MPMediaItemPropertyArtist comparisonType:MPMediaPredicateComparisonEqualTo]];
    //[query setGroupingType:MPMediaGroupingAlbum];


    MPMediaQuery* query = [MPMediaQuery songsQuery];
    NSArray *songs = [query items];
    MPMediaItem *randomTrack = [songs objectAtIndex:arc4random_uniform([songs count])];


    //Pass the query to the player
    [myPlayer setQueueWithQuery:query];
    [myPlayer setShuffleMode:MPMusicShuffleModeAlbums];
    //Start playing and set a label text to the name and image to the cover art of the song that is playing
    [myPlayer play];
    //_someLabel.text = [myPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    //_someImageView.image = [myPlayer.nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
}

@end
