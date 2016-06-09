// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGTeam.h instead.

@import CoreData;
#import "KGManagedObject.h"

extern const struct KGTeamAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *name;
} KGTeamAttributes;

extern const struct KGTeamRelationships {
	__unsafe_unretained NSString *channels;
} KGTeamRelationships;

@class KGChannel;

@interface KGTeamID : NSManagedObjectID {}
@end

@interface _KGTeam : KGManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGTeamID* objectID;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* identifier;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *channels;

- (NSMutableSet*)channelsSet;

@end

@interface _KGTeam (ChannelsCoreDataGeneratedAccessors)
- (void)addChannels:(NSSet*)value_;
- (void)removeChannels:(NSSet*)value_;
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

- (NSMutableSet*)primitiveChannels;
- (void)setPrimitiveChannels:(NSMutableSet*)value;

@end
