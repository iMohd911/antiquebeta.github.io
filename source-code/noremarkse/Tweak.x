@interface MIMEAddress : NSObject
-(NSString *) name;
@end

@interface Package : NSObject
-(NSString *) getRecord; // control file
-(MIMEAddress *) maintainer;
@end

@interface Database : NSObject
+(id) sharedInstance;
-(NSArray <Package *> *) packages;
@end


@interface NSString (SubstringSearch)
-(BOOL) containsString:(NSString *)substring;
@end

@implementation NSString (SubstringSearch)
-(BOOL) containsString:(NSString *)substring {
    NSRange range = [self rangeOfString:substring];
    BOOL found = (range.location != NSNotFound);
    return found;
}
@end


#define PLIST_PATH @"/var/mobile/Library/Preferences/com.antique.noremarkse.plist"
inline NSString *GetString(NSString *key) {
    return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] stringValue];
}


%hook Database
-(NSArray <Package *> *) packages {
    NSArray <Package *> *packageArray = %orig; // get the original array of packages
    NSMutableArray <Package *> *oldPackages = packageArray.mutableCopy; // use mutableCopy so we can remove items


    NSString *namesArray = GetString(@"kNames");
    NSArray *names = [namesArray componentsSeparatedByString:@","]; // get the names from the preference bundle and create an array if a comma is used

    for(int i = 0; i < [names count]; i++) { // names found in the preferences bundle
        for(int index = 0; index < [oldPackages count]; index++) { // scan through all packages in the Database
            Package *package = oldPackages[index]; // get a package at from the array at *index*
            NSString *maintainer = package.maintainer.name; // access the name of the package maintainer

            if([maintainer containsString:names[i]] || [package.getRecord containsString:names[i]]) { // check if our names match the maintainers name
                [oldPackages removeObjectAtIndex:index]; // remove it from existance
            }
        }
    } return oldPackages.copy; // copy returns a immutable version of our previous mutable array
}
%end
