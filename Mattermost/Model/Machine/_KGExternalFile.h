// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGExternalFile.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "KGFile.h"

NS_ASSUME_NONNULL_BEGIN

@interface KGExternalFileID : KGFileID {}
@end

@interface _KGExternalFile : KGFile
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGExternalFileID *objectID;

@property (nonatomic, strong, nullable) NSString* link;

@end

@interface _KGExternalFile (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveLink;
- (void)setPrimitiveLink:(NSString*)value;

@end

@interface KGExternalFileAttributes: NSObject 
+ (NSString *)link;
@end

NS_ASSUME_NONNULL_END
