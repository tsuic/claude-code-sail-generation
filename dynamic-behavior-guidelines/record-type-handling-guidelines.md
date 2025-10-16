# RECORD TYPE HANDLING GUIDELINES

This document provides the specific record type definitions for use when creating SAIL expressions.

<quick_reference>
## Quick Reference

**Record Type Pattern**: `'recordType!{uuid}RecordTypeName'`
**Field Pattern**: `'recordType!{uuid}RecordTypeName.fields.{fieldUuid}fieldName'`
**Relationship Pattern**: `'recordType!{uuid}RecordTypeName.relationships.{relUuid}relationshipName'`
**Related Field Pattern**: `'recordType!{uuid}RecordTypeName.relationships.{relUuid}relationshipName.fields.{fieldUuid}fieldName'`

**Key Rules**:
- Always use the FULL reference string exactly as shown
- Relationships are for navigation, fields are for values
- Use single continuous path for related fields (no double brackets)
</quick_reference>

<critical_rules>
## 🚨 CRITICAL RULES

<rule_1>
**When creating interfaces, use the available record type, record fields, relationships available to you.**
</rule_1>

<rule_2>
**Also use your knowledge of queries and data indexing.**
</rule_2>

<rule_3>
**Avoid using local variables to maintain record data and access the rule inputs directly.**
</rule_3>

<rule_4>
**If the form captures data on a record type on the many side of a one-to-many relationship, then use the main record type's relationships and their fields to access that data rather than creating new rule inputs or local variables.**
</rule_4>

<rule_5>
**NEVER confuse record type relationships with fields when building SAIL expressions.**
Remember: 
- Relationships: Used for navigation to related records
- Fields: Used to display values, filtering, sorting
</rule_5>
</critical_rules>

<critical_errors>
## ❌ Critical Errors to Avoid

❌ **Double brackets**: `[relationship][field]` → ✅ **Single path**: `[relationship.fields.field]`
❌ **Sort on relationships** → ✅ **Sort on fields only**
❌ **User fields with dropdown** → ✅ **Use `a!pickerFieldUsers()`**
❌ **Group fields with dropdown** → ✅ **Use `a!pickerFieldGroups()`**
</critical_errors>

<relationship_types>
## Relationship Type Usage

**many-to-one**: Can sort on related fields, display directly
**one-to-many**: Cannot sort, use length() or a!forEach()
**one-to-one**: Like many-to-one
</relationship_types>
