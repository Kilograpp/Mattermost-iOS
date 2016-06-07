// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to KGTeam.m instead.

#import "_KGTeam.h"

const struct KGTeamAttributes KGTeamAttributes = {
	.currentTeam = @"currentTeam",
	.displayName = @"displayName",
	.identifier = @"identifier",
	.name = @"name",
};

@implementation KGTeamID
@end

@implementation _KGTeam

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Team";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Team" inManagedObjectContext:moc_];
}

- (KGTeamID*)objectID {
	return (KGTeamID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"currentTeamValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"currentTeam"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"identifierValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"identifier"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic currentTeam;

- (BOOL)currentTeamValue {
	NSNumber *result = [self currentTeam];
	return [result boolValue];
}

- (void)setCurrentTeamValue:(BOOL)value_ {
	[self setCurrentTeam:@(value_)];
}

- (BOOL)primitiveCurrentTeamValue {
	NSNumber *result = [self primitiveCurrentTeam];
	return [result boolValue];
}

- (void)setPrimitiveCurrentTeamValue:(BOOL)value_ {
	[self setPrimitiveCurrentTeam:@(value_)];
}

@dynamic displayName;

@dynamic identifier;

- (int64_t)identifierValue {
	NSNumber *result = [self identifier];
	return [result longLongValue];
}

- (void)setIdentifierValue:(int64_t)value_ {
	[self setIdentifier:@(value_)];
}

- (int64_t)primitiveIdentifierValue {
	NSNumber *result = [self primitiveIdentifier];
	return [result longLongValue];
}

- (void)setPrimitiveIdentifierValue:(int64_t)value_ {
	[self setPrimitiveIdentifier:@(value_)];
}

@dynamic name;

@end
