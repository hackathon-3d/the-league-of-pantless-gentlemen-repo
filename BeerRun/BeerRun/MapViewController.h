//
//  MapViewController.h
//  BeerRun
//
//  Created by Jonathan Spohn on 8/23/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "GooglePlacesAPIClient.h"


@interface MapViewController : UIViewController <MKMapViewDelegate, UIAlertViewDelegate>

@property (nonatomic) int mileRange;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) NSMutableArray *arrRoutePoints;
@property (strong, nonatomic) MKPolyline *objPolyline;

@property (strong, nonatomic) GooglePlacesAPIClient *googleClient;

@property (nonatomic, strong) MKPolyline* routeLine;
@property (nonatomic, strong) MKPolylineView* routeLineView;
@property (nonatomic, strong) NSMutableArray *trackPointArray;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, readwrite) MKMapRect routeRect;


@end
