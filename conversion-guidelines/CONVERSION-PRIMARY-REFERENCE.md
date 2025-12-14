# Functional Interface Conversion Guidelines

This guide covers converting static SAIL mockups into dynamic, data-driven interfaces that query live Appian records.

## 📑 Quick Navigation Index {#nav-index}

**How to use this index:**
1. Determine your interface type (Form vs Display vs Mixed)
2. Read the appropriate module(s)
3. Always read common patterns and validation modules

---

### 📁 Conversion Modules (By Interface Type):

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

### 🎯 Interface Type Detection {#interface-type-detection}

**BEFORE converting any interface**, analyze whether it's:

#### Form Interface Indicators (Use ri! Pattern)
Keywords in mockup header or components:
- "submit", "create", "add new", "register"
- "update", "edit", "modify", "save"
- "wizard", "multi-step", "application"
- "review", "approve", "reject", "decision"
- Presence of `a!formLayout()` or `a!wizardLayout()` with submission buttons

#### Display Interface Indicators (Use Query Pattern)
Keywords in mockup header or components:
- "dashboard", "report", "analytics"
- "list view", "summary", "overview"
- "metrics", "KPIs", "statistics"
- Presence of charts, KPI cards, read-only grids
- No submission buttons (only navigation/filter controls)

#### Mixed Interface (Load Both Modules)
- Dashboard with embedded form sections
- List view with inline edit capabilities
- Report with action buttons that launch forms

---

### 📋 Module Loading Decision Tree {#module-loading}

```
Is this a CREATE/UPDATE interface?
├─ YES (form with submission)
│   └─ Load: form-conversion-module.md + common + validation
│
├─ NO (read-only display)
│   └─ Load: display-conversion-module.md + common + validation
│
└─ BOTH (mixed interface)
    └─ Load: ALL modules (form + display + common + validation)
```

---

### By Task Type:

**Form Conversion Tasks:**
- Building forms/wizards that create records → `/conversion-guidelines/form-conversion-module.md` `{#form.ri-pattern}`
- ri! comment format and documentation → `/conversion-guidelines/form-conversion-module.md` `{#form.ri-pattern.comment-format}`
- Managing audit fields (createdBy, modifiedOn) → `/conversion-guidelines/form-conversion-module.md` `{#form.audit-fields}`
- Wizard step handling → `/conversion-guidelines/form-conversion-module.md` `{#form.wizard-handling}`

**Display Conversion Tasks:**
- Chart pattern refactoring (mockup → record data) → `/conversion-guidelines/display-conversion-module.md` `{#display.chart-refactoring}`
- Chart grouping field selection → `/conversion-guidelines/display-conversion-module.md` `{#display.chart-refactoring.grouping-fields}`
- KPI/aggregation calculations → `/conversion-guidelines/display-conversion-module.md` `{#display.kpi-aggregation}`
- Grid sortField validation → `/conversion-guidelines/display-conversion-module.md` `{#display.grid-patterns.sortfield-rules}`
- Record link conversion → `/conversion-guidelines/display-conversion-module.md` `{#display.record-links}`
- Action button conversion → `/conversion-guidelines/display-conversion-module.md` `{#display.action-buttons}`

**Common Conversion Tasks:**
- Query construction (a!recordData, a!queryRecordType) → `/conversion-guidelines/common-conversion-patterns.md` `{#common.query-construction}`
- Relationship navigation syntax → `/conversion-guidelines/common-conversion-patterns.md` `{#common.relationship-navigation}`
- Dropdown "All" option conversion → `/conversion-guidelines/common-conversion-patterns.md` `{#common.dropdown-all-option}`
- Data model availability validation → `/conversion-guidelines/common-conversion-patterns.md` `{#common.data-model-validation}`
- Environment object validation → `/conversion-guidelines/common-conversion-patterns.md` `{#common.environment-objects}`
- Pattern matching (nested if → a!match) → `/conversion-guidelines/common-conversion-patterns.md` `{#common.pattern-matching}`

**Validation Tasks:**
- Unused variable detection → `/conversion-guidelines/validation-enforcement-module.md` `{#validation.unused-variables}`
- Null safety enforcement → `/conversion-guidelines/validation-enforcement-module.md` `{#validation.null-safety}`
- Query filter type matching → `/conversion-guidelines/validation-enforcement-module.md` `{#validation.type-matching}`
- Pre-flight validation checklist → `/conversion-guidelines/validation-enforcement-module.md` `{#validation.pre-flight-checklist}`

---

### By Error Type:

**Form-Related Errors:**
- "ri! variable not defined" → Check form-conversion-module.md `{#form.ri-pattern}`
- "Cannot save to ri!" → Check form-conversion-module.md `{#form.ri-pattern.variable-mapping}`
- Audit fields missing → Check form-conversion-module.md `{#form.audit-fields}`

**Display-Related Errors:**
- Chart shows no data → Check display-conversion-module.md `{#display.chart-refactoring}`
- Chart grouping shows IDs instead of names → Check display-conversion-module.md `{#display.chart-refactoring.grouping-fields}`
- Grid sort not working → Check display-conversion-module.md `{#display.grid-patterns.sortfield-rules}`
- KPI shows null → Check display-conversion-module.md `{#display.kpi-aggregation}`

**Query-Related Errors:**
- "Property not found" on query results → Check common-conversion-patterns.md `{#common.query-construction}`
- Query filter nesting errors → Check common-conversion-patterns.md `{#common.query-construction.filters-nesting}`
- Relationship navigation errors → Check common-conversion-patterns.md `{#common.relationship-navigation}`
- "List of Variant" from append() → Check common-conversion-patterns.md `{#common.dropdown-all-option}`

**Validation Errors:**
- Null reference errors → Check validation-enforcement-module.md `{#validation.null-safety}`
- Date/DateTime type mismatch → Check validation-enforcement-module.md `{#validation.type-matching}`
- Unused variable warnings → Check validation-enforcement-module.md `{#validation.unused-variables}`

---

### Foundational References (Shared with Mockup Generation):

These files contain patterns used by BOTH mockup generation and functional conversion:

- `/logic-guidelines/short-circuit-evaluation.md` - Why if() vs and()/or() for null safety
- `/logic-guidelines/null-safety-quick-ref.md` - Quick pattern lookup table
- `/logic-guidelines/datetime-handling.md` - Date/time type matching & operators
- `/logic-guidelines/pattern-matching.md` - a!match() for status/category lookups
- `/record-query-guidelines/query-filters-operators.md` - Filter patterns, valid operators
- `/record-query-guidelines/query-result-structures.md` - Property access by query type

---

## Conversion Workflow Overview {#conversion-workflow}

### Phase 1: Analysis
1. Read mockup file from `/output/`
2. Detect interface type (Form vs Display vs Mixed)
3. Load appropriate module(s)
4. Extract user requirements from `/* REQUIREMENT: */` comments

### Phase 2: Validation Gates
1. Validate data model availability (record types, fields, relationships)
2. Validate environment objects (constants, groups, process models)
3. Plan refactoring (charts, pattern matching, data structures)

### Phase 3: Implementation
1. Replace mock data with live queries
2. Apply mandatory logic refactoring
3. Preserve visual design
4. Convert action buttons and record links

### Phase 4: Validation & Output
1. Run unused variable detection
2. Run null safety enforcement
3. Run type matching verification
4. Execute pre-flight checklist
5. Write output and invoke validation agents

---

## Cross-Reference: What Stays in Agent vs Modules

**In sail-dynamic-converter.md (Agent):**
- Core responsibilities overview
- a!relatedRecordData() usage guidelines
- Workflow orchestration (which modules to load when)
- Critical syntax reminders (consolidated checklist)
- Quality standards
- When to seek clarification

**In Modules (Detailed Patterns):**
- Step-by-step conversion procedures
- Code examples (before/after)
- Validation checklists with checkboxes
- Decision trees
- Error patterns and fixes
