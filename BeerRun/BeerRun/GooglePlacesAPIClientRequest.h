//
//  GooglePlacesAPIClientRequest.h
//  BeerRun
//
//  Created by Michael Vaughn on 8/24/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GooglePlacesAPIClientResponse.h"


typedef void(^CallbackBlock)(GooglePlacesAPIClientResponse *);

@interface GooglePlacesAPIClientRequest : NSObject

@property(nonatomic) CLLocationCoordinate2D location;
@property(nonatomic) NSInteger distance;
@property(nonatomic, strong) GooglePlacesAPIClientResponse *response;
@property(nonatomic, copy) CallbackBlock callbackBlock;



@end
