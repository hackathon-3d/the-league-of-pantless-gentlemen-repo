//
//  GooglePlacesAPIClient.m
//  BeerRun
//
//  Created by Michael Vaughan on 8/24/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import "GooglePlacesAPIClient.h"

#define kGOOGLE_API_KEY @"AIzaSyBMPu1-OpI8S47CnVCpaT5E4BCmSLxTDQ0"

@implementation GooglePlacesAPIClient

-(void) queryGooglePlaces: (CLLocationCoordinate2D) currentLocation withGoogleType: (NSString *) googleType andDistance: (NSInteger) radius  {

    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@",
                     currentLocation.latitude,
                     currentLocation.longitude,
                     [NSString stringWithFormat:@"%i", radius],
                     googleType,
                     kGOOGLE_API_KEY];
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", places);
}

@end
