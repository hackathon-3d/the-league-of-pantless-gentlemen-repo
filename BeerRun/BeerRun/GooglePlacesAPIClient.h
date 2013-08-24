//
//  GooglePlacesAPIClient.h
//  BeerRun
//
//  Created by Michael Vaughan on 8/24/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GooglePlacesAPIClientRequest.h"


@interface GooglePlacesAPIClient : NSObject

-(void) queryGooglePlaces: (GooglePlacesAPIClientRequest *) request  withGoogleType: (NSString *) googleType;

@end
