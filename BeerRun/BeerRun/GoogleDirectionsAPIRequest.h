//
//  GoogleDirectionsAPIRequest.h
//  BeerRun
//
//  Created by Michael Vaughn on 8/24/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface GoogleDirectionsAPIRequest : NSObject

@property (nonatomic) CLLocationCoordinate2D origin;
@property (nonatomic, strong) NSString *destination;


@end
