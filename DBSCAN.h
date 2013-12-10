//
//  DBSCAN.h
//  LocationClustering
//
//  Created by Erik Risinger on 12/10/13.
//  Copyright (c) 2013 KevinFernandes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPSLocation.h"

@interface DBSCAN : NSObject

-(NSMutableArray *)scanLocations:(NSMutableArray *)locations epsilonValue:(double)eps minPoints:(int)minPts;

@end
