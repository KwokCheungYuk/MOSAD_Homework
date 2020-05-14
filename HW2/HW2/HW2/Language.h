//
//  Language.h
//  HW2
//
//  Created by GZX on 2019/9/3.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Language : NSObject {
    NSInteger progress_tour;
    NSInteger progress_unit;
}

- (void)learnOneUnit;
- (NSInteger)getTour;
- (NSInteger)getUnit;
- (bool)isFinish;
- (NSString *)getName;

@end

@interface English : Language {
    
}

@end

@interface Japanese : Language {
    
}

@end

@interface German : Language {
    
}

@end

@interface Spanish : Language {
    
}

@end

NS_ASSUME_NONNULL_END
