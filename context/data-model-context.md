# DATA MODEL (RECORDS) CONTEXT
<available_record_types>
## Available Record Types

<scma_case>
### SCMA Case
**Record Type**: `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case'`

**Description**: 

Stores data about Cases.

**Fields**:

| **Field Name** | **Data Type** | **Field Reference** |
|----------------|---------------|---------------------|
| caseId | Integer | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{1ac31340-9cec-4133-b3da-517f966244df}caseId'` |
| lastUpdater | User | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{670220da-906f-4aaa-a7c4-084b71a50065}lastUpdater'` |
| caseStatusId | Integer | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{ce8bc2d9-9dc7-4a7b-9e31-fa35a7f9161c}caseStatusId'` |
| description | Text | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{1b9ef9c8-c43c-4dab-b8e7-4ab02db40a1e}description'` |
| title | Text | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{5e31aac4-e1d1-409e-b954-db3f36e04340}title'` |
| notes | Text | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{545bb0ee-f98c-4fd8-a9a8-3dd53de31ac6}notes'` |
| assignedTo | User | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{41905c99-3332-4704-bf2e-c0ea6b8b2207}assignedTo'` |
| team | Integer | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{85b10ee9-68e9-4edf-a0e7-56fe58392645}team'` |
| requiresApproval | Boolean | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{d7b18463-f9ab-440f-8aa5-b1766fe7a313}requiresApproval'` |
| isApproved | Boolean | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{34a7117b-fb88-4914-973b-5630ecb25c62}isApproved'` |
| approvedBy | Text | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{c34ac3a0-124a-411c-a3c7-33ea10f8b921}approvedBy'` |
| createdBy | User | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{782fab03-6e79-464d-862d-9766558ead34}createdBy'` |
| createdOn | Datetime | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{9ce32e5a-3ac6-48ec-ad18-fab3e84e1aa4}createdOn'` |
| modifiedBy | User | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{24dc24a9-c3a8-4c5b-b0f2-227247049eb6}modifiedBy'` |
| modifiedOn | Datetime | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{7292c035-42d5-47b9-988f-d765d0439221}modifiedOn'` |
| isActive | Boolean | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.fields.{7a01c00d-4d7e-4c88-9fa4-3ee713c514fe}isActive'` |

**Relationships**:

| **Relationship Name** | **Type** | **Relationship Reference** |
|----------------------|----------|---------------------------|
| refCaseStatus | many-to-one | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.relationships.{edf0ab1b-294a-4caf-8171-3ce31d62edbc}refCaseStatus'` |
| lastUpdaterUser | many-to-one | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.relationships.{68d0ef48-5549-4ec2-bbe5-284a60445ab5}lastUpdaterUser'` |
| modifiedByUser | many-to-one | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.relationships.{8a2834b3-f9b4-4e66-a576-b5d6f6b642e4}modifiedByUser'` |
| caseNote | one-to-many | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.relationships.{8bfce234-3000-4ce3-8d95-bb30317c568a}caseNote'` |
| createdByUser | many-to-one | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.relationships.{e102da15-a54b-4322-9400-f83f81312f22}createdByUser'` |
| assignedToUser | many-to-one | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.relationships.{b2f0c709-5e6c-4c6f-b984-5e16db1cdeba}assignedToUser'` |
| teamRelationship | many-to-one | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.relationships.{03eb63ec-0c99-437b-b158-d8e985793d8f}teamRelationship'` |

**Note**: Access any field from related records using: `[relationshipReference].fields.{fieldUuid}fieldName`

**User Filters**:

| **User Filter Name** | **User Filter Reference** |
|---------------------|---------------------------|
| SCMA Ref Case Status | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.filters.{9bff8806-dff4-41e1-b35a-68e7696c2c40}SCMA Ref Case Status'` |
| SCMA Team | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.filters.{83705a5d-6f99-46f2-b601-a41427ded47a}SCMA Team'` |

**Record Actions**:

| **Action Name** | **Action Reference** |
|----------------|---------------------|
| Update Case | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.actions.{c03a5a39-ee2c-4104-b42a-8c67c664007d}updateCase'` |
| Assign Case Worker | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.actions.{faf77d44-a298-47ea-aa4e-596a33b75757}assignCase'` |
| Review Case | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.actions.{b1b6bb6c-60e0-4822-b303-619cdeb7a0e6}approveCase'` |
| Close Case | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.actions.{01522407-9fdf-4fb4-ad26-34d1c39070a0}closeCase'` |
| New Case | `'recordType!{113edddd-a9f8-4e1d-a53e-8f9f50af7b8e}SCMA Case.actions.{9426e9f0-6174-4749-8f1d-c934de3be4ca}newCase'` |

</scma_case>

<scma_case_note>
### SCMA Case Note
**Record Type**: `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note'`

**Description**: 

Stores data about Case Notes.

**Fields**:

| **Field Name** | **Data Type** | **Field Reference** |
|----------------|---------------|---------------------|
| noteId | Integer | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.fields.{db50ac49-b383-4a44-a341-ce78465512cb}noteId'` |
| note | Text | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.fields.{e57d8a03-2bd4-48c2-ba00-8cf8e21defa3}note'` |
| addedBy | User | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.fields.{9ceb4250-6eb2-48d1-b2ec-48bc082fbab5}addedBy'` |
| addedOn | Datetime | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.fields.{a73325b1-3658-4147-9213-45ac64f9638a}addedOn'` |
| caseId | Integer | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.fields.{c606933d-5cc8-43a0-9591-690327e97ad1}caseId'` |
| createdBy | User | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.fields.{c713fdaf-4790-4bc5-b6d6-483de467ec4d}createdBy'` |
| createdOn | Datetime | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.fields.{e280426c-2e11-4ac4-b7e4-2a60280ddf29}createdOn'` |
| modifiedBy | User | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.fields.{e65a25f6-bfca-4d6a-9d85-139bac931af7}modifiedBy'` |
| modifiedOn | Datetime | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.fields.{b202dace-8ab2-4c93-afde-7a0a83d54e02}modifiedOn'` |
| isActive | Boolean | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.fields.{fd212670-8279-4532-90bd-03c0046443fb}isActive'` |

**Relationships**:

| **Relationship Name** | **Type** | **Relationship Reference** |
|----------------------|----------|---------------------------|
| addedByUser | many-to-one | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.relationships.{636af781-d6df-4353-a6df-b6e01ca90c83}addedByUser'` |
| case | many-to-one | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.relationships.{81c90a79-8328-42de-a68e-00a63b17f68d}case'` |
| modifiedByUser | many-to-one | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.relationships.{5316b472-df0b-4f34-87fa-714042cb75fd}modifiedByUser'` |
| createdByUser | many-to-one | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.relationships.{bfebc61b-453e-4880-8dbf-6b4799bd7ee9}createdByUser'` |

**Note**: Access any field from related records using: `[relationshipReference].fields.{fieldUuid}fieldName`

**User Filters**:

| **User Filter Name** | **User Filter Reference** |
|---------------------|---------------------------|
| SCMA Case | `'recordType!{434fe237-0de0-4d55-b4e4-057ac22c1091}SCMA Case Note.filters.{054b4cb4-4f7c-4073-b456-e91c3395459c}SCMA Case'` |

**Record Actions**:

Not available

</scma_case_note>

<scma_team>
### SCMA Team
**Record Type**: `'recordType!{681743ae-e74e-4dab-accc-17b216774e12}SCMA Team'`

**Description**: 

Stores data about Teams.

**Fields**:

| **Field Name** | **Data Type** | **Field Reference** |
|----------------|---------------|---------------------|
| teamid | Integer | `'recordType!{681743ae-e74e-4dab-accc-17b216774e12}SCMA Team.fields.{d8c7be25-2fd1-45d5-ba71-aa37b60faeb3}teamid'` |
| teamname | Text | `'recordType!{681743ae-e74e-4dab-accc-17b216774e12}SCMA Team.fields.{a8fa437a-fa23-4c3c-b4c8-57e0aefa2194}teamname'` |

**Relationships**:

| **Relationship Name** | **Type** | **Relationship Reference** |
|----------------------|----------|---------------------------|
| case | one-to-many | `'recordType!{681743ae-e74e-4dab-accc-17b216774e12}SCMA Team.relationships.{e7c4b189-d609-4190-aa83-a9fc02014df1}case'` |

**Note**: Access any field from related records using: `[relationshipReference].fields.{fieldUuid}fieldName`

**User Filters**:

Not available

**Record Actions**:

Not available

</scma_team>

<scma_ref_case_status>
### SCMA Ref Case Status
**Record Type**: `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status'`

**Description**: 

Stores data about Ref Case Statuses.

**Fields**:

| **Field Name** | **Data Type** | **Field Reference** |
|----------------|---------------|---------------------|
| id | Integer | `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status.fields.{6cf65631-c11b-4e2d-9bf3-7b86dd8c2aa6}id'` |
| value | Text | `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status.fields.{524e2e0c-44e0-447f-93b5-62b9577c6920}value'` |
| sortOrder | Integer | `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status.fields.{acde786a-481b-473d-b7b7-cf36ba5fea92}sortOrder'` |
| createdBy | User | `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status.fields.{020ffbb3-59b4-4a2c-8b76-6f1ea38ebd80}createdBy'` |
| createdOn | Datetime | `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status.fields.{7f852112-b80c-444e-a0c6-1ab529fa2ae0}createdOn'` |
| modifiedBy | User | `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status.fields.{de974181-a75e-44b9-b39e-b0d5e4ab2625}modifiedBy'` |
| modifiedOn | Datetime | `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status.fields.{717ed3f7-7567-4423-bc1c-0c5da7ff0b2d}modifiedOn'` |
| isActive | Boolean | `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status.fields.{5361ed45-f404-41b6-a538-3b4ca44cc9d4}isActive'` |

**Relationships**:

| **Relationship Name** | **Type** | **Relationship Reference** |
|----------------------|----------|---------------------------|
| createdByUser | many-to-one | `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status.relationships.{900776fc-9408-45ae-8e15-f7d1c23078a4}createdByUser'` |
| case | one-to-many | `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status.relationships.{d2fb8647-635c-476a-8983-6da8f10d5f82}case'` |
| modifiedByUser | many-to-one | `'recordType!{9465545f-219d-4b63-a18a-d7886d66bc20}SCMA Ref Case Status.relationships.{ae7b4c8b-1cf2-408e-bd35-9c1c7a8455b1}modifiedByUser'` |

**Note**: Access any field from related records using: `[relationshipReference].fields.{fieldUuid}fieldName`

**User Filters**:

Not available

**Record Actions**:

Not available

</scma_ref_case_status>

<user>
### User
**Record Type**: `'recordType!{SYSTEM_RECORD_TYPE_USER}User'`

**Description**: 

Directory of users

**Fields**:

| **Field Name** | **Data Type** | **Field Reference** |
|----------------|---------------|---------------------|
| uuid | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_uuid}uuid'` |
| active | Boolean | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_active}active'` |
| username | User | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_username}username'` |
| firstName | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_firstName}firstName'` |
| middleName | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_middleName}middleName'` |
| lastName | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_lastName}lastName'` |
| displayName | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_displayName}displayName'` |
| email | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_email}email'` |
| address1 | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_address1}address1'` |
| address2 | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_address2}address2'` |
| address3 | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_address3}address3'` |
| city | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_city}city'` |
| state | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_state}state'` |
| zipCode | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_zipCode}zipCode'` |
| province | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_province}province'` |
| country | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_country}country'` |
| phoneHome | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_phoneHome}phoneHome'` |
| phoneMobile | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_phoneMobile}phoneMobile'` |
| phoneOffice | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_phoneOffice}phoneOffice'` |
| supervisor | User | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_supervisor}supervisor'` |
| blurb | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_blurb}blurb'` |
| title | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_title}title'` |
| isServiceAccount | Boolean | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_isServiceAccount}isServiceAccount'` |
| firstAndLastName | Text | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.fields.{SYSTEM_RECORD_TYPE_USER_FIELD_firstAndLastName}firstAndLastName'` |

**Relationships**:

| **Relationship Name** | **Type** | **Relationship Reference** |
|----------------------|----------|---------------------------|
| supervisorUser | many-to-one | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.relationships.{SYSTEM_RECORD_TYPE_USER_RELATIONSHIP_supervisorUser}supervisorUser'` |
| directReportUsers | one-to-many | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.relationships.{SYSTEM_RECORD_TYPE_USER_RELATIONSHIP_directReportUsers}directReportUsers'` |

**Note**: Access any field from related records using: `[relationshipReference].fields.{fieldUuid}fieldName`

**User Filters**:

| **User Filter Name** | **User Filter Reference** |
|---------------------|---------------------------|
| Status | `'recordType!{SYSTEM_RECORD_TYPE_USER}User.filters.{15c92b3a-2add-4281-af19-96dcae793b14}Status'` |

**Record Actions**:

Not available

</user>

</available_record_types>