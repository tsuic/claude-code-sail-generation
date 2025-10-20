# Tabs

SAIL doesn't have a tab component. Follow these patterns to render tabs.

## Horizontal Tab Bar with Optional Badges
```sail
a!localVariables(
  local!tabs: {
    a!map(title: "Applied Clauses", badge: "5"),
    a!map(title: "Questionnaire", badge: "2"),
    a!map(title: "Excluded Clauses", badge: "1"),
    a!map(title: "Log History", badge: "0")
  },
  local!selectedTab: 1,
  local!backgroundColor: "#FFFFFF",
  a!cardLayout(
    contents: {
      a!cardLayout(
        contents: {
          a!columnsLayout(
            columns: {
              a!forEach(
                items: local!tabs,
                expression: {
                  a!columnLayout(
                    contents: {
                      a!cardLayout(
                        contents: {
                          a!sideBySideLayout(
                            items: {
                              a!sideBySideItem(),
                              a!sideBySideItem(
                                /* Tab label */
                                item: a!richTextDisplayField(
                                  labelPosition: "COLLAPSED",
                                  value: {
                                    a!richTextItem(
                                      text: { fv!item.title },
                                      color: "STANDARD",
                                      size: "STANDARD",
                                      style: if(
                                        fv!index = local!selectedTab,
                                        "STRONG",
                                        "PLAIN"
                                      )
                                    )
                                  },
                                  align: "CENTER",
                                  marginBelow: "NONE"
                                ),
                                width: "MINIMIZE"
                              ),
                              a!sideBySideItem(
                                /* Optional badge */
                                item: a!tagField(
                                  labelPosition: "COLLAPSED",
                                  tags: {
                                    a!tagItem(
                                      text: fv!item.badge,
                                      backgroundColor: "#EDEEF2",
                                      textColor: "#2E2E35"
                                    )
                                  },
                                  size: "SMALL",
                                  marginBelow: "NONE"
                                ),
                                width: "MINIMIZE"
                              ),
                              a!sideBySideItem()
                            },
                            alignVertical: "BOTTOM",
                            spacing: "",
                            marginAbove: "STANDARD",
                            marginBelow: "LESS"
                          )
                        },
                        link: if(
                          fv!index = local!selectedTab,
                          {},
                          a!dynamicLink(
                            value: fv!index,
                            saveInto: local!selectedTab
                          )
                        ),
                        height: "AUTO",
                        style: "NONE",
                        padding: "EVEN_LESS",
                        marginBelow: "NONE",
                        showBorder: false,
                        decorativeBarPosition: "BOTTOM",
                        decorativeBarColor: if(
                          fv!index = local!selectedTab,
                          "ACCENT",
                          local!backgroundColor
                        ),
                        accessibilityText: if(
                          fv!index = local!selectedTab,
                          "Selected",
                          ""
                        )
                      )
                    },
                    width: "NARROW"
                  )
                }
              )
            },
            marginBelow: "NONE",
            spacing: "NONE",
            showDividers: false
          )
        },
        height: "AUTO",
        style: "NONE",
        padding: "NONE",
        marginBelow: "NONE",
        showBorder: false,
        showShadow: false
      ),
      a!cardLayout(
        contents: {
          /* Selected tab contents here */

        },
        height: "AUTO",
        style: "NONE",
        padding: "STANDARD",
        marginBelow: "NONE",
        showBorder: false
      )
    },
    height: "AUTO",
    style: "NONE",
    shape: "SEMI_ROUNDED",
    padding: "NONE",
    marginBelow: "STANDARD",
    showBorder: false,
    showShadow: true
  )
)
```