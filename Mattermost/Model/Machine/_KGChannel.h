// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGChannel.h instead.

@import CoreData;
#import "KGManagedObject.h"

extern const struct KGChannelAttributes {
	__unsafe_unretained NSString *backendType;
	__unsafe_unretained NSString *createdAt;
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *header;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *lastPostDate;
	__unsafe_unretained NSString *messagesCount;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *purpose;
	__unsafe_unretained NSString *shouldUpdateAt;
	__unsafe_unretained NSString *teamId;
	__unsafe_unretained NSString *updatedAt;
} KGChannelAttributes;

extern const struct KGChannelRelationships {
	__unsafe_unretained NSString *posts;
	__unsafe_unretained NSString *team;
} KGChannelRelationships;

@class KGPost;
@class KGTeam;

@interface KGChannelID : NSManagedObjectID {}
@end

@interface _KGChannel : KGManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGChannelID* objectID;

@property (nonatomic, strong) NSString* backendType;

//- (BOOL)validateBackendType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* createdAt;

//- (BOOL)validateCreatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* header;

//- (BOOL)validateHeader:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* identifier;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* lastPostDate;

//- (BOOL)validateLastPostDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* messagesCount;

@property (atomic) int64_t messagesCountValue;
- (int64_t)messagesCountValue;
- (void)setMessagesCountValue:(int64_t)value_;

//- (BOOL)validateMessagesCount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* purpose;

//- (BOOL)validatePurpose:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* shouldUpdateAt;

//- (BOOL)validateShouldUpdateAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teamId;

//- (BOOL)validateTeamId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* updatedAt;

//- (BOOL)validateUpdatedAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *posts;

- (NSMutableSet*)postsSet;

@property (nonatomic, strong) KGTeam *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@end

@interface _KGChannel (PostsCoreDataGeneratedAccessors)
- (void)addPosts:(NSSet*)value_;
- (void)removePosts:(NSSet*)value_;
- (void)addPostsObject:(KGPost*)value_;
- (void)removePostsObject:(KGPost*)value_;

@end

@interface _KGChannel (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveBackendType;
- (void)setPrimitiveBackendType:(NSString*)value;

- (NSDate*)primitiveCreatedAt;
- (void)setPrimitiveCreatedAt:(NSDate*)value;

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveHeader;
- (void)setPrimitiveHeader:(NSString*)value;

- (NSString*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSString*)value;

- (NSDate*)primitiveLastPostDate;
- (void)setPrimitiveLastPostDate:(NSDate*)value;

- (NSNumber*)primitiveMessagesCount;
- (void)setPrimitiveMessagesCount:(NSNumber*)value;

- (int64_t)primitiveMessagesCountValue;
- (void)setPrimitiveMessagesCountValue:(int64_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePurpose;
- (void)setPrimitivePurpose:(NSString*)value;

- (NSDate*)primitiveShouldUpdateAt;
- (void)setPrimitiveShouldUpdateAt:(NSDate*)value;

- (NSString*)primitiveTeamId;
- (void)setPrimitiveTeamId:(NSString*)value;

- (NSDate*)primitiveUpdatedAt;
- (void)setPrimitiveUpdatedAt:(NSDate*)value;

- (NSMutableSet*)primitivePosts;
- (void)setPrimitivePosts:(NSMutableSet*)value;

- (KGTeam*)primitiveTeam;
- (void)setPrimitiveTeam:(KGTeam*)value;

@end
