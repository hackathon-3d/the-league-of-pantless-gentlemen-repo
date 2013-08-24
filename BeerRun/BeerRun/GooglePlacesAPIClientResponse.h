//
//  GooglePlacesAPIClientResponse.h
//  BeerRun
//
//  Created by Michael Vaughn on 8/24/13.
//  Copyright (c) 2013 LeagueOfPantlessGentlemen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GooglePlacesAPIClientResponse : NSObject

@property (nonatomic, strong) NSString *barName;
@property (nonatomic) NSInteger distance;
@property (nonatomic, strong) NSMutableArray *route;

@end
