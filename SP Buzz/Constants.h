//
//  Constants.h
//  SP Buzz
//
//  Created by Wei Guang on 22/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define NewsFeedURL @"http://www.sp.edu.sg/wps/wcm/connect/lib-spws/Site-SPWebsite/?srv=cmpnt&source=library&cmpntname=MNU-MobileRSSFeed-SPBuzz-Shine"

#define EventsFeedURL @"http://www.sp.edu.sg/wps/wcm/connect/lib-spws/Site-SPWebsite/?srv=cmpnt&source=library&cmpntname=MNU-MobileRSSFeed-EventsSPFlash"

#define FacebookAppID @"111260298977389"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
