// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGTeam.h instead.

@import CoreData;
#import "KGBaseEntity.h"

extern const struct KGTeamAttributes {
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *name;
} KGTeamAttributes;

@interface KGTeamID : KGBaseEntityID {}
@end

@interface _KGTeam : KGBaseEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGTeamID* objectID;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@end

@interface _KGTeam (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end
