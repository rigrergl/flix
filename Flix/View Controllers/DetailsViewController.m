//
//  DetailsViewController.m
//  Flix
//
//  Created by Rigre Reinier Garciandia Larquin on 6/23/21.
//

#import "DetailsViewController.h"
#import "TrailerViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (nonatomic)BOOL isFavorite;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIView *youtubeView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Detail View Loaded");
    
//    yourView.layer.shadowColor = UIColor.black.cgColor
//    yourView.layer.shadowOpacity = 1
//    yourView.layer.shadowOffset = .zero
//    yourView.layer.shadowRadius = 10
    
    self.posterView.layer.shadowRadius  = 1.5f;
    self.posterView.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    self.posterView.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.posterView.layer.shadowOpacity = 0.9f;
    self.posterView.layer.masksToBounds = NO;

    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(-12.0f, -3.0f, -12.0f, -3.0f);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.posterView.bounds, shadowInsets)];
    self.posterView.layer.shadowPath    = shadowPath.CGPath;
    
    //setting up poster
    NSURL *posterURL = self.movie.posterUrl;
    
    self.posterView.image = nil;
    [self.posterView setImageWithURL:posterURL ];
    
    //setting up backdrop
    NSURL *backdropURL = self.movie.backdropURL;
    
    self.backdropView.image = nil;
    [self.backdropView setImageWithURL:backdropURL ];
    
    self.titleLabel.text = self.movie.title;
    self.synopsisLabel.text = self.movie.overview;
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    
    //setting heart button
    [self updateFavorite];
    UIImage * unselectedImage = [UIImage systemImageNamed:@"heart"];
    UIImage * selectedImage = [UIImage systemImageNamed:@"heart.fill"];
    if (!self.isFavorite) {
        [self.favoriteButton setBackgroundImage:unselectedImage forState:UIControlStateNormal];
        [self.favoriteButton setSelected:NO];
        
    } else {
        [self.favoriteButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [self.favoriteButton setSelected:YES];
    }
    
    
}

- (void) updateFavorite {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray* favoriteIDs = [defaults arrayForKey:@"favoriteIDs"];
    
    NSNumber* movieID = self.movie.movieID;
    for (NSNumber * favID in favoriteIDs) {
        if([movieID integerValue] == [favID integerValue]) {
            self.isFavorite = true;
            return;
        }
    }
    self.isFavorite = false;
    return;
}

- (IBAction)onTapPoster:(id)sender {
    NSLog(@"Tap");
    [self performSegueWithIdentifier:@"webSegue" sender:nil];
}

- (IBAction)favoriteButtonClicked:(UIButton *)sender {
    //    let homeImage = UIImage(systemName: "house", withConfiguration: homeSymbolConfiguration)
    
    //    UIImage * homeImage = [UIImage systemImageNamed:@"house"];
    
    NSLog(@" Selected State: %d", sender.isSelected);
    
    UIImage * unselectedImage = [UIImage systemImageNamed:@"heart"];
    UIImage * selectedImage = [UIImage systemImageNamed:@"heart.fill"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    if ([sender isSelected]) {
        [sender setBackgroundImage:unselectedImage forState:UIControlStateNormal];
        [sender setSelected:NO];
        
        NSArray* favoriteIDs = [defaults arrayForKey:@"favoriteIDs"];
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSNumber* currentID, NSDictionary *bindings) {
            return currentID != self.movie.movieID;
        }];
        
        favoriteIDs = [favoriteIDs filteredArrayUsingPredicate:predicate];
        NSLog(@"New Favorite IDs: %@", favoriteIDs);
        [defaults setObject:favoriteIDs forKey:@"favoriteIDs"];
        [defaults synchronize];
        
        //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //            [defaults setObject:test forKey:@"favoriteIDs"];
    } else {
        [sender setBackgroundImage:selectedImage forState:UIControlStateSelected];
        [sender setSelected:YES];
        
        NSArray* favoriteIDs = [defaults arrayForKey:@"favoriteIDs"];
        NSMutableArray* mutableArray = [favoriteIDs mutableCopy];
        if(mutableArray == nil)
            mutableArray = [[NSMutableArray alloc] init];
        
        [mutableArray addObject:self.movie.movieID];
        
        NSLog(@"%@", self.movie.movieID);
        NSLog(@"New Favorite IDs: %@", mutableArray);
        
        
        [defaults setObject:mutableArray forKey:@"favoriteIDs"];
        [defaults synchronize];
        
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    TrailerViewController *trailerViewController = [segue destinationViewController];
    
    NSInteger movie_id = [self.movie.movieID integerValue];
    trailerViewController.movie_id = movie_id;
}


@end
