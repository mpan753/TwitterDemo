//
//  Utility.h
//  TwiterDemo
//
//  Created by Mia on 5/12/16.
//  Copyright © 2016 Mia. All rights reserved.
//

#ifndef Utility_h
#define Utility_h

#ifndef CRSingleton
#define CRSingleton(classname, method)                                                                                                                                                                 \
+(classname *)shared##method {                                                                                                                                                                     \
static dispatch_once_t pred;                                                                                                                                                                   \
__strong static classname *shared##classname = nil;                                                                                                                                            \
dispatch_once(&pred, ^{                                                                                                                                                                        \
shared##classname = [[self alloc] init];                                                                                                                                                   \
});                                                                                                                                                                                            \
return shared##classname;                                                                                                                                                                      \
}
#endif

#define CRManager(classname) CRSingleton(classname, Manager)

#endif /* Utility_h */
