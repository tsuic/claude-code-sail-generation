# Example React-to-SAIL Conversion
Below is a React UI and the corresponding SAIL UI demonstrating a proper conversion
## Example React + Tailwind UI
```react

import React from 'react';
import { Activity, Users, Calendar, AlertTriangle, CheckCircle, Clock, TrendingUp, MapPin, Shield, FileText } from 'lucide-react';

const Dashboard = () => {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-6 py-4">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-2xl font-semibold text-gray-900">Trial XR-2024-001</h1>
              <p className="text-sm text-gray-600">Phase III Clinical Trial - Cardiovascular Treatment</p>
            </div>
            <div className="flex items-center space-x-3">
              <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-green-100 text-green-800">
                <CheckCircle className="w-4 h-4 mr-1" />
                Active
              </span>
              <span className="text-sm text-gray-500">Last updated: 2 hours ago</span>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-6 py-6">
        {/* Key Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <Users className="h-8 w-8 text-blue-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-500">Enrolled Patients</p>
                <p className="text-2xl font-semibold text-gray-900">847</p>
                <p className="text-sm text-green-600">of 1,200 target</p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <Activity className="h-8 w-8 text-green-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-500">Completion Rate</p>
                <p className="text-2xl font-semibold text-gray-900">92.3%</p>
                <p className="text-sm text-green-600">Above target</p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <Calendar className="h-8 w-8 text-purple-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-500">Days Remaining</p>
                <p className="text-2xl font-semibold text-gray-900">127</p>
                <p className="text-sm text-gray-600">Est. completion Q3 2025</p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-center">
              <div className="flex-shrink-0">
                <Shield className="h-8 w-8 text-red-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-500">Safety Events</p>
                <p className="text-2xl font-semibold text-gray-900">12</p>
                <p className="text-sm text-yellow-600">3 under review</p>
              </div>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Main Content Area */}
          <div className="lg:col-span-2 space-y-6">
            {/* Trial Progress */}
            <div className="bg-white rounded-lg shadow-sm p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Trial Progress</h3>
              <div className="space-y-4">
                <div>
                  <div className="flex justify-between text-sm text-gray-600 mb-1">
                    <span>Patient Enrollment</span>
                    <span>847/1,200 (70.6%)</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div className="bg-blue-600 h-2 rounded-full" style={{ width: '70.6%' }}></div>
                  </div>
                </div>
                <div>
                  <div className="flex justify-between text-sm text-gray-600 mb-1">
                    <span>Data Collection</span>
                    <span>782/847 (92.3%)</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div className="bg-green-600 h-2 rounded-full" style={{ width: '92.3%' }}></div>
                  </div>
                </div>
                <div>
                  <div className="flex justify-between text-sm text-gray-600 mb-1">
                    <span>Overall Timeline</span>
                    <span>65% Complete</span>
                  </div>
                  <div className="w-full bg-gray-200 rounded-full h-2">
                    <div className="bg-purple-600 h-2 rounded-full" style={{ width: '65%' }}></div>
                  </div>
                </div>
              </div>
            </div>

            {/* Recent Activities */}
            <div className="bg-white rounded-lg shadow-sm p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Recent Activities</h3>
              <div className="space-y-4">
                <div className="flex items-start space-x-3">
                  <div className="flex-shrink-0">
                    <div className="w-2 h-2 bg-green-400 rounded-full mt-2"></div>
                  </div>
                  <div className="flex-1">
                    <p className="text-sm text-gray-900">Site 007 - Johns Hopkins completed patient visit #342</p>
                    <p className="text-xs text-gray-500">2 hours ago</p>
                  </div>
                </div>
                <div className="flex items-start space-x-3">
                  <div className="flex-shrink-0">
                    <div className="w-2 h-2 bg-blue-400 rounded-full mt-2"></div>
                  </div>
                  <div className="flex-1">
                    <p className="text-sm text-gray-900">New patient enrolled at Site 012 - Mayo Clinic</p>
                    <p className="text-xs text-gray-500">4 hours ago</p>
                  </div>
                </div>
                <div className="flex items-start space-x-3">
                  <div className="flex-shrink-0">
                    <div className="w-2 h-2 bg-yellow-400 rounded-full mt-2"></div>
                  </div>
                  <div className="flex-1">
                    <p className="text-sm text-gray-900">Adverse event reported at Site 003 - requires review</p>
                    <p className="text-xs text-gray-500">6 hours ago</p>
                  </div>
                </div>
                <div className="flex items-start space-x-3">
                  <div className="flex-shrink-0">
                    <div className="w-2 h-2 bg-green-400 rounded-full mt-2"></div>
                  </div>
                  <div className="flex-1">
                    <p className="text-sm text-gray-900">Monthly safety report submitted to FDA</p>
                    <p className="text-xs text-gray-500">1 day ago</p>
                  </div>
                </div>
              </div>
            </div>

            {/* Site Performance */}
            <div className="bg-white rounded-lg shadow-sm p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Site Performance</h3>
              <div className="space-y-3">
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <div className="flex items-center space-x-3">
                    <MapPin className="h-5 w-5 text-gray-400" />
                    <div>
                      <p className="font-medium text-gray-900">Johns Hopkins Medical Center</p>
                      <p className="text-sm text-gray-500">Baltimore, MD • Site 007</p>
                    </div>
                  </div>
                  <div className="flex items-center space-x-4">
                    <span className="text-sm font-medium text-gray-900">89 patients</span>
                    <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                      Excellent
                    </span>
                  </div>
                </div>
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <div className="flex items-center space-x-3">
                    <MapPin className="h-5 w-5 text-gray-400" />
                    <div>
                      <p className="font-medium text-gray-900">Mayo Clinic</p>
                      <p className="text-sm text-gray-500">Rochester, MN • Site 012</p>
                    </div>
                  </div>
                  <div className="flex items-center space-x-4">
                    <span className="text-sm font-medium text-gray-900">76 patients</span>
                    <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                      Excellent
                    </span>
                  </div>
                </div>
                <div className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                  <div className="flex items-center space-x-3">
                    <MapPin className="h-5 w-5 text-gray-400" />
                    <div>
                      <p className="font-medium text-gray-900">Cleveland Clinic</p>
                      <p className="text-sm text-gray-500">Cleveland, OH • Site 003</p>
                    </div>
                  </div>
                  <div className="flex items-center space-x-4">
                    <span className="text-sm font-medium text-gray-900">52 patients</span>
                    <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                      Needs Attention
                    </span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Alerts & Notifications */}
            <div className="bg-white rounded-lg shadow-sm p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Alerts & Notifications</h3>
              <div className="space-y-3">
                <div className="flex items-start space-x-3 p-3 bg-red-50 rounded-lg">
                  <AlertTriangle className="h-5 w-5 text-red-600 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-red-900">Safety Review Required</p>
                    <p className="text-xs text-red-700">3 adverse events pending review</p>
                  </div>
                </div>
                <div className="flex items-start space-x-3 p-3 bg-yellow-50 rounded-lg">
                  <Clock className="h-5 w-5 text-yellow-600 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-yellow-900">Milestone Approaching</p>
                    <p className="text-xs text-yellow-700">50% enrollment due in 14 days</p>
                  </div>
                </div>
                <div className="flex items-start space-x-3 p-3 bg-blue-50 rounded-lg">
                  <FileText className="h-5 w-5 text-blue-600 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-blue-900">Report Due</p>
                    <p className="text-xs text-blue-700">Quarterly safety report due June 30</p>
                  </div>
                </div>
              </div>
            </div>

            {/* Quick Stats */}
            <div className="bg-white rounded-lg shadow-sm p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Quick Stats</h3>
              <div className="space-y-4">
                <div className="flex justify-between">
                  <span className="text-sm text-gray-600">Active Sites</span>
                  <span className="text-sm font-medium text-gray-900">15</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-sm text-gray-600">Screen Failures</span>
                  <span className="text-sm font-medium text-gray-900">123 (12.7%)</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-sm text-gray-600">Withdrawals</span>
                  <span className="text-sm font-medium text-gray-900">34 (4.0%)</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-sm text-gray-600">Protocol Violations</span>
                  <span className="text-sm font-medium text-gray-900">8 (0.9%)</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-sm text-gray-600">Data Queries</span>
                  <span className="text-sm font-medium text-gray-900">156 open</span>
                </div>
              </div>
            </div>

            {/* Timeline */}
            <div className="bg-white rounded-lg shadow-sm p-6">
              <h3 className="text-lg font-semibold text-gray-900 mb-4">Key Milestones</h3>
              <div className="space-y-4">
                <div className="flex items-center space-x-3">
                  <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                  <div>
                    <p className="text-sm font-medium text-gray-900">First Patient In</p>
                    <p className="text-xs text-gray-500">Jan 15, 2024</p>
                  </div>
                </div>
                <div className="flex items-center space-x-3">
                  <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                  <div>
                    <p className="text-sm font-medium text-gray-900">50% Enrollment</p>
                    <p className="text-xs text-gray-500">Expected Jul 3, 2025</p>
                  </div>
                </div>
                <div className="flex items-center space-x-3">
                  <div className="w-3 h-3 bg-gray-300 rounded-full"></div>
                  <div>
                    <p className="text-sm font-medium text-gray-900">Last Patient In</p>
                    <p className="text-xs text-gray-500">Expected Oct 15, 2025</p>
                  </div>
                </div>
                <div className="flex items-center space-x-3">
                  <div className="w-3 h-3 bg-gray-300 rounded-full"></div>
                  <div>
                    <p className="text-sm font-medium text-gray-900">Database Lock</p>
                    <p className="text-xs text-gray-500">Expected Feb 28, 2026</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;

```

## Example SAIL UI (Converted from React example above)
```sail

a!localVariables(
  a!headerContentLayout(
    header: a!cardLayout(
      contents: a!columnsLayout(
        columns: {
          a!columnLayout(width: "AUTO"),
          a!columnLayout(
            contents: {
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    contents: {
                      a!richTextDisplayField(
                        value: a!richTextItem(
                          text: "Trial XR-2024-001",
                          size: "LARGE",
                          style: "STRONG"
                        ),
                        marginBelow: "NONE"
                      ),
                      a!richTextDisplayField(
                        value: {
                          a!richTextItem(
                            text: {
                              "Phase III Clinical Trial - Cardiovascular Treatment"
                            },
                            color: "STANDARD",
                            size: "STANDARD"
                          )
                        }
                      )
                    },
                    width: "AUTO"
                  ),
                  a!columnLayout(
                    contents: {
                      a!sideBySideLayout(
                        items: {
                          a!sideBySideItem(),
                          /* empty item to take up remaining space - other items have MINIMIZE width */
                          a!sideBySideItem(
                            item: a!tagField(
                              tags: a!tagItem(
                                text: "✓ Active",
                                backgroundColor: "#dcfce7",
                                textColor: "#016630"
                              )
                            ),
                            width: "MINIMIZE"
                          ),
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              value: a!richTextItem(
                                text: "Last updated: 2 hours ago",
                                color: "SECONDARY",
                                size: "SMALL"
                              )
                            ),
                            width: "MINIMIZE"
                          )
                        },
                        alignVertical: "MIDDLE",
                        spacing: "STANDARD"
                      )
                    },
                    width: "AUTO"
                  )
                },
                alignVertical: "MIDDLE"
              )
            },
            width: "WIDE_PLUS"
          ),
          a!columnLayout(width: "AUTO")
        }
      ),
      padding: "STANDARD",
      showBorder: false,
      showShadow: true
    ),
    contents: {
      a!columnsLayout(
        columns: {
          a!columnLayout(width: "AUTO"),
          a!columnLayout(
            contents: {
              /* KPI Cards */
              a!cardGroupLayout(
                spacing: "STANDARD",
                cards: {
                  a!cardLayout(
                    contents: {
                      a!sideBySideLayout(
                        items: {
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              value: {
                                a!richTextIcon(
                                  icon: "users",
                                  color: "#2563EB",
                                  size: "LARGE"
                                )
                              }
                            ),
                            width: "MINIMIZE"
                          ),
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              value: {
                                a!richTextItem(
                                  text: { "Enrolled Patients" },
                                  color: "#6a7282",
                                  size: "STANDARD"
                                ),
                                char(10),
                                a!richTextItem(
                                  text: { "847" },
                                  size: "LARGE",
                                  style: { "STRONG" }
                                ),
                                char(10),
                                a!richTextItem(
                                  text: { "of 1,200 target" },
                                  color: "POSITIVE",
                                  size: "STANDARD"
                                )
                              }
                            )
                          )
                        },
                        alignVertical: "MIDDLE"
                      )
                    },
                    shape: "ROUNDED",
                    padding: "STANDARD"
                  ),
                  a!cardLayout(
                    contents: {
                      a!sideBySideLayout(
                        items: {
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              value: {
                                a!richTextIcon(
                                  icon: "line-chart",
                                  color: "#16A34A",
                                  size: "LARGE"
                                )
                              }
                            ),
                            width: "MINIMIZE"
                          ),
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              value: {
                                a!richTextItem(
                                  text: { "Completion Rate" },
                                  color: "#6a7282",
                                  size: "STANDARD"
                                ),
                                char(10),
                                a!richTextItem(
                                  text: { "92.3%" },
                                  size: "LARGE",
                                  style: { "STRONG" }
                                ),
                                char(10),
                                a!richTextItem(
                                  text: { "Above target" },
                                  color: "POSITIVE",
                                  size: "STANDARD"
                                )
                              }
                            )
                          )
                        },
                        alignVertical: "MIDDLE"
                      )
                    },
                    shape: "ROUNDED",
                    padding: "STANDARD"
                  ),
                  a!cardLayout(
                    contents: {
                      a!sideBySideLayout(
                        items: {
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              value: {
                                a!richTextIcon(
                                  icon: "calendar",
                                  color: "#9333EA",
                                  size: "LARGE"
                                )
                              }
                            ),
                            width: "MINIMIZE"
                          ),
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              value: {
                                a!richTextItem(
                                  text: { "Days Remaining" },
                                  color: "#6a7282",
                                  size: "STANDARD"
                                ),
                                char(10),
                                a!richTextItem(
                                  text: { "127" },
                                  size: "LARGE",
                                  style: { "STRONG" }
                                ),
                                char(10),
                                a!richTextItem(
                                  text: { "Est. completion Q3 2025" },
                                  color: "SECONDARY",
                                  size: "STANDARD"
                                )
                              }
                            )
                          )
                        },
                        alignVertical: "MIDDLE"
                      )
                    },
                    shape: "ROUNDED",
                    padding: "STANDARD"
                  ),
                  a!cardLayout(
                    contents: {
                      a!sideBySideLayout(
                        items: {
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              value: {
                                a!richTextIcon(
                                  icon: "shield",
                                  color: "#DC2626",
                                  size: "LARGE"
                                )
                              }
                            ),
                            width: "MINIMIZE"
                          ),
                          a!sideBySideItem(
                            item: a!richTextDisplayField(
                              value: {
                                a!richTextItem(
                                  text: { "Safety Events" },
                                  color: "#6a7282",
                                  size: "STANDARD"
                                ),
                                char(10),
                                a!richTextItem(
                                  text: { "12" },
                                  size: "LARGE",
                                  style: { "STRONG" }
                                ),
                                char(10),
                                a!richTextItem(
                                  text: { "3 under review" },
                                  color: "#D97706",
                                  size: "STANDARD"
                                )
                              }
                            )
                          )
                        },
                        alignVertical: "MIDDLE"
                      )
                    },
                    shape: "ROUNDED",
                    padding: "STANDARD"
                  )
                },
                cardWidth: "NARROW"
              ),
              /* Main Content Grid */
              a!columnsLayout(
                columns: {
                  a!columnLayout(
                    contents: {
                      /* Trial Progress */
                      a!cardLayout(
                        contents: {
                          a!richTextDisplayField(
                            value: a!richTextItem(
                              text: "Trial Progress",
                              size: "MEDIUM_PLUS",
                              style: "STRONG"
                            ),
                            marginBelow: "STANDARD",
                            labelPosition: "COLLAPSED"
                          ),
                          /* Patient Enrollment Progress */
                          a!columnsLayout(
                            columns: {
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "Patient Enrollment",
                                    color: "#405552",
                                    size: "STANDARD"
                                  )
                                ),
                                width: "AUTO"
                              ),
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "847/1,200 (70.6%)",
                                    color: "#405552",
                                    size: "STANDARD"
                                  ),
                                  align: "RIGHT"
                                ),
                                width: "AUTO"
                              )
                            }
                          ),
                          a!progressBarField(
                            percentage: 71,
                            color: "#2563EB",
                            style: "THIN",
                            marginBelow: "STANDARD",
                            showPercentage: false
                          ),
                          /* Data Collection Progress */
                          a!columnsLayout(
                            columns: {
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "Data Collection",
                                    color: "#405552",
                                    size: "STANDARD"
                                  )
                                ),
                                width: "AUTO"
                              ),
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "782/847 (92.3%)",
                                    color: "#405552",
                                    size: "STANDARD"
                                  ),
                                  align: "RIGHT"
                                ),
                                width: "AUTO"
                              )
                            }
                          ),
                          a!progressBarField(
                            percentage: 92,
                            color: "#16A34A",
                            style: "THIN",
                            marginBelow: "STANDARD",
                            showPercentage: false
                          ),
                          /* Overall Timeline Progress */
                          a!columnsLayout(
                            columns: {
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "Overall Timeline",
                                    color: "#405552",
                                    size: "STANDARD"
                                  )
                                ),
                                width: "AUTO"
                              ),
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "65% Complete",
                                    color: "#405552",
                                    size: "STANDARD"
                                  ),
                                  align: "RIGHT"
                                ),
                                width: "AUTO"
                              )
                            }
                          ),
                          a!progressBarField(
                            percentage: 65,
                            color: "#9333EA",
                            style: "THIN",
                            showPercentage: false
                          )
                        },
                        shape: "ROUNDED",
                        padding: "MORE",
                        marginBelow: "STANDARD"
                      ),
                      /* Recent Activities */
                      a!cardLayout(
                        contents: {
                          a!richTextDisplayField(
                            value: a!richTextItem(
                              text: "Recent Activities",
                              size: "MEDIUM_PLUS",
                              style: "STRONG"
                            ),
                            marginBelow: "STANDARD",
                            labelPosition: "COLLAPSED"
                          ),
                          /* Activity Items */
                          a!sideBySideLayout(
                            items: {
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: a!richTextIcon(
                                    icon: "circle",
                                    color: "#16A34A",
                                    size: "MEDIUM"
                                  )
                                ),
                                width: "MINIMIZE"
                              ),
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: {
                                    a!richTextItem(
                                      text: "Site 007 - Johns Hopkins completed patient visit #342",
                                      size: "STANDARD"
                                    ),
                                    char(10),
                                    a!richTextItem(
                                      text: "2 hours ago",
                                      color: "SECONDARY",
                                      size: "STANDARD"
                                    )
                                  }
                                )
                              )
                            },
                            alignVertical: "MIDDLE",
                            marginBelow: "STANDARD"
                          ),
                          a!sideBySideLayout(
                            items: {
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: a!richTextIcon(
                                    icon: "circle",
                                    color: "#2563EB",
                                    size: "MEDIUM"
                                  )
                                ),
                                width: "MINIMIZE"
                              ),
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: {
                                    a!richTextItem(
                                      text: "New patient enrolled at Site 012 - Mayo Clinic",
                                      size: "STANDARD"
                                    ),
                                    char(10),
                                    a!richTextItem(
                                      text: "4 hours ago",
                                      color: "SECONDARY",
                                      size: "STANDARD"
                                    )
                                  }
                                )
                              )
                            },
                            alignVertical: "MIDDLE",
                            marginBelow: "STANDARD"
                          ),
                          a!sideBySideLayout(
                            items: {
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: a!richTextIcon(
                                    icon: "circle",
                                    color: "#EAB308",
                                    size: "MEDIUM"
                                  )
                                ),
                                width: "MINIMIZE"
                              ),
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: {
                                    a!richTextItem(
                                      text: "Adverse event reported at Site 003 - requires review",
                                      size: "STANDARD"
                                    ),
                                    char(10),
                                    a!richTextItem(
                                      text: "6 hours ago",
                                      color: "SECONDARY",
                                      size: "STANDARD"
                                    )
                                  }
                                )
                              )
                            },
                            alignVertical: "MIDDLE",
                            marginBelow: "STANDARD"
                          ),
                          a!sideBySideLayout(
                            items: {
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: a!richTextIcon(
                                    icon: "circle",
                                    color: "#16A34A",
                                    size: "MEDIUM"
                                  )
                                ),
                                width: "MINIMIZE"
                              ),
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: {
                                    a!richTextItem(
                                      text: "Monthly safety report submitted to FDA",
                                      size: "STANDARD"
                                    ),
                                    char(10),
                                    a!richTextItem(
                                      text: "1 day ago",
                                      color: "SECONDARY",
                                      size: "STANDARD"
                                    )
                                  }
                                )
                              )
                            },
                            alignVertical: "MIDDLE"
                          )
                        },
                        shape: "ROUNDED",
                        padding: "MORE",
                        marginBelow: "STANDARD"
                      ),
                      /* Site Performance */
                      a!cardLayout(
                        contents: {
                          a!richTextDisplayField(
                            value: a!richTextItem(
                              text: "Site Performance",
                              size: "MEDIUM_PLUS",
                              style: "STRONG"
                            ),
                            marginBelow: "STANDARD",
                            labelPosition: "COLLAPSED"
                          ),
                          /* Site Items */
                          a!cardLayout(
                            contents: {
                              a!sideBySideLayout(
                                items: {
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextIcon(
                                          icon: "map-marker",
                                          color: "SECONDARY",
                                          size: "MEDIUM"
                                        )
                                      }
                                    ),
                                    width: "MINIMIZE"
                                  ),
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextItem(
                                          text: "Johns Hopkins Medical Center",
                                          size: "STANDARD",
                                          style: "STRONG"
                                        ),
                                        char(10),
                                        a!richTextItem(
                                          text: "Baltimore, MD • Site 007",
                                          color: "SECONDARY",
                                          size: "STANDARD"
                                        )
                                      }
                                    ),
                                    width: "AUTO"
                                  ),
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: a!richTextItem(
                                        text: "89 patients",
                                        size: "STANDARD",
                                        style: "STRONG"
                                      )
                                    ),
                                    width: "MINIMIZE"
                                  ),
                                  a!sideBySideItem(
                                    item: a!tagField(
                                      tags: a!tagItem(
                                        text: "Excellent",
                                        backgroundColor: "POSITIVE"
                                      )
                                    ),
                                    width: "MINIMIZE"
                                  )
                                },
                                alignVertical: "MIDDLE"
                              )
                            },
                            style: "#F9FAFB",
                            shape: "ROUNDED",
                            padding: "LESS",
                            marginBelow: "LESS",
                            showBorder: false
                          ),
                          a!cardLayout(
                            contents: {
                              a!sideBySideLayout(
                                items: {
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextIcon(
                                          icon: "map-marker",
                                          color: "SECONDARY",
                                          size: "MEDIUM"
                                        )
                                      }
                                    ),
                                    width: "MINIMIZE"
                                  ),
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextItem(
                                          text: "Mayo Clinic",
                                          size: "STANDARD",
                                          style: "STRONG"
                                        ),
                                        char(10),
                                        a!richTextItem(
                                          text: "Rochester, MN • Site 012",
                                          color: "SECONDARY",
                                          size: "STANDARD"
                                        )
                                      }
                                    ),
                                    width: "AUTO"
                                  ),
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: a!richTextItem(
                                        text: "76 patients",
                                        size: "STANDARD",
                                        style: "STRONG"
                                      )
                                    ),
                                    width: "MINIMIZE"
                                  ),
                                  a!sideBySideItem(
                                    item: a!tagField(
                                      tags: a!tagItem(
                                        text: "Excellent",
                                        backgroundColor: "POSITIVE"
                                      )
                                    ),
                                    width: "MINIMIZE"
                                  )
                                },
                                alignVertical: "MIDDLE"
                              )
                            },
                            style: "#F9FAFB",
                            shape: "ROUNDED",
                            padding: "LESS",
                            marginBelow: "LESS",
                            showBorder: false
                          ),
                          a!cardLayout(
                            contents: {
                              a!sideBySideLayout(
                                items: {
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextIcon(
                                          icon: "map-marker",
                                          color: "SECONDARY",
                                          size: "MEDIUM"
                                        )
                                      }
                                    ),
                                    width: "MINIMIZE"
                                  ),
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextItem(
                                          text: "Cleveland Clinic",
                                          size: "STANDARD",
                                          style: "STRONG"
                                        ),
                                        char(10),
                                        a!richTextItem(
                                          text: "Cleveland, OH • Site 003",
                                          color: "SECONDARY",
                                          size: "STANDARD"
                                        )
                                      }
                                    ),
                                    width: "AUTO"
                                  ),
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: a!richTextItem(
                                        text: "52 patients",
                                        size: "STANDARD",
                                        style: "STRONG"
                                      )
                                    ),
                                    width: "MINIMIZE"
                                  ),
                                  a!sideBySideItem(
                                    item: a!tagField(
                                      tags: a!tagItem(
                                        text: "Needs Attention",
                                        backgroundColor: "#FEF3C7",
                                        textColor: "#92400E"
                                      )
                                    ),
                                    width: "MINIMIZE"
                                  )
                                },
                                alignVertical: "MIDDLE"
                              )
                            },
                            style: "#F9FAFB",
                            shape: "ROUNDED",
                            padding: "LESS",
                            showBorder: false
                          )
                        },
                        shape: "ROUNDED",
                        padding: "MORE"
                      )
                    },
                    width: "WIDE"
                  ),
                  a!columnLayout(
                    contents: {
                      /* Alerts & Notifications */
                      a!cardLayout(
                        contents: {
                          a!richTextDisplayField(
                            value: a!richTextItem(
                              text: "Alerts & Notifications",
                              size: "MEDIUM_PLUS",
                              style: "STRONG"
                            ),
                            marginBelow: "STANDARD",
                            labelPosition: "COLLAPSED"
                          ),
                          /* Alert Items */
                          a!cardLayout(
                            contents: {
                              a!sideBySideLayout(
                                items: {
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextIcon(
                                          icon: "exclamation-triangle",
                                          color: "#DC2626",
                                          size: "MEDIUM"
                                        )
                                      }
                                    ),
                                    width: "MINIMIZE"
                                  ),
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextItem(
                                          text: "Safety Review Required",
                                          color: "#7F1D1D",
                                          size: "SMALL",
                                          style: "STRONG"
                                        ),
                                        char(10),
                                        a!richTextItem(
                                          text: "3 adverse events pending review",
                                          color: "#991B1B",
                                          size: "SMALL"
                                        )
                                      }
                                    )
                                  )
                                },
                                alignVertical: "TOP"
                              )
                            },
                            style: "#FEF2F2",
                            padding: "LESS",
                            marginBelow: "LESS",
                            showBorder: false
                          ),
                          a!cardLayout(
                            contents: {
                              a!sideBySideLayout(
                                items: {
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextIcon(
                                          icon: "clock-o",
                                          color: "#D97706",
                                          size: "MEDIUM"
                                        )
                                      }
                                    ),
                                    width: "MINIMIZE"
                                  ),
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextItem(
                                          text: "Milestone Approaching",
                                          color: "#78350F",
                                          size: "SMALL",
                                          style: "STRONG"
                                        ),
                                        char(10),
                                        a!richTextItem(
                                          text: "50% enrollment due in 14 days",
                                          color: "#92400E",
                                          size: "SMALL"
                                        )
                                      }
                                    )
                                  )
                                },
                                alignVertical: "TOP"
                              )
                            },
                            style: "#FFFBEB",
                            padding: "LESS",
                            marginBelow: "LESS",
                            showBorder: false
                          ),
                          a!cardLayout(
                            contents: {
                              a!sideBySideLayout(
                                items: {
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextIcon(
                                          icon: "file-text-o",
                                          color: "#2563EB",
                                          size: "MEDIUM"
                                        )
                                      }
                                    ),
                                    width: "MINIMIZE"
                                  ),
                                  a!sideBySideItem(
                                    item: a!richTextDisplayField(
                                      value: {
                                        a!richTextItem(
                                          text: "Report Due",
                                          color: "#1E3A8A",
                                          size: "SMALL",
                                          style: "STRONG"
                                        ),
                                        char(10),
                                        a!richTextItem(
                                          text: "Quarterly safety report due June 30",
                                          color: "#1D4ED8",
                                          size: "SMALL"
                                        )
                                      }
                                    )
                                  )
                                },
                                alignVertical: "TOP"
                              )
                            },
                            style: "#EFF6FF",
                            padding: "LESS",
                            showBorder: false
                          )
                        },
                        shape: "ROUNDED",
                        padding: "MORE",
                        marginBelow: "STANDARD"
                      ),
                      /* Quick Stats */
                      a!cardLayout(
                        contents: {
                          a!richTextDisplayField(
                            value: a!richTextItem(
                              text: "Quick Stats",
                              size: "MEDIUM_PLUS",
                              style: "STRONG"
                            ),
                            marginBelow: "STANDARD",
                            labelPosition: "COLLAPSED"
                          ),
                          /* Stats Items */
                          a!columnsLayout(
                            columns: {
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "Active Sites",
                                    color: "#405552",
                                    size: "STANDARD"
                                  )
                                ),
                                width: "AUTO"
                              ),
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "15",
                                    size: "STANDARD",
                                    style: "STRONG"
                                  ),
                                  align: "RIGHT"
                                ),
                                width: "AUTO"
                              )
                            },
                            marginBelow: "STANDARD"
                          ),
                          a!columnsLayout(
                            columns: {
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "Screen Failures",
                                    color: "#405552",
                                    size: "STANDARD"
                                  )
                                ),
                                width: "AUTO"
                              ),
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "123 (12.7%)",
                                    size: "STANDARD",
                                    style: "STRONG"
                                  ),
                                  align: "RIGHT"
                                ),
                                width: "AUTO"
                              )
                            },
                            marginBelow: "STANDARD"
                          ),
                          a!columnsLayout(
                            columns: {
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "Withdrawals",
                                    color: "#405552",
                                    size: "STANDARD"
                                  )
                                ),
                                width: "AUTO"
                              ),
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "34 (4.0%)",
                                    size: "STANDARD",
                                    style: "STRONG"
                                  ),
                                  align: "RIGHT"
                                ),
                                width: "AUTO"
                              )
                            },
                            marginBelow: "STANDARD"
                          ),
                          a!columnsLayout(
                            columns: {
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "Protocol Violations",
                                    color: "#405552",
                                    size: "STANDARD"
                                  )
                                ),
                                width: "AUTO"
                              ),
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "8 (0.9%)",
                                    size: "STANDARD",
                                    style: "STRONG"
                                  ),
                                  align: "RIGHT"
                                ),
                                width: "AUTO"
                              )
                            },
                            marginBelow: "STANDARD"
                          ),
                          a!columnsLayout(
                            columns: {
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "Data Queries",
                                    color: "#405552",
                                    size: "STANDARD"
                                  )
                                ),
                                width: "AUTO"
                              ),
                              a!columnLayout(
                                contents: a!richTextDisplayField(
                                  value: a!richTextItem(
                                    text: "156 open",
                                    size: "STANDARD",
                                    style: "STRONG"
                                  ),
                                  align: "RIGHT"
                                ),
                                width: "AUTO"
                              )
                            }
                          )
                        },
                        shape: "ROUNDED",
                        padding: "MORE",
                        marginBelow: "STANDARD"
                      ),
                      /* Key Milestones */
                      a!cardLayout(
                        contents: {
                          a!richTextDisplayField(
                            value: a!richTextItem(
                              text: "Key Milestones",
                              size: "MEDIUM_PLUS",
                              style: "STRONG"
                            ),
                            marginBelow: "STANDARD",
                            labelPosition: "COLLAPSED"
                          ),
                          /* Milestone Items */
                          a!sideBySideLayout(
                            items: {
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: a!richTextIcon(
                                    icon: "circle",
                                    color: "#16A34A",
                                    size: "MEDIUM"
                                  )
                                ),
                                width: "MINIMIZE"
                              ),
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: {
                                    a!richTextItem(
                                      text: "First Patient In",
                                      size: "STANDARD",
                                      style: "STRONG"
                                    ),
                                    char(10),
                                    a!richTextItem(
                                      text: "Jan 15, 2024",
                                      color: "SECONDARY",
                                      size: "STANDARD"
                                    )
                                  }
                                )
                              )
                            },
                            alignVertical: "MIDDLE",
                            marginBelow: "STANDARD"
                          ),
                          a!sideBySideLayout(
                            items: {
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: a!richTextIcon(
                                    icon: "circle",
                                    color: "#16A34A",
                                    size: "MEDIUM"
                                  )
                                ),
                                width: "MINIMIZE"
                              ),
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: {
                                    a!richTextItem(
                                      text: "50% Enrollment",
                                      size: "STANDARD",
                                      style: "STRONG"
                                    ),
                                    char(10),
                                    a!richTextItem(
                                      text: "Expected Jul 3, 2025",
                                      color: "SECONDARY",
                                      size: "STANDARD"
                                    )
                                  }
                                )
                              )
                            },
                            alignVertical: "MIDDLE",
                            marginBelow: "STANDARD"
                          ),
                          a!sideBySideLayout(
                            items: {
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: a!richTextIcon(
                                    icon: "circle",
                                    color: "#D1D5DB",
                                    size: "MEDIUM"
                                  )
                                ),
                                width: "MINIMIZE"
                              ),
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: {
                                    a!richTextItem(
                                      text: "Last Patient In",
                                      size: "STANDARD",
                                      style: "STRONG"
                                    ),
                                    char(10),
                                    a!richTextItem(
                                      text: "Expected Oct 15, 2025",
                                      color: "SECONDARY",
                                      size: "STANDARD"
                                    )
                                  }
                                )
                              )
                            },
                            alignVertical: "MIDDLE",
                            marginBelow: "STANDARD"
                          ),
                          a!sideBySideLayout(
                            items: {
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: a!richTextIcon(
                                    icon: "circle",
                                    color: "#D1D5DB",
                                    size: "MEDIUM"
                                  )
                                ),
                                width: "MINIMIZE"
                              ),
                              a!sideBySideItem(
                                item: a!richTextDisplayField(
                                  value: {
                                    a!richTextItem(
                                      text: "Database Lock",
                                      size: "STANDARD",
                                      style: "STRONG"
                                    ),
                                    char(10),
                                    a!richTextItem(
                                      text: "Expected Feb 28, 2026",
                                      color: "SECONDARY",
                                      size: "STANDARD"
                                    )
                                  }
                                )
                              )
                            },
                            alignVertical: "MIDDLE"
                          )
                        },
                        shape: "ROUNDED",
                        padding: "MORE"
                      )
                    },
                    width: "MEDIUM"
                  )
                },
                spacing: "STANDARD"
              )
            },
            width: "WIDE_PLUS"
          ),
          a!columnLayout(width: "AUTO")
        }
      )
    },
    backgroundColor: "#F9FAFB"
  )
)

```