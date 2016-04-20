//
//  LBUrl.h
//  LazioBus
//
//  Created by Andrea Cerra on 30/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#ifndef LazioBus_LBUrl_h
#define LazioBus_LBUrl_h

#import "GADBannerView.h"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define ADSTESTID @""
#define ADSTESTMODE TRUE

#define LINKORARI           @""
#define LINKALTERNATIVE     @""
#define LINKTROVAINDIRIZZO  @""
#define LINKCALCOLATARIFFA  @""
#define LINKLUCEVERDE       @""
#define LINKNEWS            @""
#define LINKLISTAFERMATE    @""
#define LINKTROVAPERCORSO   @""
#define LINKSCELTAFERMATE   @""

#define DEFAULTLINKORARI    @""
#define APPVERSION          @""
#define OS                  @"iOS"

#endif
