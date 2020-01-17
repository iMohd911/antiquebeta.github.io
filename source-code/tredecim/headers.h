@interface UIColor (Private)
+(UIColor *) systemRedColor;
+(UIColor *) systemGreenColor;
+(UIColor *) systemBlueColor;
+(UIColor *) systemOrangeColor;
+(UIColor *) systemTealColor;
+(UIColor *) textFieldAtomBlueColor;
+(UIColor *) textFieldAtomPurpleColor;
+(UIColor *)__halfTransparentWhiteColor;
+(UIColor *)__halfTransparentBlackColor;
@end

@interface UICollectionView (Tredecim)
-(void) setRefreshControl:(UIRefreshControl *)refreshControl;
@end

@interface UIApplication (Tredecim)
-(void) openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options
  completionHandler:(void (^ __nullable)(BOOL success))completion;
@end





@interface MPDownloadProgressView : UIView
-(void) setCenterImage:(id)arg1;
-(void) setDownloadProgress:(double)arg1;
-(void) setOuterRingColor:(id)arg1;
@end





@interface MTMaterialView : UIView
+(id) materialViewWithRecipe:(long long)arg1 configuration:(long long)arg2;
@end





@interface SBIconListView : UIView
@end


@interface SBApplication : NSObject
@property(readonly, nonatomic, getter=isUninstallSupported) BOOL uninstallSupported;
@property(readonly, nonatomic, getter=isSystemApplication) BOOL systemApplication;
@property(readonly, nonatomic, getter=isInternalApplication) _Bool internalApplication;
@property(nonatomic, getter=isPlayingAudio) BOOL playingAudio;

-(BOOL)_isRecentlyUpdated;
-(BOOL)_isNewlyInstalled;
-(BOOL) iconSupportsUninstall:(id)arg1;
@end


@interface SBApplicationController : NSObject
+(id) sharedInstance;
-(id) applicationWithBundleIdentifier:(id)arg1;
-(id) runningApplications;
@end


@interface SBIcon : NSObject
@property(readonly, copy, nonatomic) NSString *displayName;
@property(readonly, nonatomic) double progressPercent;

-(id) applicationBundleID;
-(void) setBadge:(id)arg1;
-(id) badgeNumberOrString;
-(long long) badgeValue;
@end


@interface SBIconModel : NSObject
-(SBIcon *)expectedIconForDisplayIdentifier:(NSString *)identifier;
@end


@interface SBIconController : UIViewController
+(instancetype) sharedInstance;

@property(readonly, copy, nonatomic) NSArray *allApplications;
@property(retain, nonatomic) SBIconModel *model;
@end


@interface SBIconView : UIView
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) SBIcon *icon;
@property(nonatomic, getter=isInDock) BOOL inDock;
-(void)_setIcon:(SBIcon *)icon animated:(BOOL)animated;
-(void)_updateAccessoryViewWithAnimation:(BOOL)arg1;
@end


@interface SBIconImageView : UIImageView
-(void) setIcon:(id)arg1 location:(long long)arg2 animated:(BOOL)arg3;
@end







@interface _UIBackdropView : UIView
-(id) initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
-(id) initWithPrivateStyle:(int)arg1;
-(id) initWithSettings:(id)arg1;
-(id) initWithStyle:(int)arg1;

-(void) setBlurFilterWithRadius:(float)arg1 blurQuality:(id)arg2 blurHardEdges:(int)arg3;
-(void) setBlurFilterWithRadius:(float)arg1 blurQuality:(id)arg2;
-(void) setBlurHardEdges:(int)arg1;
-(void) setBlurQuality:(id)arg1;
-(void) setBlurRadius:(float)arg1;
-(void) setBlurRadiusSetOnce:(BOOL)arg1;
-(void) setBlursBackground:(BOOL)arg1;
-(void) setBlursWithHardEdges:(BOOL)arg1;
@end

@interface _UIBackdropViewSettings : NSObject
+(id) settingsForStyle:(int)arg1;
@end







@interface LSBundleProxy : NSObject
@property (nonatomic, readonly) NSString *localizedShortName;
@end


@interface _LSDiskUsage : NSObject
@property (nonatomic, readonly) NSNumber *dynamicUsage;
@end


@interface _LSLazyPropertyList : NSObject
@property (readonly) NSDictionary *propertyList;
@end


@interface LSApplicationProxy : NSObject
@property(setter=_setLocalizedName:, nonatomic, copy) NSString *localizedName;
@property(nonatomic, readonly) NSString *bundleIdentifier;
@property(nonatomic, readonly) NSString *primaryIconName;
@property(nonatomic, readonly) NSDictionary *iconsDictionary;
@property(nonatomic, readonly) NSArray *appTags;
@property(setter=_setInfoDictionary:, nonatomic, copy) _LSLazyPropertyList *_infoDictionary;

@property (nonatomic, readonly) _LSDiskUsage *diskUsage;
@property (nonatomic, readonly) NSString *genre;
@property (nonatomic, readonly) NSString *shortVersionString;

-(NSArray *)_boundIconFileNames;
-(NSArray *)boundIconFileNames;
@end


@interface LSApplicationWorkspace
+(instancetype) defaultWorkspace;
-(id) allInstalledApplications;
-(id) allApplications;
-(id) applicationsOfType:(unsigned long long)arg1;
-(id) applicationsWithUIBackgroundModes;
-(BOOL) openApplicationWithBundleID:(id)arg1;
@end