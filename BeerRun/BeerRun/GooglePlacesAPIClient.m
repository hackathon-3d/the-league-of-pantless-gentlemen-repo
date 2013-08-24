//
//  GooglePlacesAPIClient.m
//  BeerRun
//
//  Created by Michael Vaughan on 8/24/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import "GooglePlacesAPIClient.h"
#import <MapKit/MapKit.h>
#import "GoogleDirectionsAPIRequest.h"

#define kGOOGLE_API_KEY @"AIzaSyBMPu1-OpI8S47CnVCpaT5E4BCmSLxTDQ0"
#define kMETERS_PER_MILE 1609.34

@implementation GooglePlacesAPIClient

int _currentlyProcessingCount;

-(id)init{
    self = [super init];
    _currentlyProcessingCount = 0;
    return self;
}

-(void) queryGooglePlaces: (GooglePlacesAPIClientRequest *) request  withGoogleType: (NSString *) googleType  {

    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@",
                     request.location.latitude,
                     request.location.longitude,
                     [NSString stringWithFormat:@"%f", (request.distance * kMETERS_PER_MILE)],
                     googleType,
                     kGOOGLE_API_KEY];
    
    //NSLog(url);
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelector:@selector(fetchedData::) withObject:data withObject:request];
    });
}

-(void)fetchedData:(NSData *) responseData :(GooglePlacesAPIClientRequest *) request{
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    for (id place in places) {
        _currentlyProcessingCount++;
        //NSLog(@"%@", [[place objectForKey:@"geometry"] objectForKey:@"location"]);
        GoogleDirectionsAPIRequest *directionsRequest = [[GoogleDirectionsAPIRequest alloc] init];
        [directionsRequest setOrigin:request.location];
        [directionsRequest setDestination:[NSString stringWithFormat:@"%@,%@", [[[place objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"], [[[place objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lng"]]];
        [self queryGoogleDirections:directionsRequest:request];
               
               
               
               //andDestination:];
    }
    
    //Write out the data to the console.
    //NSLog(@"Google Data: %@", places);
    
    // For each place, calculate the distance between current location and the place.
}


-(void) queryGoogleDirections: (GoogleDirectionsAPIRequest *) directionsRequest :(GooglePlacesAPIClient *) placesRequest {
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%@&sensor=true&mode=walking",
                     directionsRequest.origin.latitude,
                     directionsRequest.origin.longitude,
                     directionsRequest.destination];
    
    //NSLog(url);
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelector:@selector(fetchedRoute::) withObject:data withObject:placesRequest];
    });

    
}


-(void) fetchedRoute: (NSData *) responseData :(GooglePlacesAPIClientRequest *) request {
    
    //parse out the json data
    _currentlyProcessingCount--;
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* routes = [json objectForKey:@"routes"];
    
    if (routes != nil && [routes count] > 0) {
        for ( id leg in [[routes objectAtIndex:0] objectForKey:@"legs"] ) {
            //NSLog(@"%@", leg);
            
            CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([[[leg objectForKey:@"startLocation"] objectForKey:@"lat"] doubleValue], [[[leg objectForKey:@"startLocation"] objectForKey:@"lng"] doubleValue]);
            CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake([[[leg objectForKey:@"endLocation"] objectForKey:@"lat"] doubleValue], [[[leg objectForKey:@"endLocation"] objectForKey:@"lng"] doubleValue]);
            if ( ![request response] ) {
                [request setResponse:[NSMutableArray array]];
            }
            CLLocation *startLocation = [[CLLocation alloc] initWithLatitude:startCoordinate.latitude longitude:startCoordinate.longitude];
            CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:endCoordinate.latitude longitude:endCoordinate.longitude];
            [[request response] addObject:startLocation];
            [[request response] addObject:endLocation];
        }
    }
        
    if ( _currentlyProcessingCount == 0 ) {
        [request callbackBlock](request.response);
    }
    
    //Write out the data to the console.
    //NSLog(@"Google Data: %@", places);

    
}


@end
