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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self updateMapWithRoute];
      
}

-(void*)updateMapWithRoute
{
    _locationManager = [(AppDelegate*)[UIApplication sharedApplication].delegate locationManager];
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = _locationManager.location.coordinate.latitude;
    zoomLocation.longitude= _locationManager.location.coordinate.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    [_mapView setRegion:viewRegion animated:YES];
    
    
     
     
     
    GooglePlacesAPIClient *googleClient = [[GooglePlacesAPIClient alloc] init];
    GooglePlacesAPIClientRequest *request = [[GooglePlacesAPIClientRequest alloc] init];
    request.location = zoomLocation;
    request.distance = _mileRange;
    request.callbackBlock = ^(GooglePlacesAPIClientResponse *response) { NSLog(@"Done: %i", response.distance); };
    [googleClient queryGooglePlaces:request withGoogleType:@"bar"];
     
    /*
    
    //NSLog( [NSString stringWithFormat:@"%i", _mileRange ]);

    //TEMP TO GET ARRAY OF POINTS
    _googleClient = [[GooglePlacesAPIClient alloc] init];
    //[_googleClient queryGooglePlaces:zoomLocation withGoogleType:@"bar" andDistance: _mileRange * 1000];
    
    
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:_locationManager.location.coordinate.latitude longitude:_locationManager.location.coordinate.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:79.8456 longitude:32.8231];
    
    _arrRoutePoints = [[NSMutableArray alloc] init];
    
    [_arrRoutePoints addObject:loc1];
    [_arrRoutePoints addObject:loc2];
    
    //USING TEMP CREATE POINTS
    MKMapPoint * pointsArray = malloc(sizeof(CLLocationCoordinate2D)*2);
    
    int i = 0;
    for(CLLocation *object in _arrRoutePoints){
        pointsArray[i] = MKMapPointForCoordinate(object.coordinate);
        i++;
    }
    
    _routeLine = [MKPolyline polylineWithPoints:pointsArray count:i];
    free(pointsArray);
    
    
    [[self mapView] addOverlay:_routeLine];
     */

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


@end
