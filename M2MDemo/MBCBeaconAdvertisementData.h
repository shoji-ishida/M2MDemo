//
//  MBCBeaconAdvertisementData.h
//  MacBeacon
//
//  Created by 石田 勝嗣 on 2014/01/14.
//  Copyright (c) 2014年 石田 勝嗣. All rights reserved.
//

#ifndef MacBeacon_MBCBeaconAdvertisementData_h
#define MacBeacon_MBCBeaconAdvertisementData_h

#import <Foundation/Foundation.h>

@interface MBCBeaconAdvertisementData : NSObject

@property (strong,nonatomic) NSUUID *proximityUUID;
@property (assign,nonatomic) uint16_t major;
@property (assign,nonatomic) uint16_t minor;
@property (assign,nonatomic) int8_t measuredPower;

- (id)initWithProximityUUID:(NSUUID *)proximityUUID
                      major:(uint16_t)major
                      minor:(uint16_t)minor
              measuredPower:(int8_t)power;


- (NSDictionary *)beaconAdvertisement;

@end

#endif
