// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGBaseEntity.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "KGManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface KGBaseEntityID : NSManagedObjectID {}
@end

@interface _KGBaseEntity : KGManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGBaseEntityID *objectID;

@property (nonatomic, strong) NSString* identifier;

@end

@interface _KGBaseEntity (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

@end

@interface KGBaseEntityAttributes: NSObject 
+ (NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
