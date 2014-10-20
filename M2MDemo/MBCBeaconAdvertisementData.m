#import "MBCBeaconAdvertisementData.h"

@implementation MBCBeaconAdvertisementData

- (id)initWithProximityUUID:(NSUUID *)proximityUUID
                      major:(uint16_t)major
                      minor:(uint16_t)minor
              measuredPower:(int8_t)power {
    self = [super init];
    
    if (self) {
        _proximityUUID = proximityUUID;
        _major = major;
        _minor = minor;
        _measuredPower = power;
    }
    
    return self;
}


- (NSDictionary *)beaconAdvertisement {
    NSString *beaconKey = @"kCBAdvDataAppleBeaconKey";
    
    unsigned char advertisementBytes[21] = {0};
    
    [self.proximityUUID getUUIDBytes:(unsigned char *)&advertisementBytes];
    
    advertisementBytes[16] = (unsigned char)(self.major >> 8);
    advertisementBytes[17] = (unsigned char)(self.major & 255);
    
    advertisementBytes[18] = (unsigned char)(self.minor >> 8);
    advertisementBytes[19] = (unsigned char)(self.minor & 255);
    
    advertisementBytes[20] = self.measuredPower;
    
    NSMutableData *advertisement = [NSMutableData dataWithBytes:advertisementBytes length:21];
    
    return [NSDictionary dictionaryWithObject:advertisement forKey:beaconKey];
}

@end