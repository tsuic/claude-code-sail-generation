# Conversion Guidelines Navigation Index

Quick navigation index for functional interface conversion. Use this to find the right module and anchor for your task.

---

## 📁 Modules by Interface Type

**Form Interfaces (CREATE/UPDATE):**
- `/conversion-guidelines/form-conversion-module.md` - ri! patterns, audit fields, wizard handling
  - Key sections: `{#form.ri-pattern}`, `{#form.audit-fields}`, `{#form.wizard-handling}`

**Display Interfaces (READ-ONLY):**
- `/conversion-guidelines/display-conversion-module.md` - dashboards, KPIs, charts, grids
  - Key sections: `{#display.chart-refactoring}`, `{#display.kpi-aggregation}`, `{#display.grid-patterns}`

**Common Patterns (All Interface Types):**
- `/conversion-guidelines/common-conversion-patterns.md` - query construction, relationship navigation
  - Key sections: `{#common.query-construction}`, `{#common.relationship-navigation}`, `{#common.data-model-validation}`

**Validation (Always Required):**
- `/conversion-guidelines/validation-enforcement-module.md` - null safety, type matching, pre-flight checks
  - Key sections: `{#validation.null-safety}`, `{#validation.type-matching}`, `{#validation.pre-flight-checklist}`

---

## 📋 By Task Type

**Form Conversion Tasks:**
- Building forms/wizards that create records → `form-conversion-module.md` `{#form.ri-pattern}`
- ri! comment format and documentation → `form-conversion-module.md` `{#form.ri-pattern.comment-format}`
- Managing audit fields (createdBy, modifiedOn) → `form-conversion-module.md` `{#form.audit-fields}`
- Wizard step handling → `form-conversion-module.md` `{#form.wizard-handling}`

**Display Conversion Tasks:**
- Chart pattern refactoring (mockup → record data) → `display-conversion-module.md` `{#display.chart-refactoring}`
- Chart grouping field selection → `display-conversion-module.md` `{#display.chart-refactoring.grouping-fields}`
- KPI/aggregation calculations → `display-conversion-module.md` `{#display.kpi-aggregation}`
- Grid sortField validation → `display-conversion-module.md` `{#display.grid-patterns.sortfield-rules}`
- Record link conversion → `display-conversion-module.md` `{#display.record-links}`
- Action button conversion → `display-conversion-module.md` `{#display.action-buttons}`

**Common Conversion Tasks:**
- Query construction (a!recordData, a!queryRecordType) → `common-conversion-patterns.md` `{#common.query-construction}`
- Relationship navigation syntax → `common-conversion-patterns.md` `{#common.relationship-navigation}`
- Dropdown "All" option conversion → `common-conversion-patterns.md` `{#common.dropdown-all-option}`
- Data model availability validation → `common-conversion-patterns.md` `{#common.data-model-validation}`
- Environment object validation → `common-conversion-patterns.md` `{#common.environment-objects}`
- Pattern matching (nested if → a!match) → `common-conversion-patterns.md` `{#common.pattern-matching}`

**Validation Tasks:**
- Unused variable detection → `validation-enforcement-module.md` `{#validation.unused-variables}`
- Null safety enforcement → `validation-enforcement-module.md` `{#validation.null-safety}`
- Query filter type matching → `validation-enforcement-module.md` `{#validation.type-matching}`
- Pre-flight validation checklist → `validation-enforcement-module.md` `{#validation.pre-flight-checklist}`

---

## 🔧 By Error Type

**Form-Related Errors:**
- "ri! variable not defined" → `form-conversion-module.md` `{#form.ri-pattern}`
- "Cannot save to ri!" → `form-conversion-module.md` `{#form.ri-pattern.variable-mapping}`
- Audit fields missing → `form-conversion-module.md` `{#form.audit-fields}`

**Display-Related Errors:**
- Chart shows no data → `display-conversion-module.md` `{#display.chart-refactoring}`
- Chart grouping shows IDs instead of names → `display-conversion-module.md` `{#display.chart-refactoring.grouping-fields}`
- Grid sort not working → `display-conversion-module.md` `{#display.grid-patterns.sortfield-rules}`
- KPI shows null → `display-conversion-module.md` `{#display.kpi-aggregation}`

**Query-Related Errors:**
- "Property not found" on query results → `common-conversion-patterns.md` `{#common.query-construction}`
- Query filter nesting errors → `common-conversion-patterns.md` `{#common.query-construction.filters-nesting}`
- Relationship navigation errors → `common-conversion-patterns.md` `{#common.relationship-navigation}`
- "List of Variant" from append() → `common-conversion-patterns.md` `{#common.dropdown-all-option}`

**Validation Errors:**
- Null reference errors → `validation-enforcement-module.md` `{#validation.null-safety}`
- Date/DateTime type mismatch → `validation-enforcement-module.md` `{#validation.type-matching}`
- Unused variable warnings → `validation-enforcement-module.md` `{#validation.unused-variables}`

---

## 📚 Foundational References

These files contain patterns used by BOTH mockup generation and functional conversion:

- `/logic-guidelines/short-circuit-evaluation.md` - Why if() vs and()/or() for null safety
- `/logic-guidelines/null-safety-quick-ref.md` - Quick pattern lookup table
- `/logic-guidelines/datetime-handling.md` - Date/time type matching & operators
- `/logic-guidelines/pattern-matching.md` - a!match() for status/category lookups
- `/record-query-guidelines/query-filters-operators.md` - Filter patterns, valid operators
- `/record-query-guidelines/query-result-structures.md` - Property access by query type
