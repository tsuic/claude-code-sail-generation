# Common UI Patterns

## Message Banners

### Basic Messages
```sail
  /* Info Banner */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    style: "#F0F2FC",
    showBorder: false,
    marginAbove: "STANDARD",
    contents: {
      a!sideBySideLayout(
        spacing: "STANDARD",
        items: {
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextIcon(
                icon: "info-circle",
                color: "#143CCC",
                size: "STANDARD"
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "MINIMIZE"
          ),
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(
                  text: "A new Case Management System is available. Contact your Administrator with any questions."
                ),
                a!richTextItem(
                  text: " Learn more",
                  color: "ACCENT",
                  link: a!dynamicLink(),
                  linkStyle: "STANDALONE"
                )
              },
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "AUTO"
          )
        },
        alignVertical: "TOP",
        marginAbove: "STANDARD",
        marginBelow: "STANDARD"
      )
    }
  ),
  /* Closed Banner */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    style: "#F2F2F5",
    showBorder: false,
    marginAbove: "STANDARD",
    contents: {
      a!sideBySideLayout(
        spacing: "STANDARD",
        items: {
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextIcon(
                icon: "lock",
                color: "#5C5C66",
                size: "STANDARD"
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "MINIMIZE"
          ),
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextItem(
                text: "Case #1123 has been locked. A survey has been sent to the customer."
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "AUTO"
          )
        },
        alignVertical: "TOP",
        marginAbove: "STANDARD",
        marginBelow: "STANDARD"
      )
    }
  ),
  /* Success Banner */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    style: "#EDFCEA",
    showBorder: false,
    marginAbove: "STANDARD",
    contents: {
      a!sideBySideLayout(
        spacing: "STANDARD",
        items: {
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextIcon(
                icon: "check-circle",
                color: "#24990F",
                size: "STANDARD"
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "MINIMIZE"
          ),
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextItem(
                text: "Case #1123 has been closed. A survey has been sent to the customer."
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "AUTO"
          )
        },
        alignVertical: "TOP",
        marginAbove: "STANDARD",
        marginBelow: "STANDARD"
      )
    }
  ),
  /* Warning Banner */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    style: "#FFF9DB",
    showBorder: false,
    marginAbove: "STANDARD",
    contents: {
      a!sideBySideLayout(
        spacing: "STANDARD",
        items: {
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextIcon(
                icon: "exclamation-triangle",
                color: "#E5BF00",
                size: "STANDARD"
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "MINIMIZE"
          ),
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(
                  text: "The following case has been open for more than 30 days:"
                ),
                a!richTextItem(
                  text: " Case #1124",
                  color: "ACCENT",
                  link: a!dynamicLink(),
                  linkStyle: "STANDALONE"
                )
              },
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "AUTO"
          )
        },
        alignVertical: "TOP",
        marginAbove: "STANDARD",
        marginBelow: "STANDARD"
      )
    }
  ),
  /* Error Banner */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    style: "#FFEFEF",
    showBorder: false,
    marginAbove: "STANDARD",
    contents: {
      a!sideBySideLayout(
        spacing: "STANDARD",
        items: {
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextIcon(
                icon: "exclamation-triangle",
                color: "#B22D2D",
                size: "STANDARD"
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "MINIMIZE"
          ),
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextItem(
                text: "Case #1125 is missing. Please notify your Administrator."
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "AUTO"
          )
        },
        alignVertical: "TOP",
        marginAbove: "STANDARD",
        marginBelow: "STANDARD"
      )
    }
  )
  ```

### Messages with Actions

Use buttons or links to enable the user to take actions if needed. Actions may include opening a dialog, expanding or collapsing to view more information, or dismissing the banner for example.

If applying a single button, use the SECONDARY style. For two actions, use PRIMARY for the prominent action and LINK style for the secondary action. Use SMALL size for all buttons. Avoid placing more than two actions in a banner.

If using a link, use the LINK parameter in the a!richTextItem() component. Avoid placing links adjacent to each other to prevent errors due to mistaken clicks. Set the LINKSTYLE to STANDALONE.

Note: When using the ‘X’ action to dismiss the banner, specific ‘Dismiss {insert name of item}’ in the accessibilityText parameter.

```sail
  /* Info Banner with Dismiss Button */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    style: "#F0F2FC",
    showBorder: false,
    marginAbove: "STANDARD",
    contents: {
      a!sideBySideLayout(
        spacing: "STANDARD",
        items: {
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextIcon(
                icon: "info-circle",
                color: "#143CCC",
                size: "STANDARD"
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "MINIMIZE"
          ),
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(
                  text: "A new Case Management System is available. Contact your Administrator with any questions."
                ),
                a!richTextItem(
                  text: " Learn more",
                  color: "ACCENT",
                  link: a!dynamicLink(),
                  linkStyle: "STANDALONE"
                )
              },
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "AUTO"
          ),
          a!sideBySideItem(
            item: a!buttonArrayLayout(
              align: "END",
              marginAbove: "NONE",
              marginBelow: "NONE",
              buttons: {
                a!buttonWidget(
                  size: "SMALL",
                  style: "SOLID",
                  label: "Dismiss"
                )
              }
            ),
            width: "MINIMIZE"
          )
        },
        alignVertical: "MIDDLE",
        marginAbove: "STANDARD",
        marginBelow: "STANDARD"
      )
    }
  ),
  /* Success Banner with Go to Log Link */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    style: "#EDFCEA",
    showBorder: false,
    marginAbove: "STANDARD",
    contents: {
      a!sideBySideLayout(
        spacing: "STANDARD",
        items: {
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextIcon(
                icon: "check-circle",
                color: "#24990F",
                size: "STANDARD"
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "MINIMIZE"
          ),
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextItem(
                text: "Case #1123 has been closed. A survey has been sent to the customer."
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "AUTO"
          ),
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextItem(
                text: "Go to log",
                color: "#2322f0",
                link: a!dynamicLink(),
                linkStyle: "STANDALONE"
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "MINIMIZE"
          )
        },
        alignVertical: "MIDDLE",
        marginAbove: "STANDARD",
        marginBelow: "STANDARD"
      )
    }
  ),
  /* Warning Banner with Close Icon */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    style: "#FFF9DB",
    showBorder: false,
    marginAbove: "STANDARD",
    contents: {
      a!sideBySideLayout(
        spacing: "STANDARD",
        items: {
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextIcon(
                icon: "exclamation-triangle",
                color: "#E5BF00",
                size: "STANDARD"
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "MINIMIZE"
          ),
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: {
                a!richTextItem(
                  text: "The following case has been open for more than 30 days:"
                ),
                a!richTextItem(
                  text: " Case #1124",
                  color: "ACCENT",
                  link: a!dynamicLink(),
                  linkStyle: "STANDALONE"
                )
              },
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "AUTO"
          ),
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextIcon(
                icon: "close",
                color: "#000000",
                link: a!dynamicLink(),
                linkStyle: "STANDALONE"
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "MINIMIZE"
          )
        },
        alignVertical: "MIDDLE",
        marginAbove: "STANDARD",
        marginBelow: "STANDARD"
      )
    }
  ),
  /* Error Banner with Ignore and View Errors Buttons */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    style: "#FFEFEF",
    showBorder: false,
    marginAbove: "STANDARD",
    contents: {
      a!sideBySideLayout(
        spacing: "STANDARD",
        items: {
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextIcon(
                icon: "exclamation-triangle",
                color: "#B22D2D",
                size: "STANDARD"
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "MINIMIZE"
          ),
          a!sideBySideItem(
            item: a!richTextDisplayField(
              labelPosition: "COLLAPSED",
              value: a!richTextItem(
                text: "Case #1125 is missing. Please notify your Administrator."
              ),
              marginAbove: "NONE",
              marginBelow: "NONE"
            ),
            width: "AUTO"
          ),
          a!sideBySideItem(
            item: a!buttonArrayLayout(
              align: "END",
              marginAbove: "NONE",
              marginBelow: "NONE",
              buttons: {
                a!buttonWidget(
                  size: "SMALL",
                  style: "LINK",
                  label: "Ignore"
                ),
                a!buttonWidget(
                  size: "SMALL",
                  style: "SOLID",
                  label: "View Errors"
                )
              }
            ),
            width: "MINIMIZE"
          )
        },
        alignVertical: "MIDDLE",
        marginAbove: "STANDARD",
        marginBelow: "STANDARD"
      )
    }
  )
```

### Persistent Messages
Use this for messages that are always going to be a part of the UI. It is up to the designer’s discretion if the border is needed or not based on the UI.

```sail
  /* Info Banner */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    showBorder: true,
    marginAbove: "STANDARD",
    contents: {
      a!columnsLayout(
        alignVertical: "MIDDLE",
        spacing: "DENSE",
        columns: {
          a!columnLayout(
            width: "EXTRA_NARROW",
            contents: {
              a!cardLayout(
                showBorder: false,
                style: "#F0F2FC",
                padding: "STANDARD",
                shape: "SEMI_ROUNDED",
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    align: "CENTER",
                    marginAbove: "EVEN_LESS",
                    marginBelow: "EVEN_LESS",
                    value: a!richTextIcon(icon: "info", color: "#143CCC")
                  )
                }
              )
            }
          ),
          a!columnLayout(
            contents: {
              a!headingField(
                text: "The URL you have entered is not valid",
                size: "EXTRA_SMALL",
                headingTag: "H3",
                marginAbove: "NONE",
                marginBelow: "NONE"
              ),
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                marginAbove: "NONE",
                marginBelow: "NONE",
                value: a!richTextItem(
                  text: "Please check the Web Address in the configuration panel"
                )
              )
            }
          )
        }
      )
    }
  ),
  /* Closed Banner */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    showBorder: true,
    marginAbove: "STANDARD",
    contents: {
      a!columnsLayout(
        alignVertical: "MIDDLE",
        spacing: "DENSE",
        columns: {
          a!columnLayout(
            width: "EXTRA_NARROW",
            contents: {
              a!cardLayout(
                showBorder: false,
                style: "#F2F2F5",
                padding: "STANDARD",
                shape: "SEMI_ROUNDED",
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    align: "CENTER",
                    marginAbove: "EVEN_LESS",
                    marginBelow: "EVEN_LESS",
                    value: a!richTextIcon(icon: "lock", color: "#5C5C66")
                  )
                }
              )
            }
          ),
          a!columnLayout(
            contents: {
              a!headingField(
                text: "The URL you have entered is not valid",
                size: "EXTRA_SMALL",
                headingTag: "H3",
                marginAbove: "NONE",
                marginBelow: "NONE"
              ),
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                marginAbove: "NONE",
                marginBelow: "NONE",
                value: a!richTextItem(
                  text: "Please check the Web Address in the configuration panel"
                )
              )
            }
          )
        }
      )
    }
  ),
  /* Success Banner */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    showBorder: true,
    marginAbove: "STANDARD",
    contents: {
      a!columnsLayout(
        alignVertical: "MIDDLE",
        spacing: "DENSE",
        columns: {
          a!columnLayout(
            width: "EXTRA_NARROW",
            contents: {
              a!cardLayout(
                showBorder: false,
                style: "#EDFCEA",
                padding: "STANDARD",
                shape: "SEMI_ROUNDED",
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    align: "CENTER",
                    marginAbove: "EVEN_LESS",
                    marginBelow: "EVEN_LESS",
                    value: a!richTextIcon(icon: "check-circle", color: "#24990F")
                  )
                }
              )
            }
          ),
          a!columnLayout(
            contents: {
              a!headingField(
                text: "The URL you have entered is not valid",
                size: "EXTRA_SMALL",
                headingTag: "H3",
                marginAbove: "NONE",
                marginBelow: "NONE"
              ),
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                marginAbove: "NONE",
                marginBelow: "NONE",
                value: a!richTextItem(
                  text: "Please check the Web Address in the configuration panel"
                )
              )
            }
          )
        }
      )
    }
  ),
  /* Warning Banner */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    showBorder: true,
    marginAbove: "STANDARD",
    contents: {
      a!columnsLayout(
        alignVertical: "MIDDLE",
        spacing: "DENSE",
        columns: {
          a!columnLayout(
            width: "EXTRA_NARROW",
            contents: {
              a!cardLayout(
                showBorder: false,
                style: "#FFF9DB",
                padding: "STANDARD",
                shape: "SEMI_ROUNDED",
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    align: "CENTER",
                    marginAbove: "EVEN_LESS",
                    marginBelow: "EVEN_LESS",
                    value: a!richTextIcon(
                      icon: "exclamation-triangle",
                      color: "#E5BF00"
                    )
                  )
                }
              )
            }
          ),
          a!columnLayout(
            contents: {
              a!headingField(
                text: "The URL you have entered is not valid",
                size: "EXTRA_SMALL",
                headingTag: "H3",
                marginAbove: "NONE",
                marginBelow: "NONE"
              ),
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                marginAbove: "NONE",
                marginBelow: "NONE",
                value: a!richTextItem(
                  text: "Please check the Web Address in the configuration panel"
                )
              )
            }
          )
        }
      )
    }
  ),
  /* Error Banner */
  a!cardLayout(
    shape: "SEMI_ROUNDED",
    showBorder: true,
    marginAbove: "STANDARD",
    contents: {
      a!columnsLayout(
        alignVertical: "MIDDLE",
        spacing: "DENSE",
        columns: {
          a!columnLayout(
            width: "EXTRA_NARROW",
            contents: {
              a!cardLayout(
                showBorder: false,
                style: "#FFEFEF",
                padding: "STANDARD",
                shape: "SEMI_ROUNDED",
                contents: {
                  a!richTextDisplayField(
                    labelPosition: "COLLAPSED",
                    align: "CENTER",
                    marginAbove: "EVEN_LESS",
                    marginBelow: "EVEN_LESS",
                    value: a!richTextIcon(
                      icon: "exclamation-triangle",
                      color: "#B22D2D"
                    )
                  )
                }
              )
            }
          ),
          a!columnLayout(
            contents: {
              a!headingField(
                text: "The URL you have entered is not valid",
                size: "EXTRA_SMALL",
                headingTag: "H3",
                marginAbove: "NONE",
                marginBelow: "NONE"
              ),
              a!richTextDisplayField(
                labelPosition: "COLLAPSED",
                marginAbove: "NONE",
                marginBelow: "NONE",
                value: a!richTextItem(
                  text: "Please check the Web Address in the configuration panel"
                )
              )
            }
          )
        }
      )
    }
  )
```

## Tabs

### Horizontal Tab Bar with Optional Badges
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

## KPI Cards
```sail
a!localVariables(
  /* Sample KPI data for mockup */
  local!currentRevenue: 2456789,
  local!revenueGrowth: 12.5,
  local!totalUsers: 15847,
  local!userGrowth: 8.3,
  local!systemUptime: 99.8,
  local!completedTasks: 324,
  local!totalTasks: 378,

  a!cardGroupLayout(
    cards: {
      /* Revenue KPI Card */
      a!cardLayout(
        contents: {
          a!sideBySideLayout(
            items: {
              a!sideBySideItem(
                item: a!stampField(
                  icon: "dollar",
                  backgroundColor: "#059669",
                  contentColor: "#FFFFFF",
                  size: "TINY",
                  shape: "ROUNDED",
                  labelPosition: "COLLAPSED"
                ),
                width: "MINIMIZE"
              ),
              a!sideBySideItem(
                item: a!richTextDisplayField(
                  value: {
                    a!richTextItem(
                      text: "Total Revenue",
                      color: "#6B7280",
                      size: "STANDARD"
                    ),
                    char(10),
                    a!richTextItem(
                      text: dollar(local!currentRevenue,0), /* Drop decimals from whole dollar amount */
                      style: "STRONG",
                      size: "LARGE",
                      color: "#262626"
                    ),
                    char(10),
                    a!richTextIcon(
                      icon: "arrow-up",
                      color: "#059669",
                      size: "SMALL"
                    ),
                    " ",
                    a!richTextItem(
                      text: local!revenueGrowth & "% from last quarter",
                      color: "#059669",
                      size: "SMALL",
                      style: "STRONG"
                    )
                  },
                  labelPosition: "COLLAPSED"
                ),
                width: "AUTO"
              )
            },
            alignVertical: "MIDDLE",
            spacing: "STANDARD"
          )
        },
        style: "#FFFFFF",
        showBorder: true,
        padding: "MORE",
        shape: "ROUNDED"
      ),

      /* Active Users KPI Card */
      a!cardLayout(
        contents: {
          a!sideBySideLayout(
            items: {
              a!sideBySideItem(
                item: a!stampField(
                  icon: "users",
                  backgroundColor: "#3B82F6",
                  contentColor: "#FFFFFF",
                  size: "TINY",
                  shape: "ROUNDED",
                  labelPosition: "COLLAPSED"
                ),
                width: "MINIMIZE"
              ),
              a!sideBySideItem(
                item: a!richTextDisplayField(
                  value: {
                    a!richTextItem(
                      text: "Active Users",
                      color: "#6B7280",
                      size: "STANDARD"
                    ),
                    char(10),
                    a!richTextItem(
                      text: text(local!totalUsers, "##,###"),
                      style: "STRONG",
                      size: "LARGE",
                      color: "#262626"
                    ),
                    char(10),
                    a!richTextIcon(
                      icon: "arrow-up",
                      color: "#059669",
                      size: "SMALL"
                    ),
                    " ",
                    a!richTextItem(
                      text: local!userGrowth & "% this month",
                      color: "#059669",
                      size: "SMALL",
                      style: "STRONG"
                    )
                  },
                  labelPosition: "COLLAPSED"
                ),
                width: "AUTO"
              )
            },
            alignVertical: "MIDDLE",
            spacing: "STANDARD"
          )
        },
        style: "#FFFFFF",
        showBorder: true,
        padding: "MORE",
        shape: "ROUNDED"
      ),

      /* System Uptime KPI Card */
      a!cardLayout(
        contents: {
          a!sideBySideLayout(
            items: {
              a!sideBySideItem(
                item: a!stampField(
                  icon: "server",
                  backgroundColor: "#7C3AED",
                  contentColor: "#FFFFFF",
                  size: "TINY",
                  shape: "ROUNDED",
                  labelPosition: "COLLAPSED"
                ),
                width: "MINIMIZE"
              ),
              a!sideBySideItem(
                item: a!richTextDisplayField(
                  value: {
                    a!richTextItem(
                      text: "System Uptime",
                      color: "#6B7280",
                      size: "STANDARD"
                    ),
                    char(10),
                    a!richTextItem(
                      text: local!systemUptime & "%",
                      style: "STRONG",
                      size: "LARGE",
                      color: "#262626"
                    ),
                    char(10),
                    a!richTextItem(
                      text: "99.9% SLA Target",
                      color: "#6B7280",
                      size: "SMALL"
                    )
                  },
                  labelPosition: "COLLAPSED"
                ),
                width: "AUTO"
              )
            },
            alignVertical: "MIDDLE",
            spacing: "STANDARD"
          ),
          a!progressBarField(
            percentage: tointeger(local!systemUptime),
            color: "#7C3AED",
            style: "THIN",
            showPercentage: false,
            labelPosition: "COLLAPSED",
            marginAbove: "STANDARD"
          )
        },
        style: "#FFFFFF",
        showBorder: true,
        padding: "MORE",
        shape: "ROUNDED"
      ),

      /* Task Completion KPI Card */
      a!cardLayout(
        contents: {
          a!sideBySideLayout(
            items: {
              a!sideBySideItem(
                item: a!stampField(
                  icon: "check-circle",
                  backgroundColor: "#059669",
                  contentColor: "#FFFFFF",
                  size: "TINY",
                  shape: "ROUNDED",
                  labelPosition: "COLLAPSED"
                ),
                width: "MINIMIZE"
              ),
              a!sideBySideItem(
                item: a!richTextDisplayField(
                  value: {
                    a!richTextItem(
                      text: "Tasks Completed",
                      color: "#6B7280",
                      size: "STANDARD"
                    ),
                    char(10),
                    a!richTextItem(
                      text: local!completedTasks & " / " & local!totalTasks,
                      style: "STRONG",
                      size: "LARGE",
                      color: "#262626"
                    ),
                    char(10),
                    a!richTextItem(
                      text: fixed(local!completedTasks / local!totalTasks * 100, 1) & "% completion rate",
                      color: "#059669",
                      size: "SMALL",
                      style: "STRONG"
                    )
                  },
                  labelPosition: "COLLAPSED"
                ),
                width: "AUTO"
              )
            },
            alignVertical: "MIDDLE",
            spacing: "STANDARD"
          ),
          a!progressBarField(
            percentage: tointeger(local!completedTasks / local!totalTasks * 100),
            color: "#059669",
            style: "THIN",
            showPercentage: false,
            labelPosition: "COLLAPSED",
            marginAbove: "STANDARD"
          )
        },
        style: "#FFFFFF",
        showBorder: true,
        padding: "MORE",
        shape: "ROUNDED"
      ),

      /* Conversion Rate KPI Card with Gauge */
      a!cardLayout(
        contents: {
          a!sideBySideLayout(
            items: {
              a!sideBySideItem(
                item: a!gaugeField(
                  percentage: 73.2,
                  primaryText: "73%",
                  secondaryText: "Rate",
                  color: "#F59E0B",
                  size: "SMALL",
                  labelPosition: "COLLAPSED"
                ),
                width: "MINIMIZE"
              ),
              a!sideBySideItem(
                item: a!richTextDisplayField(
                  value: {
                    a!richTextItem(
                      text: "Conversion Rate",
                      color: "#6B7280",
                      size: "STANDARD"
                    ),
                    char(10),
                    a!richTextItem(
                      text: "Lead to Customer",
                      style: "STRONG",
                      size: "MEDIUM_PLUS",
                      color: "#262626"
                    ),
                    char(10),
                    a!richTextIcon(
                      icon: "arrow-up",
                      color: "#059669",
                      size: "SMALL"
                    ),
                    " ",
                    a!richTextItem(
                      text: "5.2% vs last month",
                      color: "#059669",
                      size: "SMALL",
                      style: "STRONG"
                    )
                  },
                  labelPosition: "COLLAPSED"
                ),
                width: "AUTO"
              )
            },
            alignVertical: "MIDDLE",
            spacing: "STANDARD"
          )
        },
        style: "#FFFFFF",
        showBorder: true,
        padding: "MORE",
        shape: "ROUNDED"
      ),

      /* Customer Satisfaction KPI Card */
      a!cardLayout(
        contents: {
          a!sideBySideLayout(
            items: {
              a!sideBySideItem(
                item: a!stampField(
                  icon: "star",
                  backgroundColor: "#F59E0B",
                  contentColor: "#FFFFFF",
                  size: "TINY",
                  shape: "ROUNDED",
                  labelPosition: "COLLAPSED"
                ),
                width: "MINIMIZE"
              ),
              a!sideBySideItem(
                item: a!richTextDisplayField(
                  value: {
                    a!richTextItem(
                      text: "Customer Satisfaction",
                      color: "#6B7280",
                      size: "STANDARD"
                    ),
                    char(10),
                    a!richTextItem(
                      text: "4.8 / 5.0",
                      style: "STRONG",
                      size: "LARGE",
                      color: "#262626"
                    ),
                    char(10),
                    a!richTextItem(
                      text: "Based on 2,847 reviews",
                      color: "#6B7280",
                      size: "SMALL"
                    )
                  },
                  labelPosition: "COLLAPSED"
                ),
                width: "AUTO"
              ),
              a!sideBySideItem(
                item: a!tagField(
                  tags: a!tagItem(
                    text: "EXCELLENT",
                    backgroundColor: "#059669"
                  ),
                  size: "SMALL",
                  labelPosition: "COLLAPSED"
                ),
                width: "MINIMIZE"
              )
            },
            alignVertical: "MIDDLE",
            spacing: "STANDARD"
          )
        },
        style: "#FFFFFF",
        showBorder: true,
        padding: "MORE",
        shape: "ROUNDED"
      )
    },
    cardWidth: "MEDIUM",
    spacing: "STANDARD"
  )
)
```