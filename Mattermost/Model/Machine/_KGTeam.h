// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGTeam.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "KGBaseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface KGTeamID : KGBaseEntityID {}
@end

@interface _KGTeam : KGBaseEntity
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGTeamID *objectID;

@property (nonatomic, strong, nullable) NSString* displayName;

@property (nonatomic, strong, nullable) NSString* name;

@end

@interface _KGTeam (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end

@interface KGTeamAttributes: NSObject 
+ (NSString *)displayName;
+ (NSString *)name;
@end

NS_ASSUME_NONNULL_END
