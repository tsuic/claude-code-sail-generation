# User/Group Fields vs Relationships {#user-group-fields}

> **Parent guide:** `record-type-handling-guidelines.md`
>
> **Related:**
> - `record-query-guidelines/relationship-navigation.md` (relationship patterns)
> - `logic-guidelines/null-safety-quick-ref.md` (null checking)

---

## Core Rule

**When the data model shows BOTH a field AND a relationship for users, ALWAYS use the FIELD reference, NEVER the relationship.**

Many record types have both:
- **Field** (e.g., `assignedTo`, `createdBy`, `modifiedBy`): User type field
- **Relationship** (e.g., `assignedToUser`, `createdByUser`, `modifiedByUser`): many-to-one relationship to User record type

**ALWAYS query and display using the FIELD, NOT the relationship.**

---

## ✅ CORRECT Patterns

### Use the User Field in Queries

```sail
a!queryRecordType(
  recordType: recordType!Case,
  fields: {
    recordType!Case.fields.assignedTo,
    recordType!Case.fields.createdBy,
    recordType!Case.fields.modifiedBy
  }
)
```

### Use the User Field in Grid Columns

```sail
a!gridColumn(
  label: "Assigned To",
  value: if(
    a!isNotNullOrEmpty(fv!row[recordType!Case.fields.assignedTo]),
    trim(
      user(fv!row[recordType!Case.fields.assignedTo], "firstName") & " " &
      user(fv!row[recordType!Case.fields.assignedTo], "lastName")
    ),
    "–"
  ),
  sortField: recordType!Case.fields.assignedTo
)
```

### Use the User Field in Forms

```sail
a!pickerFieldUsers(
  label: "Assigned To",
  value: a!defaultValue(
    ri!case[recordType!Case.fields.assignedTo],
    null
  ),
  saveInto: ri!case[recordType!Case.fields.assignedTo]
)
```

---

## ❌ WRONG Patterns

```sail
/* ❌ WRONG - Don't use the User relationship in queries */
a!queryRecordType(
  recordType: recordType!Case,
  fields: {
    recordType!Case.relationships.assignedToUser,  /* WRONG */
    recordType!Case.relationships.createdByUser,   /* WRONG */
    recordType!Case.relationships.modifiedByUser   /* WRONG */
  }
)

/* ❌ WRONG - Don't use relationship in grid columns */
a!gridColumn(
  label: "Assigned To",
  value: fv!row[recordType!Case.relationships.assignedToUser]  /* CAUSES ERRORS */
)
```

---

## Rule of Thumb for Fields vs Relationships

| Data Type | When to Use | Example |
|-----------|-------------|---------|
| **User field** | Always use the FIELD | `assignedTo`, `createdBy`, `modifiedBy` |
| **Group field** | Always use the FIELD | `teamGroup`, `departmentGroup` |
| **Date/DateTime field** | Always use the FIELD | `createdOn`, `modifiedOn`, `dueDate` |
| **Text/Number/Boolean field** | Always use the FIELD | `title`, `caseId`, `isActive` |
| **Related record data** | Use the RELATIONSHIP to navigate | `refCaseStatus.fields.value`, `teamRelationship.fields.teamname` |

**Key Principle:**
- **Fields** store scalar values (User, Date, Text, Number, Boolean) → Access directly
- **Relationships** navigate to related records via foreign keys → Use for accessing fields on the related record

---

## Why Both Field and Relationship Exist

- The **field** (e.g., `assignedTo`) stores the actual User value and is what you use for queries, displays, and forms
- The **relationship** (e.g., `assignedToUser`) exists primarily for advanced relationship modeling and is rarely used in interfaces
- The relationship may provide access to additional User record properties, but for standard use cases (displaying names, filtering by user, etc.), always use the field

---

## ⚠️ CRITICAL: Type Incompatibility - Relationships vs Fields

**Relationships are navigation paths, NOT scalar values:**

- **Fields** return scalar types: `User`, `Text`, `Number`, `Date`, `Boolean`
- **Relationships** return:
  - **One-to-many**: Array of records (e.g., `Comment Record[]`)
  - **Many-to-one or one-to-one**: Single record instance (e.g., `Customer Record`)

**This causes TYPE MISMATCH errors when passing to most functions:**

```sail
/* ❌ WRONG - Type mismatch: user() expects User (scalar), not User Record (relationship) */
user(
  fv!row['recordType!Case.relationships.assignedToUser'],  /* Returns User Record */
  "firstName"
)

/* ✅ CORRECT - Field returns User (scalar) */
user(
  fv!row['recordType!Case.fields.assignedTo'],  /* Returns User */
  "firstName"
)
```

---

## Valid Uses of Relationships

### 1. a!relatedRecordData() - Filter, Sort, and Limit One-to-Many Related Records

**For comprehensive documentation, see:** `/dynamic-behavior-guidelines/record-type-handling-guidelines.md` section "a!relatedRecordData() - Complete Usage Guide"

```sail
/* ✅ CORRECT - a!relatedRecordData() accepts one-to-many relationships */
a!relatedRecordData(
  relationship: 'recordType!Case.relationships.comments',
  sort: a!sortInfo(
    field: 'recordType!Comment.fields.createdOn',
    ascending: false
  ),
  limit: 10  /* Default is 10; max 100 for grids */
)
```

**Key constraints:**
- **One-to-many relationships ONLY** — Does not work with many-to-one
- **Default limit is 10** — Always specify if you need more
- **Cannot be used in aggregations** or records-powered charts

### 2. Null Checking Functions - Check for Existence of Related Records

```sail
/* ✅ CORRECT - Check if case has any comments (one-to-many) */
if(
  a!isNullOrEmpty(
    fv!row['recordType!Case.relationships.comments']  /* Returns Comment[] */
  ),
  "No comments",
  "Has comments"
)

/* ✅ CORRECT - Check if case has an assigned customer (many-to-one) */
if(
  a!isNotNullOrEmpty(
    fv!row['recordType!Case.relationships.customer']  /* Returns Customer Record */
  ),
  "Customer assigned",
  "No customer"
)
```

### 3. Array Manipulation Functions - Process One-to-Many Relationships

```sail
/* ✅ CORRECT - a!forEach over one-to-many relationship (returns array) */
a!forEach(
  items: ri!case['recordType!Case.relationships.comments'],  /* Returns Comment[] */
  expression: a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: {
          a!richTextItem(
            text: fv!item['recordType!Comment.fields.commentText']  /* Navigate to field */
          )
        }
      )
    }
  )
)

/* ✅ CORRECT - length() counts related records in one-to-many */
a!richTextDisplayField(
  value: {
    a!richTextItem(
      text: "Comments: " &
        if(
          a!isNullOrEmpty(ri!case['recordType!Case.relationships.comments']),
          "0",
          length(ri!case['recordType!Case.relationships.comments'])
        )
    )
  }
)
```

### 4. Navigation to Related Record Fields - Access Fields on the Related Record

```sail
/* ✅ CORRECT - Navigate through many-to-one relationship to get related field */
fv!row['recordType!Case.relationships.customer.fields.companyName']

/* ✅ CORRECT - Navigate through one-to-one relationship */
fv!row['recordType!Case.relationships.resolution.fields.resolvedDate']
```

---

## Common Type Mismatch Errors

```sail
/* ❌ WRONG - concat() expects Text fields, not relationship */
concat(
  fv!row['recordType!Case.relationships.customer'],  /* Returns Customer Record */
  " - ",
  fv!row['recordType!Case.fields.caseNumber']
)

/* ✅ CORRECT - Navigate to field on related record */
concat(
  fv!row['recordType!Case.relationships.customer.fields.companyName'],  /* Returns Text */
  " - ",
  fv!row['recordType!Case.fields.caseNumber']
)

/* ❌ WRONG - user() on many-to-one relationship instead of field */
user(
  fv!row['recordType!Case.relationships.assignedToUser'],  /* Returns User Record */
  "firstName"
)

/* ✅ CORRECT - Use the User field directly */
user(
  fv!row['recordType!Case.fields.assignedTo'],  /* Returns User */
  "firstName"
)
```

---

## Validation Rule

| Function Category | Accepts Relationships? | Parameter Type Expected | Use Instead |
|------------------|------------------------|-------------------------|-------------|
| **a!relatedRecordData()** | ✅ YES | Relationship | Only function designed for relationships |
| **a!isNullOrEmpty(), a!isNotNullOrEmpty()** | ✅ YES | Any type | Check existence of related records |
| **Array functions** (a!forEach, length, wherecontains, index, etc.) | ✅ YES (one-to-many only) | Array | Iterate/manipulate relationship arrays |
| **Navigation to fields** | ✅ YES | Relationship path | `relationships.relationshipName.fields.fieldName` |
| **user()** | ❌ NO | **User** or **Text** (field values) | Use `fields.fieldName` (User type), NOT relationships |
| **text(), concat()** | ❌ NO | Text/Number/Date (field values) | Use `fields.fieldName` or navigate to related field |
| **Arithmetic (+, -, *, /)** | ❌ NO | Number (field values) | Use `fields.fieldName` or navigate to related field |
| **All other functions** | ❌ NO | Check schema for expected type | Use `fields.fieldName` or navigate to related field |

---

## Quick Decision Tree

1. **Is it a!relatedRecordData()?** → ✅ Relationship OK
2. **Is it a null check (a!isNullOrEmpty/a!isNotNullOrEmpty)?** → ✅ Relationship OK
3. **Is it an array function (a!forEach, length, wherecontains) AND a one-to-many relationship?** → ✅ Relationship OK
4. **Are you navigating further with `.fields.fieldName`?** → ✅ Relationship OK (as path)
5. **Passing relationship directly to any other function?** → ❌ WRONG - use the field instead

**Remember:**
- Many-to-one/one-to-one relationships return **single record instances** → Cannot use with array functions
- One-to-many relationships return **arrays of records** → Can use with array functions (a!forEach, length, etc.)
- When in doubt: **navigate to the field** on the related record instead of passing the relationship directly

---

## ⚠️ CRITICAL: Displaying User Names

**The user() function extracts display properties from User data:**

```sail
/* ❌ WRONG - Passing relationship (returns record instance, not User scalar) */
user(fv!row['recordType!Case.relationships.assignedToUser'], "firstName")

/* ✅ CORRECT - Use the User FIELD */
user(fv!row['recordType!Case.fields.assignedTo'], "firstName")

/* ✅ ALSO CORRECT - user() also accepts Text username */
user("john.smith", "firstName")
```

**Valid user() properties:**
- `"firstName"` - User's first name
- `"lastName"` - User's last name
- `"email"` - User's email address
- `"username"` - User's username

**Complete pattern for displaying user names:**
```sail
/* Display full name from User field */
if(
  a!isNotNullOrEmpty(fv!row['recordType!Case.fields.assignedTo']),
  trim(
    user(fv!row['recordType!Case.fields.assignedTo'], "firstName") & " " &
    user(fv!row['recordType!Case.fields.assignedTo'], "lastName")
  ),
  "Unassigned"
)
```

**What user() accepts:**
- ✅ User field value: `user(userField, "firstName")`
- ✅ Text username: `user("john.smith", "firstName")`
- ❌ Relationship: `user(relationship, "firstName")` - **WRONG**
