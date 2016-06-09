// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGTeam.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "KGManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class KGChannel;

@interface KGTeamID : NSManagedObjectID {}
@end

@interface _KGTeam : KGManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGTeamID *objectID;

@property (nonatomic, strong, nullable) NSString* displayName;

@property (nonatomic, strong, nullable) NSString* identifier;

@property (nonatomic, strong, nullable) NSString* name;

@property (nonatomic, strong, nullable) NSSet<KGChannel*> *channels;
- (nullable NSMutableSet<KGChannel*>*)channelsSet;

@end

@interface _KGTeam (ChannelsCoreDataGeneratedAccessors)
- (void)addChannels:(NSSet<KGChannel*>*)value_;
- (void)removeChannels:(NSSet<KGChannel*>*)value_;
- (void)addChannelsObject:(KGChannel*)value_;
- (void)removeChannelsObject:(KGChannel*)value_;

@end

@interface _KGTeam (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet<KGChannel*>*)primitiveChannels;
- (void)setPrimitiveChannels:(NSMutableSet<KGChannel*>*)value;

@end

@interface KGTeamAttributes: NSObject 
+ (NSString *)displayName;
+ (NSString *)identifier;
+ (NSString *)name;
@end

@interface KGTeamRelationships: NSObject
+ (NSString *)channels;
@end

NS_ASSUME_NONNULL_END
