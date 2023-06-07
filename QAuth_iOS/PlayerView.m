//
//  PlayerView.m
//  QAuth_iOS
//
//  Created by sunmu on 2023/5/22.
//

#import "PlayerView.h"
#import <AVFoundation/AVPlayerLayer.h>

@implementation PlayerView

+(Class)layerClass{

    return [AVPlayerLayer class];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
