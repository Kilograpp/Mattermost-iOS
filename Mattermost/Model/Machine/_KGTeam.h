// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGTeam.h instead.

@import CoreData;
#import "KGManagedObject.h"

extern const struct KGTeamAttributes {
	__unsafe_unretained NSString *currentTeam;
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *identifier;
	__unsafe_unretained NSString *name;
} KGTeamAttributes;

@interface KGTeamID : NSManagedObjectID {}
@end

@interface _KGTeam : KGManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) KGTeamID* objectID;

@property (nonatomic, strong) NSNumber* currentTeam;

@property (atomic) BOOL currentTeamValue;
- (BOOL)currentTeamValue;
- (void)setCurrentTeamValue:(BOOL)value_;

//- (BOOL)validateCurrentTeam:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* identifier;

@property (atomic) int64_t identifierValue;
- (int64_t)identifierValue;
- (void)setIdentifierValue:(int64_t)value_;

//- (BOOL)validateIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@end

@interface _KGTeam (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveCurrentTeam;
- (void)setPrimitiveCurrentTeam:(NSNumber*)value;

- (BOOL)primitiveCurrentTeamValue;
- (void)setPrimitiveCurrentTeamValue:(BOOL)value_;

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSNumber*)primitiveIdentifier;
- (void)setPrimitiveIdentifier:(NSNumber*)value;

- (int64_t)primitiveIdentifierValue;
- (void)setPrimitiveIdentifierValue:(int64_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end
