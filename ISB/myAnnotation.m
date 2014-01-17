//
//  myAnnotation.m
//  MapView
//
//  Created by dev27 on 5/30/13.
//  Copyright (c) 2013 codigator. All rights reserved.
//

#import "myAnnotation.h"

@implementation myAnnotation
@synthesize tag;
//3.2
-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
  if ((self = [super init])) {
    self.coordinate =coordinate;
    self.title = title;
      
  }
  return self;
}

@end
