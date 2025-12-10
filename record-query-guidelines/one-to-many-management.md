# One-to-Many Relationship Data Management {#one-to-many-management}

> **Parent guide:** `record-type-handling-guidelines.md`
>
> **Related:**
> - `record-query-guidelines/form-interface-patterns.md` (form patterns)
> - `record-query-guidelines/user-group-fields.md` (user/group handling)

---

## Core Principle

**In create/update forms, the relationship field IS the data source. No queries, no copies.**

When creating or updating data in a form using the ri! pattern, manage one-to-many related records through the parent record's relationship field. NEVER query them separately or use local variables.

---

## ✅ CORRECT Pattern - Direct Relationship Access

### Displaying Related Records in Forms

```sail
/* Iterate directly over the relationship - Case has many Comments */
a!forEach(
  items: ri!case['recordType!Case.relationships.caseComment'],
  expression: a!cardLayout(
    contents: {
      a!paragraphField(
        label: "Comment " & fv!index,
        /* Access fields through fv!item */
        value: fv!item['recordType!Comment.fields.description'],
        saveInto: fv!item['recordType!Comment.fields.description'],
        height: "MEDIUM"
      ),
      a!dateField(
        label: "Date",
        value: fv!item['recordType!Comment.fields.commentDate'],
        saveInto: fv!item['recordType!Comment.fields.commentDate']
      )
    }
  )
)
```

### Adding New Related Records

```sail
a!buttonWidget(
  label: "Add Comment",
  saveInto: {
    a!save(
      ri!case['recordType!Case.relationships.caseComment'],
      append(
        ri!case['recordType!Case.relationships.caseComment'],
        'recordType!Comment'(
          'recordType!Comment.fields.commentDate': today(),
          'recordType!Comment.fields.createdBy': loggedInUser()
        )
      )
    )
  }
)
```

### Removing Related Records

```sail
a!buttonWidget(
  label: "Remove Comment",
  icon: "trash",
  saveInto: {
    a!save(
      ri!case['recordType!Case.relationships.caseComment'],
      remove(
        ri!case['recordType!Case.relationships.caseComment'],
        fv!index  /* Remove item at current index in forEach */
      )
    )
  },
  showWhen: length(ri!case['recordType!Case.relationships.caseComment']) > 1
)
```

### Counting Related Records

```sail
a!richTextItem(
  text: "Total Comments: " & length(
    ri!case['recordType!Case.relationships.caseComment']
  )
)
```

### Checking if Relationship is Empty

```sail
if(
  a!isNullOrEmpty(ri!case['recordType!Case.relationships.caseComment']),
  /* Show message when no comments */
  a!cardLayout(
    contents: {
      a!richTextDisplayField(
        value: a!richTextItem(
          text: "No comments added yet. Click 'Add Comment' to begin.",
          color: "SECONDARY"
        )
      )
    }
  ),
  /* Show comments when data exists */
  a!forEach(
    items: ri!case['recordType!Case.relationships.caseComment'],
    expression: ...
  )
)
```

---

## ❌ WRONG Pattern - Separate Queries or Local Variables

**DON'T DO THIS:**
```sail
/* ❌ WRONG - Querying related data separately */
local!caseComments: a!queryRecordType(
  recordType: 'recordType!Comment',
  filters: a!queryFilter(
    field: 'recordType!Comment.fields.caseId',
    operator: "=",
    value: ri!case['recordType!Case.fields.caseId']
  )
).data,

/* ❌ WRONG - Managing in local variable */
a!forEach(
  items: local!caseComments,  /* Don't use local variables! */
  expression: ...
)

/* ❌ WRONG - Copying relationship to local variable */
local!comments: ri!case['recordType!Case.relationships.caseComment']
/* This creates a COPY - changes won't save to the relationship */
```

---

## Why This Pattern Is Mandatory

1. **Automatic persistence**: Changes to relationship fields auto-save
2. **Correct foreign keys**: Appian manages the parent-child links
3. **Single source of truth**: No sync issues between copies
4. **Simpler code**: No manual save logic needed

---

## Pattern Summary Table

| Action | Use This Pattern |
|--------|------------------|
| **Display** | `a!forEach(items: ri!case['...relationships.caseComment'], ...)` |
| **Add** | `append(ri!case['...relationships.caseComment'], 'recordType!Comment'(...))` |
| **Remove** | `remove(ri!case['...relationships.caseComment'], fv!index)` |
| **Edit** | `fv!item['recordType!Comment.fields.description']` (in forEach) |
| **Count** | `length(ri!case['...relationships.caseComment'])` |
| **Check if empty** | `a!isNullOrEmpty(ri!case['...relationships.caseComment'])` |

---

## Related Record Field References

Don't use relationships to display values. Instead, use the first text field from the related record type.

```sail
/* ✅ CORRECT - Use specific field path with single continuous navigation */
ri!case['recordType!Case.relationships.caseComment.fields.description']

/* ❌ WRONG - Don't use bare relationship */
ri!case['recordType!Case.relationships.caseComment']

/* ❌ WRONG - Double bracket syntax */
ri!case['recordType!Case.relationships.caseComment']['recordType!Comment.fields.description']

/* ✅ CORRECT - For counting related records */
length(ri!case['recordType!Case.relationships.caseComment.fields.description'])

/* ✅ CORRECT - For displaying related data in grids */
fv!item['recordType!Comment.fields.description']
```

---

## Complete Working Example

```sail
a!localVariables(
  /* NO local variables for relationship data */

  a!formLayout(
    contents: {
      a!sectionLayout(
        label: "Case Comments (" & length(ri!case['recordType!Case.relationships.caseComment']) & ")",
        contents: {
          /* Empty state message */
          if(
            a!isNullOrEmpty(ri!case['recordType!Case.relationships.caseComment']),
            a!richTextDisplayField(
              value: a!richTextItem(
                text: "No comments yet.",
                color: "SECONDARY"
              )
            ),
            /* Comments list */
            a!forEach(
              items: ri!case['recordType!Case.relationships.caseComment'],
              expression: a!cardLayout(
                contents: {
                  a!columnsLayout(
                    columns: {
                      a!columnLayout(
                        contents: {
                          a!paragraphField(
                            label: "Comment",
                            value: fv!item['recordType!Comment.fields.description'],
                            saveInto: fv!item['recordType!Comment.fields.description'],
                            height: "SHORT"
                          )
                        }
                      ),
                      a!columnLayout(
                        width: "NARROW",
                        contents: {
                          a!buttonArrayLayout(
                            buttons: {
                              a!buttonWidget(
                                label: "Remove",
                                icon: "trash",
                                style: "GHOST",
                                saveInto: a!save(
                                  ri!case['recordType!Case.relationships.caseComment'],
                                  remove(
                                    ri!case['recordType!Case.relationships.caseComment'],
                                    fv!index
                                  )
                                ),
                                showWhen: length(ri!case['recordType!Case.relationships.caseComment']) > 1
                              )
                            }
                          )
                        }
                      )
                    }
                  )
                },
                marginBelow: "STANDARD"
              )
            )
          ),
          /* Add button */
          a!buttonArrayLayout(
            buttons: {
              a!buttonWidget(
                label: "Add Comment",
                icon: "plus",
                style: "GHOST",
                saveInto: a!save(
                  ri!case['recordType!Case.relationships.caseComment'],
                  append(
                    ri!case['recordType!Case.relationships.caseComment'],
                    'recordType!Comment'(
                      'recordType!Comment.fields.commentDate': today(),
                      'recordType!Comment.fields.createdBy': loggedInUser()
                    )
                  )
                )
              )
            }
          )
        }
      )
    }
  )
)
```
