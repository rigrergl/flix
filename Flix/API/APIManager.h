//
//  APIManager.h
//  Flix
//
//  Created by Rigre Reinier Garciandia Larquin on 6/30/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIManager : NSObject

- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
