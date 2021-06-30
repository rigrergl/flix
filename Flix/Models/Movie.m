//
//  Movie.m
//  Flix
//
//  Created by Rigre Reinier Garciandia Larquin on 6/30/21.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
  self = [super init];

  self.title = dictionary[@"title"];
    self.movieID = dictionary[@"id"];

  // Set the other properties from the dictionary
    self.overview = dictionary[@"overview"];
    
    NSString *posterURLString = dictionary[@"poster_path"];
    if (posterURLString != nil) {
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
        NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
        self.posterUrl = posterURL;
    }
    
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    if (posterURLString != nil) {
        NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
        self.backdropURL = backdropURL;
    }
    
  return self;
  }

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];// Call the Movie initializer here

        [movies addObject:movie];
    }
    
    return movies;
}

@end
