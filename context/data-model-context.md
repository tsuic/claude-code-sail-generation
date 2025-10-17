# DATA MODEL (RECORDS) CONTEXT

<available_record_types>
## Available Record Types - Updated description

<sssa_case>
### SSSA Case
**Record Type**: `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case'`

| **Field Name** | **Data Type** | **Field Reference** |
|----------------|---------------|---------------------|
| id | Number | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{cb725b0e-ee57-4044-a662-f3e41f39cf90}id'` |
| title | Text | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{c263e600-9181-440c-9058-4ab98f78a818}title'` |
| description | Text | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{5129cf3d-8111-4b45-9a42-14ec726071d3}description'` |
| statusId | Number | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{65e73d06-303c-4a7d-bdf1-398d92f386ca}statusId'` |
| priorityId | Number | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{3c793af8-ed9d-49a9-98c5-6f164d34abce}priorityId'` |
| createdBy | User | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{5c13ad45-f1be-4a79-ab2f-09e1554ac4f9}createdBy'` |
| createdOn | DateTime | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{527de25d-989f-440d-8bf3-dd7586abaf6a}createdOn'` |
| modifiedBy | User | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{516e9535-88b6-4546-a2fe-2aafc4e69680}modifiedBy'` |
| modifiedOn | DateTime | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{d1eec58a-5fce-4280-a3c0-99f1979c82c4}modifiedOn'` |

| **Relationship Name** | **Type** | **Relationship Reference** | **Access Related Value** |
|----------------------|----------|---------------------------|-------------------------|
| caseStatus | many-to-one | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{4e10ad28-87e8-460b-823e-266911c8306e}caseStatus'` | `.fields.{69483c43-a3ed-4c6a-b832-5d17be735c0e}value` |
| caseComment | one-to-many | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{ca4facef-ac54-4bf5-b6b4-8f6034feddb7}caseComment'` | `.fields.{867b3522-184b-499d-8d85-77cb151993b4}description` |
| priority | many-to-one | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority'` | `.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value` |

| **Action Type** | **Action Name** | **Action Reference** | **Context** |
|----------------|-----------------|---------------------|-------------|
| Record List | New Case | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.actions.{912987e4-9476-406f-b420-2b0bfbeaf984}newCase'` | - |
| Related | Update Case | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.actions.{efd7480b-5ce9-48b4-ad86-8bb7ce9ee5c3}updateCase'` | `record: rv!record, cancel: false(), isUpdate: true()` |

| **Filter Name** | **Filter Reference** |
|----------------|---------------------|
| Case Status Filter | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.filters.{36062df8-06bd-4733-a8f6-c5f096ee01c1}SSSA Case Status'` |
| Priority Filter | `'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.filters.{4ba873fb-a6bf-4d3c-994f-9c1785d2f9db}SSSA Priority'` |
</sssa_case>

<sssa_case_status>
### SSSA Case Status
**Record Type**: `'recordType!{8afdb335-f1ff-4629-8186-3f9dcb0c5b3d}SSSA Case Status'`

| **Field Name** | **Data Type** | **Field Reference** |
|----------------|---------------|---------------------|
| id | Number | `'recordType!{8afdb335-f1ff-4629-8186-3f9dcb0c5b3d}SSSA Case Status.fields.{50bfa447-b624-4e47-abfb-14069d62193a}id'` |
| value | Text | `'recordType!{8afdb335-f1ff-4629-8186-3f9dcb0c5b3d}SSSA Case Status.fields.{69483c43-a3ed-4c6a-b832-5d17be735c0e}value'` |
| isActive | Boolean | `'recordType!{8afdb335-f1ff-4629-8186-3f9dcb0c5b3d}SSSA Case Status.fields.{b15a60f1-5f80-4b79-a48e-ffa90e678864}isActive'` |
| sortOrder | Number | `'recordType!{8afdb335-f1ff-4629-8186-3f9dcb0c5b3d}SSSA Case Status.fields.{88e4580e-3b03-4cec-9b1f-f03887520569}sortOrder'` |
</sssa_case_status>

<sssa_case_comment>
### SSSA Case Comment
**Record Type**: `'recordType!{d97e08ac-8fb9-445b-8bf7-6e283f9ba464}SSSA Case Comment'`

| **Field Name** | **Data Type** | **Field Reference** |
|----------------|---------------|---------------------|
| id | Number | `'recordType!{d97e08ac-8fb9-445b-8bf7-6e283f9ba464}SSSA Case Comment.fields.{271ab412-621a-476e-a841-b9d42a889f85}id'` |
| description | Text | `'recordType!{d97e08ac-8fb9-445b-8bf7-6e283f9ba464}SSSA Case Comment.fields.{867b3522-184b-499d-8d85-77cb151993b4}description'` |
| caseId | Number | `'recordType!{d97e08ac-8fb9-445b-8bf7-6e283f9ba464}SSSA Case Comment.fields.{4d1ede1b-fa82-4201-9780-1577359729b6}caseId'` |
| createdOn | DateTime | `'recordType!{d97e08ac-8fb9-445b-8bf7-6e283f9ba464}SSSA Case Comment.fields.{92653969-fccb-46a1-9fe0-081867bb0807}createdOn'` |
| createdBy | User | `'recordType!{d97e08ac-8fb9-445b-8bf7-6e283f9ba464}SSSA Case Comment.fields.{364cce14-ddf9-4b42-9267-0d2f2604f504}createdBy'` |
| modifiedOn | DateTime | `'recordType!{d97e08ac-8fb9-445b-8bf7-6e283f9ba464}SSSA Case Comment.fields.{ae4dd598-8152-4fc1-9ca6-4ed50b685110}modifiedOn'` |
| modifiedBy | User | `'recordType!{d97e08ac-8fb9-445b-8bf7-6e283f9ba464}SSSA Case Comment.fields.{76bdffc7-ebc9-40d0-b2f4-aa3ba788a43c}modifiedBy'` |
</sssa_case_comment>

<sssa_priority>
### SSSA Priority
**Record Type**: `'recordType!{66674261-97e7-4bb2-8aa4-da5e47113ac0}SSSA Priority'`

| **Field Name** | **Data Type** | **Field Reference** |
|----------------|---------------|---------------------|
| id | Number | `'recordType!{66674261-97e7-4bb2-8aa4-da5e47113ac0}SSSA Priority.fields.{5df8f59d-2e33-4d3d-ae08-f0481f688435}id'` |
| value | Text | `'recordType!{66674261-97e7-4bb2-8aa4-da5e47113ac0}SSSA Priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'` |
| isActive | Boolean | `'recordType!{66674261-97e7-4bb2-8aa4-da5e47113ac0}SSSA Priority.fields.{7b3aba0a-9a05-47d3-8e9d-292891528b9b}isActive'` |
| sortOrder | Number | `'recordType!{66674261-97e7-4bb2-8aa4-da5e47113ac0}SSSA Priority.fields.{edcb7566-29c2-4828-b3af-f08fa26f1f71}sortOrder'` |
</sssa_priority>
</available_record_types>

<data_model_relationships>
## Data Model Relationships

<sssa_case_relationships>
### SSSA Case Relationships
- **Case → Case Status**: Many cases can have the same status (many-to-one)
- **Case → Comments**: One case can have multiple comments (one-to-many)
- **Case → Priority**: Many cases can have the same priority (many-to-one)
</sssa_case_relationships>
</data_model_relationships>


