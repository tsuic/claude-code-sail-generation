a!localVariables(
  /* Static mockup data for SSSA cases */
  local!casesData: {
    a!map(
      id: 1,
      title: "Tax Withholding Discrepancy",
      description: "Client reports incorrect withholding rate applied to dividend payment",
      status: "Open",
      priority: "High"
    ),
    a!map(
      id: 2,
      title: "Treaty Benefit Documentation",
      description: "Missing W-8BEN form for foreign investor claiming treaty benefits",
      status: "In Progress",
      priority: "High"
    ),
    a!map(
      id: 3,
      title: "Reclaim Processing Delay",
      description: "Reclaim submission pending additional documentation from agent",
      status: "Pending",
      priority: "Medium"
    ),
    a!map(
      id: 4,
      title: "Quick Refund Request",
      description: "Expedited processing requested for time-sensitive reclaim",
      status: "Open",
      priority: "Critical"
    ),
    a!map(
      id: 5,
      title: "Classification Update",
      description: "Security classification change requires re-evaluation of tax treatment",
      status: "In Progress",
      priority: "Medium"
    ),
    a!map(
      id: 6,
      title: "Rate Verification",
      description: "Verify statutory withholding rate for new country jurisdiction",
      status: "Open",
      priority: "Low"
    ),
    a!map(
      id: 7,
      title: "Agent Communication",
      description: "Follow up with paying agent on outstanding documentation",
      status: "Pending",
      priority: "Medium"
    ),
    a!map(
      id: 8,
      title: "Position Reconciliation",
      description: "RD position and election total mismatch requires investigation",
      status: "Open",
      priority: "High"
    ),
    a!map(
      id: 9,
      title: "System Data Error",
      description: "Incorrect CUSIP mapping in system causing processing errors",
      status: "In Progress",
      priority: "Critical"
    ),
    a!map(
      id: 10,
      title: "Report Generation",
      description: "Generate supplemental PA report for amended filing",
      status: "Completed",
      priority: "Low"
    )
  },

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
                text: "SSSA Cases Dashboard",
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
            data: local!casesData,
            columns: {
              a!gridColumn(
                label: "Title",
                value: a!richTextDisplayField(
                  value: a!richTextItem(
                    text: fv!row.title,
                    style: "STRONG"
                  ),
                  labelPosition: "COLLAPSED"
                ),
                width: "MEDIUM",
                sortField: "title"
              ),
              a!gridColumn(
                label: "Description",
                value: fv!row.description,
                width: "WIDE",
                sortField: "description"
              ),
              a!gridColumn(
                label: "Status",
                value: a!tagField(
                  tags: a!tagItem(
                    text: fv!row.status,
                    backgroundColor: if(
                      fv!row.status = "Completed",
                      "POSITIVE",
                      if(
                        fv!row.status = "In Progress",
                        "ACCENT",
                        if(
                          fv!row.status = "Pending",
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
                sortField: "status"
              ),
              a!gridColumn(
                label: "Priority",
                value: a!richTextDisplayField(
                  value: {
                    a!richTextIcon(
                      icon: if(
                        fv!row.priority = "Critical",
                        "exclamation-circle",
                        if(
                          fv!row.priority = "High",
                          "arrow-up",
                          if(
                            fv!row.priority = "Medium",
                            "minus",
                            "arrow-down"
                          )
                        )
                      ),
                      color: if(
                        fv!row.priority = "Critical",
                        "#FF0000",
                        if(
                          fv!row.priority = "High",
                          "#FF6600",
                          if(
                            fv!row.priority = "Medium",
                            "#FFA500",
                            "#6B6B6B"
                          )
                        )
                      ),
                      size: "MEDIUM"
                    ),
                    " ",
                    a!richTextItem(
                      text: fv!row.priority,
                      color: if(
                        fv!row.priority = "Critical",
                        "#FF0000",
                        if(
                          fv!row.priority = "High",
                          "#FF6600",
                          if(
                            fv!row.priority = "Medium",
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
                sortField: "priority"
              )
            },
            pageSize: 10,
            initialSorts: {
              a!sortInfo(field: "priority", ascending: true)
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