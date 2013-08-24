//
//  GooglePlacesAPIClientRequest.h
//  BeerRun
//
//  Created by Michael Vaughn on 8/24/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


typedef void(^CallbackBlock)(NSArray *);

@interface GooglePlacesAPIClientRequest : NSObject

@property(nonatomic) CLLocationCoordinate2D location;
@property(nonatomic) NSInteger distance;
@property(nonatomic, strong) NSMutableArray *response;
@property(nonatomic, copy) CallbackBlock callbackBlock;



@end
