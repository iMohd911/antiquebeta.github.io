#import "../headers.h"

@interface Install : UICollectionViewCell {
    MTMaterialView *blurView;
}
@property (nonatomic, strong) MPDownloadProgressView *progressView;
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) SBIconImageView *iconImageView;

@property (nonatomic, strong) UILabel *textLabel;

-(void) installApplicationWithProgress:(double)progress;
@end