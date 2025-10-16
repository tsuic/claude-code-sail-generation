a!localVariables(
  /* Selected case tracking */
  local!selectedCase: null,

  /* Main dashboard layout */
  a!headerContentLayout(
    header: {
      a!cardLayout(
        contents: {
          a!richTextDisplayField(
            labelPosition: "COLLAPSED",
            value: {
              a!richTextItem(
                text: "Cases Dashboard",
                size: "LARGE",
                style: "STRONG",
                color: "#FFFFFF"
              )
            }
          )
        },
        height: "AUTO",
        style: "#1C2C44",
        padding: "MORE",
        marginBelow: "NONE",
        showBorder: false
      )
    },
    contents: {
      a!cardLayout(
        contents: {
          a!gridField(
            label: "Active Cases",
            labelPosition: "ABOVE",
            data: a!recordData(
              recordType: 'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case'
            ),
            columns: {
              a!gridColumn(
                label: "Title",
                value: a!richTextDisplayField(
                  value: a!richTextItem(
                    text: fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{c263e600-9181-440c-9058-4ab98f78a818}title'],
                    style: "STRONG"
                  ),
                  labelPosition: "COLLAPSED"
                ),
                width: "MEDIUM",
                sortField: 'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{c263e600-9181-440c-9058-4ab98f78a818}title'
              ),
              a!gridColumn(
                label: "Description",
                value: fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{5129cf3d-8111-4b45-9a42-14ec726071d3}description'],
                width: "WIDE",
                sortField: 'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.fields.{5129cf3d-8111-4b45-9a42-14ec726071d3}description'
              ),
              a!gridColumn(
                label: "Status",
                value: a!tagField(
                  tags: a!tagItem(
                    text: fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{4e10ad28-87e8-460b-823e-266911c8306e}caseStatus.fields.{69483c43-a3ed-4c6a-b832-5d17be735c0e}value'],
                    backgroundColor: if(
                      fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{4e10ad28-87e8-460b-823e-266911c8306e}caseStatus.fields.{69483c43-a3ed-4c6a-b832-5d17be735c0e}value'] = "Completed",
                      "POSITIVE",
                      if(
                        fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{4e10ad28-87e8-460b-823e-266911c8306e}caseStatus.fields.{69483c43-a3ed-4c6a-b832-5d17be735c0e}value'] = "In Progress",
                        "ACCENT",
                        if(
                          fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{4e10ad28-87e8-460b-823e-266911c8306e}caseStatus.fields.{69483c43-a3ed-4c6a-b832-5d17be735c0e}value'] = "Pending",
                          "SECONDARY",
                          "SECONDARY"
                        )
                      )
                    )
                  ),
                  size: "SMALL",
                  labelPosition: "COLLAPSED"
                ),
                width: "NARROW_PLUS",
                sortField: 'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{4e10ad28-87e8-460b-823e-266911c8306e}caseStatus.fields.{69483c43-a3ed-4c6a-b832-5d17be735c0e}value'
              ),
              a!gridColumn(
                label: "Priority",
                value: a!richTextDisplayField(
                  value: {
                    a!richTextIcon(
                      icon: if(
                        fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'] = "Critical",
                        "exclamation-circle",
                        if(
                          fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'] = "High",
                          "arrow-up",
                          if(
                            fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'] = "Medium",
                            "minus",
                            "arrow-down"
                          )
                        )
                      ),
                      color: if(
                        fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'] = "Critical",
                        "#FF0000",
                        if(
                          fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'] = "High",
                          "#FF6600",
                          if(
                            fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'] = "Medium",
                            "#FFA500",
                            "#6B6B6B"
                          )
                        )
                      ),
                      size: "MEDIUM"
                    ),
                    " ",
                    a!richTextItem(
                      text: fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'],
                      color: if(
                        fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'] = "Critical",
                        "#FF0000",
                        if(
                          fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'] = "High",
                          "#FF6600",
                          if(
                            fv!row['recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'] = "Medium",
                            "#FFA500",
                            "#6B6B6B"
                          )
                        )
                      ),
                      style: "STRONG"
                    )
                  },
                  labelPosition: "COLLAPSED"
                ),
                width: "NARROW_PLUS",
                sortField: 'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value'
              )
            },
            pageSize: 10,
            initialSorts: {
              a!sortInfo(
                field: 'recordType!{8d967909-a222-410c-bc6d-49673ac772ec}SSSA Case.relationships.{8d417c17-c11c-4764-af6c-411c2db8acfd}priority.fields.{aad946d1-7608-41ba-b1a9-aefb4afbd012}value',
                ascending: true
              )
            },
            spacing: "STANDARD",
            borderStyle: "LIGHT",
            shadeAlternateRows: true,
            emptyGridMessage: "No cases found.",
            selectable: true,
            selectionValue: local!selectedCase,
            selectionSaveInto: local!selectedCase
          )
        },
        style: "NONE",
        shape: "ROUNDED",
        padding: "STANDARD",
        showBorder: true,
        showShadow: false
      )
    },
    contentsPadding: "MORE",
    backgroundColor: "#F5F6F8"
  )
)
