#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(recharts);
library(leaflet);
library(dygraphs)

# 0.01 add the 1st msg notification Menu----
headerMsg1<-  dropdownMenu(type = "messages",
                           messageItem(
                             from = "Sales Dept",
                             message = "Sales are steady this month."
                           ),
                           messageItem(
                             from = "New User",
                             message = "How do I register?",
                             icon = icon("question"),
                             time = "13:45"
                           ),
                           messageItem(
                             from = "Support",
                             message = "The new server is ready.",
                             icon = icon("life-ring"),
                             time = "2014-12-01"
                           )
);

# 0.02 add the dynamic menu ----

dynamicMsgMenu <-dropdownMenuOutput("messageMenu")

# 0.03 Notification Menu ----

NotiMenuObj <-dropdownMenu(type = "notifications",
                           notificationItem(
                             text = "5 new users today",
                             icon("users")
                           ),
                           notificationItem(
                             text = "12 items delivered",
                             icon("truck"),
                             status = "success"
                           ),
                           notificationItem(
                             text = "Server load at 86%",
                             icon = icon("exclamation-triangle"),
                             status = "warning"
                           ),
                           notificationItem(
                             text = "primary",
                             icon = icon("truck"),
                             status = "primary"),
                           notificationItem(
                             text = "here is your information to be noticed!",
                             icon = icon("truck"),
                             status = "info"),
                           notificationItem(
                             text = "look out ! be carefull!",
                             icon = icon("truck"),
                             status = "danger")
                           
)
# 0.04 task menu bar ----
taskMenuObj <- dropdownMenu(type = "tasks", badgeStatus = "success",
                            taskItem(value = 90, color = "green",
                                     "Documentation"
                            ),
                            taskItem(value = 70, color = "aqua",
                                     "Project X"
                            ),
                            taskItem(value = 75, color = "yellow",
                                     "Server deployment"
                            ),
                            taskItem(value = 80, color = "red",
                                     "Overall project"
                            )
)
#0.11. data prepared----

#01.11.01 china provice----
chinaProvice <- c("新疆", "西藏", "内蒙古", "青海", "四川", "黑龙江", "甘肃", "云南", "广西", "湖南", "陕西", "广东", "吉林", "河北", "湖北", "贵州", "山东", "江西", "河南", "辽宁", "山西", "安徽", "福建", "浙江", "江苏", "重庆", "宁夏", "海南", "台湾", "北京", "天津", "上海", "香港", "澳门")
#chinaProvice;


# 1.00  shinyUI start point----

shinyUI(dashboardPage(skin = "blue",
                    
                
                    
                    dashboardHeader(title = "棱星数据分析平台",
                                                                       taskMenuObj,
                                    headerMsg1,
                                    dynamicMsgMenu,
                                    NotiMenuObj,
                                    disable = F
                    ),
                    
                    #ui.sideBar----
                    dashboardSidebar(
                    
                      sidebarMenu(
                     
                      # 1.01 layout----
                        # menuItem("layout", tabName = "layout", icon = icon("dashboard"),
                        #          sidebarMenu(
                        #            menuItem("tabBox",tabName = "tabBox"),
                        #            menuItem("navBox",tabName = "navBox")
                        #          )),
                        # 
                        # 
                      #1.02 components ---- 
                      # menuItem("components", tabName = "components", icon = icon("th")),
                      # #1.03 outPut----
                        menuItem(text = "分析展示",tabName = "outPut",icon=icon("truck")),
                      #1.04 rdMasterData----
                        
                      #   menuItem(text = "基础资料",tabName = "rdMasterData",icon=icon("cubes"),
                      #            sidebarMenu(
                      #              #1.04.01 mdDateTime----
                      #              menuItem(text="日期维度",tabName = "mdDateTime",icon = icon("cubes")),
                      #              #1.04.02 mdMapInfo----
                      #              menuItem(text="地理纬度",tabName = "mdMapInfo",icon = icon("cubes"))
                      #              )),
                      # #1.05 system setting ----
                        menuItem(text = "系统设置",tabName = "rdSysSetting",icon=icon("cog"),
                                 sidebarMenu(
                                   #1.05.01 settingParam----
                                   menuItem(text="系统参数",tabName = "settingParam",icon = icon("cog")),
                                   #1.05.02 settingUser----
                                   menuItem(text="用户设置",tabName = "settingUser",icon = icon("cog"))
                                   ))
                        
                        
                      )
                    ),
                    
                    #ui.body----
                    dashboardBody(
                      tabItems(
                        # 3.01 layout----
                        # tabItem(tabName = "navBox",
                        #         fluidRow(
                        #           box(title = "Histogram",width = 4, status = "primary",textInput(inputId="layout11","layout11")),
                        #           box(title = "Histogram",width = 4, status = "primary",textInput(inputId="layout12","layout12")),
                        #           box(title = "Histogram",width = 4, status = "primary",textInput(inputId="layout13","layout13"))
                        #                                           ),
                        #         fluidRow(
                        #           tabBox(
                        #                 title = "1tabBox",width = 12,
                        #                 # The id lets us use input$tabset1 on the server to find the current tab
                        #                 id = "tabset1", height = "250px",
                        #                 tabPanel("Tab1", "First tab content"),
                        #                 tabPanel("Tab2", "Tab content 2"),
                        #                 tabPanel("Tab3", "Tab content 3"),
                        #                 tabPanel("Tab4", "Tab content 4"),
                        #                 tabPanel("Tab5", "Tab content 5")
                        #               )
                        #         ),
                        #         fluidRow(
                        #           box(title = "tabBox选择结果显示",width = 4, status = "primary",
                        #               verbatimTextOutput("TabBoxSelected")),
                        #           box(title = "Histogram",width = 4, status = "primary",textInput(inputId="layout32","layout22")),
                        #           box(title = "Histogram", width=4,status = "primary",textInput(inputId="layout33","layout23"))
                        #         )
                        #         
                        #         
                        #         
                        # ),
                        # tabItem(tabName = "tabBox",
                        #         tabsetPanel(
                        #           
                        #           tabPanel("Tab1", 
                        #                    fluidRow(
                        #                      box(title = "tab1_11",width = 4, status = "primary",textInput(inputId="tab1_11","tab1layout11")),
                        #                      box(title = "tab1_12",width = 4, status = "primary",textInput(inputId="tab1_12","tab1layout12")),
                        #                      box(title = "tab1_13",width = 4, status = "primary",textInput(inputId="tab1_13","tab1layout13"))
                        #                    ),
                        #                    fluidRow(
                        #                      box(title = "tab1_21",width = 4, status = "primary",textInput(inputId="tab1_21","tab1layout21")),
                        #                      box(title = "tab1_22",width = 4, status = "primary",textInput(inputId="tab1_22","tab1layout22")),
                        #                      box(title = "tab1_23",width = 4, status = "primary",textInput(inputId="tab1_23","tab1layout23"))
                        #                    )
                        #                    ),
                        #           tabPanel("Tab2", "Tab content 2"),
                        #           tabPanel("Tab3", "Tab content 3"),
                        #           tabPanel("Tab4", "Tab content 4"),
                        #           tabPanel("Tab5", "Tab content 5"),
                        #           tabPanel("Tab6", "Tab content 6"),
                        #           tabPanel("Tab7", "Tab content 7"),
                        #           tabPanel("Tab8", "Tab content 8")
                        #         )),
                        # 
                        #3.02 body for the components ----
                        tabItem(tabName = "components",
                                
                                tabsetPanel(
                                  
                                  tabPanel("常用输入组件", 
                                      fluidRow(
                                    #3.02.01 sliderInput----
                                    box(title = "sliderInputComponent",width = 4, status = "primary",
                                        # tags$h4("func:sliderInput"),
                                        # br(),
                                        
                                        sliderInput("sliderInputComponent","Number of Observations",1,100,30)),
                                    #3.02.02 textInput----
                                    box(title = "textInputComponent",width = 4, status = "primary",
                                        textInput(inputId="text30202","请输入文本：")),
                                    #3.02.03 numericInput----
                                    box(title = "numericInputComponent",width = 4, status = "primary",
                                        numericInput(inputId = "numeric30203",label = "请输入数字:",value=12,
                                                     min=3,max=80,step=0.1))
                                  ),
                                  #3.02.04checkboxInput----
                                  fluidRow(
                                    box(title = "checkboxInputComponent",width = 4, status = "primary",
                                        checkboxInput("checkboxInput30204","请选择该项",value=TRUE)),
                                    #3.02.05 checkboxGroupInput----
                                    box(title = "cheboxGroupInputA",width = 4, status = "primary",
                                        checkboxGroupInput("checkbox30205A", "Variables to show:",
                                                           c("Cylinders" = "cyl",
                                                             "Transmission" = "am",
                                                             "Gears" = "gear"))),
                                    #3.02.06 checkboxGroupInput_with icon----
                                    box(title = "checkboxGroupInputB", width=4,status = "primary",
                                        checkboxGroupInput("checkboxGroupInputB", "Choose icons:",
                                                           choiceNames =
                                                             list(icon("calendar"), icon("bed"),
                                                                  icon("cog"), icon("bug")),
                                                           choiceValues =
                                                             list("calendar", "bed", "cog", "bug")
                                        ))
                                  ),
                                  #3.02.07 dateInput----
                                  fluidRow(
                                    box(title = "dateInput",width = 4, status = "primary",
                                        dateInput("dateInput30207","请选择日期",value=Sys.Date(),weekstart = 1,language = "zh-CN")),
                                    #3.02.08 dateRangeInput ----
                                    box(title = "dateRangeInput",width = 4, status = "primary",
                                        dateRangeInput("dateRangeInput30208", "起止日期录入:",
                                                       start = Sys.Date(),
                                                       end = Sys.Date()+10,
                                                       separator = "-",
                                                       weekstart = 1,
                                                       language="zh-CN")),
                                    #3.02.09 selectInput----
                                    box(title = "selectInput", width=4,status = "primary",
                                        selectInput("selectInput30209", "请从下面列表选择:",
                                                    c("Cylinders" = "cyl",
                                                      "Transmission" = "am",
                                                      "Gears" = "gear")))
                                  )    
                                      
                                  ),
                                  tabPanel("输入组件2", 
                                           fluidRow(
                                  #3.02.10 selectInput2 by group----
                                             box(title = "selectInput2",width = 4, status = "primary",
                                                 selectInput("selectInput30210", "选择一个省份:",
                                                             list(`华东` = c("上海"="shanghai", "浙江"="zhengjia", "南京"="nanjing"),
                                                                  `华南` = c("福建"="fujian", "广东"="guangdong", "广西"="guangxi"),
                                                                  `华北` = c("北京"="beijing", "天津"="tianjing", "河北"="hebei"))
                                                 )),
                                  #3.02.11 ratioButtions----
                                             box(title = "ratioButtons",width = 4, status = "primary",
                                                 radioButtons("ratioButtions30211", "请选择分布类型:",
                                                              c("正态分布" = "norm",
                                                                "联合分布" = "unif",
                                                                "对数分布" = "lnorm",
                                                                "指数分布" = "exp"))),
                                  #3.02.12 passwordInput----
                                             box(title = "passwordInput",width = 4, status = "primary",
                                                 passwordInput("passwordinput30212","请办入密码："))
                                           ),
                               
                                           fluidRow(
                                             #3.02.13 fileInput----
                                             box(title = "fileInput",width = 4, status = "primary",
                                                 fileInput(inputId="fileInput30213",label = "请选择文件",
                                                           multiple=TRUE,
                                                           accept=c(".doc",".pdf",".rar",".png",".jpeg"),
                                                           buttonLabel="浏览",
                                                           placeholder="没有选择文件")),
                                             #3.02.14 actionButtion----
                                             box(title = "actionButtion",width = 4, status = "primary",
                                                 actionButton("actionButtion30214","更新",icon = icon("truck"))),
                                             #3.02.15 actionlink----
                                             box(title = "actionLink",width = 4, status = "primary",
                                                 actionLink("input30215","input30215",icon("truck")))
                                           ),
                                           fluidRow(
                                             #3.02.16 summitButtion----
                                             #它将阻止所有程序的实时交互，
                                             #建议使用actionButtion替代
                                             box(title = "submitButtion-depreicated",width = 4, status = "primary",
                                                #submitButton("提交数据",icon = icon("cubes"))
                                                actionButton("update","提交数据",icon = icon("cubes"))
                                                
                                                ),
                                             box(title = "dateInput",width = 4, status = "primary",
                                                 textInput("input30217","input30217")),
                                             box(title = "dateInput",width = 4, status = "primary",
                                                 textInput("input30218","input30218"))
                                           )),
                                  tabPanel("文本类", 
                                           fluidRow(
                                        #3.03.01 text:textInput----
                                        box(title = "textInputComponent",width = 4, status = "primary",
                                            textInput(inputId="text30301","请输入文本：")),
                                        #3.03.02 text:passwordInput----
                                        box(title = "passwordInput",width = 4, status = "primary",
                                            passwordInput("passwordinput30301","请输入密码：")),
                                             box(width = 4, status = "primary")
                                           ),
                                           fluidRow(
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary")
                                           ),
                                           fluidRow(
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary")
                                           )),
                                  tabPanel("数值类", 
                                           #3.04 数值类----
                                           fluidRow(
                                             #3.04.01 number:numericInput----
                                             box(title = "numericInputComponent",width = 4, status = "primary",
                                                 numericInput(inputId = "numeric30401",label = "请输入数字:",value=12,
                                                              min=3,max=80,step=0.1)),
                                             #3.04.02 number:sliderInput----
                                             box(title = "sliderInputComponent",width = 4, status = "primary",
                                                 # tags$h4("func:sliderInput"),
                                                 # br(),
                                                 
                                                 sliderInput("sliderInput30402","Number of Observations",1,100,30)),
                                             box(width = 4, status = "primary")
                                           ),
                                           fluidRow(
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary")
                                           ),
                                           fluidRow(
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary")
                                           )),
                                  tabPanel("日期类", 
                                           #3.05 日期类----
                                           fluidRow(
                                             #3.05.01 date:dateInput----
                                             box(title = "dateInput",width = 4, status = "primary",
                                                 dateInput("dateInput30501","请选择日期",value=Sys.Date(),weekstart = 1,language = "zh-CN")),
                                             #3.05.02 date:dateRangeInput----
                                             box(title = "dateRangeInput",width = 4, status = "primary",
                                                 dateRangeInput("dateRangeInput30502", "起止日期录入:",
                                                                start = Sys.Date(),
                                                                end = Sys.Date()+10,
                                                                separator = "-",
                                                                weekstart = 1,
                                                                language="zh-CN")),
                                             box(width = 4, status = "primary")
                                           ),
                                           fluidRow(
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary")
                                           ),
                                           fluidRow(
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary")
                                           )),
                                  tabPanel("选择类", 
                                           #3.06 选择类----
                                           fluidRow(
                                          #3.06.01 select:checkboxInput Y/N----
                                          # check one option or not
                                             box(title = "checkboxInput",width = 4, status = "primary",
                                                 checkboxInput("checkboxInput30601","请选择该项",value=TRUE)),
                                          #3.06.02 select:ratioButtions  ----
                                          #choose one from multiple options
                                          box(title = "ratioButtons",width = 4, status = "primary",
                                              radioButtons("ratioButtions30602", "请选择分布类型:",
                                                           c("正态分布" = "norm",
                                                             "联合分布" = "unif",
                                                             "对数分布" = "lnorm",
                                                             "指数分布" = "exp"))),
                                          #3.06.03 select:selectInput----
                                          #不进行选项分组提示
                                          box(title = "selectInput", width=4,status = "primary",
                                              selectInput("selectInput30603", "请从下面列表选择:",
                                                          c("Cylinders" = "cyl",
                                                            "Transmission" = "am",
                                                            "Gears" = "gear")))
                                           ), 
                                          fluidRow(
                                            #3.06.04 select:selectInput2----
                                            #进行选项的分组
                                            box(title = "selectInput2",width = 4, status = "primary",
                                                selectInput("selectInput30210", "选择一个省份:",
                                                            list(`华东` = c("上海"="shanghai", "浙江"="zhengjia", "南京"="nanjing"),
                                                                 `华南` = c("福建"="fujian", "广东"="guangdong", "广西"="guangxi"),
                                                                 `华北` = c("北京"="beijing", "天津"="tianjing", "河北"="hebei"))
                                                )),
                                            #3.06.05 select:checkboxGroupInput----
                                            #文件样式
                                            box(title = "cheboxGroupInputA",width = 4, status = "primary",
                                                checkboxGroupInput("checkbox30605", "可选变量:",
                                                                   c("Cylinders" = "cyl",
                                                                     "Transmission" = "am",
                                                                     "Gears" = "gear"))),
                                            #3.06.06 select:checkboxGroupInput2----
                                            box(title = "checkboxGroupInputB", width=4,status = "primary",
                                                checkboxGroupInput("checkboxGroupInput30606", "从下面图标中做出选择:",
                                                                   choiceNames =
                                                                     list(icon("calendar"), icon("bed"),
                                                                          icon("cog"), icon("bug")),
                                                                   choiceValues =
                                                                     list("calendar", "bed", "cog", "bug")
                                                ))
                                           ),
                                           fluidRow(
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary")
                                           )),
                                  tabPanel("按纽类", 
                                           #3.08 按纽类----
                                           fluidRow(
                                             #3.08.01 buttion:actionbuttion----
                                             box(title = "actionButtion",width = 4, status = "primary",
                                                 actionButton("actionButtion30801","更新",icon = icon("truck"))),
                                             #3.08.02 buttion:actionLink----
                                             box(title = "actionLink",width = 4, status = "primary",
                                                 actionLink("input30802","input30802",icon("truck"))),
                                             #3.08.03 buttion:submitButtion-depreciated----
                                             box(title = "submitButtion-depreicated",width = 4, status = "primary",
                                                 #submitButton("提交数据",icon = icon("cubes"))
                                                 actionButton("update30803","提交数据",icon = icon("cubes"))
                                                 
                                             )
                                           ),
                                           fluidRow(
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary")
                                           ),
                                           fluidRow(
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary"),
                                             box(width = 4, status = "primary")
                                           )),
                                  tabPanel("文件系统",  
                                           #3.09文件系统类----
                                           fluidRow(
                                             #3.09.01 file:fileInput----
                                             box(title = "fileInput",width = 4, status = "primary",
                                                 fileInput(inputId="fileInput30901",label = "请选择文件",
                                                           multiple=TRUE,
                                                           accept=c(".doc",".pdf",".rar",".png",".jpeg"),
                                                           buttonLabel="浏览",
                                                           placeholder="没有选择文件")),
                                    box(title="图片应用",width = 4, status = "primary",
                                        img(src="https://s3.51cto.com/wyfs02/M00/54/25/wKiom1R5dmmiMyEKAAAfvBXIwzE750_middle.jpg")),
                                    box(width = 4, status = "primary")
                                  ), 
                                  fluidRow(
                                    box(width = 4, status = "primary"),
                                    box(width = 4, status = "primary"),
                                    box(width = 4, status = "primary")
                                  ),
                                  fluidRow(
                                    box(width = 4, status = "primary"),
                                    box(width = 4, status = "primary"),
                                    box(width = 4, status = "primary")
                                  ))
                                )
                                
                                
                                
                        ),
                        #4 outPut----
                        tabItem(tabName = "outPut",
                                tabsetPanel(
                        #4.01----
                                  
                        #4.03 map----
                                  tabPanel("中国地图",
                                           fluidRow(
                                            #4.03.01 map:china map----
                                             box(title="china map",width = 6,status = "primary",
                                                 eChartOutput("map40301",height="400px")),
                                          
                                            #4.03.03 map:china map:timeline----
                                             box(tilte="china map 2 ",width = 6,status = "primary",
                                                 eChartOutput("map40302",height = "450px"))
                                           ),
                                           fluidRow(
                                             #4.03.03
                                             box(title = "china flight1",width = 6,status = "primary",
                                                 eChartOutput("map40303")),
                                             #4.03.04 china flight 2----
                                             box(title = "china flight2",width = 6,status = "primary",
                                                 eChartOutput("map40304"))
                                           ),
                                           fluidRow(
                                             #4.03.05 china flight3----
                                             box(title = "china flight3",width = 6,status = "primary",
                                                 eChartOutput("map40305")),
                                             #4.03.06 china heat map----
                                             box(title = "china flight3",width = 6,status = "primary",
                                                 eChartOutput("map40306"))
                                            
                                           )),
                        tabPanel("中国省份地图",
                                 #4.05.01 china province----
                                 
                                 fluidRow(
                                   box(title = "条件过滤", width=4,status = "primary",
                                       selectInput("Input40501", "请选择一个省份:",
                                                   chinaProvice,selected = "上海")),
                                   box(title = "中国省份地图",width = 8,status = "primary",
                                       eChartOutput("map40501"))),
                                 #4.05.02left map ----
                                 fluidRow(
                                   box(title = "leaflet Map",width = 8,status = "primary",
                                       leafletOutput("leftlet40502")),
                                   box()
                                 )
                                 # ,
                                 # #4.05.03  dygraphs-----
                                 # fluidRow(
                                 #   box(numericInput("months", label = "Months to Predict", 
                                 #                    value = 72, min = 12, max = 144, step = 12),
                                   #     selectInput("interval", label = "Prediction Interval",
                                   #                 choices = c("0.80", "0.90", "0.95", "0.99"),
                                   #                 selected = "0.95"),
                                   #     checkboxInput("showgrid", label = "Show Grid", value = TRUE)),
                                   # box(
                                   #   dygraphOutput("dygraph")
                                   # ))
                              
                                 ),
                        #4.04 datatable Render----
                                  tabPanel("数据表格",
                                           
                                           fluidRow(
                        #4.04.01 mtcars datatable
                                             box(title = "条件过滤",width = 6, status ="primary",
                                                 checkboxGroupInput("input40401","请选择mtcar中要显示的列",
                                                                    names(mtcars),selected=names(mtcars))),
                                             box(title = "mtcars datatable",width = 6,status = "primary",
                                                 dataTableOutput('datatable40401'))
                                             
                                                                                       )),
                                  
                                  tabPanel("K线图",
                                           fluidRow(
                                             #4.06.01 显示数据----
                                             box(title = "按日期显示股票数据",width = 6,status = "primary",
                                                 eChartOutput("map40601")),
                                             box()
                                           )
                                           ),
                                  tabPanel("树形图",
                                           #4.07.01 smart phone analysis 1----
                                           fluidRow(
                                             box(title = "智能手机市场分析1",width = 6,status = "primary",
                                                 eChartOutput("map40701")),
                                             #4.07.02 smart phone analysis2----
                                             box(title = "智能手机市场分析2",width = 6,status = "primary",
                                                 eChartOutput("map40702"))
                                           )),
                                  tabPanel("仪表盘",
                                        #4.08.01----
                                           
                                           fluidRow(
                                             box(title = "单一指标1",width = 6,status = "primary",
                                                 eChartOutput("map40801")),
                                      #4.08.02----
                                             box(title = "单一指标_系列",width = 6,status = "primary",
                                                 eChartOutput("map40802"))
                                             
                                           ),
                                           fluidRow(
                                      #4.08.03----
                                             box(title = "多重指标_时间线",width = 12,status = "primary",
                                                 eChartOutput("map40803"))
                                           )
                                           ),
                        tabPanel("散点图",
                                 
                                 fluidRow(
                                #4.09.01----
                                   box(title = "2变量散点图",width = 6,status = "primary",
                                       eChartOutput("map40901")),
                                #4.09.02 2变量散点图外加系列数据----
                                box(title = "2变量散点图_系列",width = 6,status = "primary",
                                    eChartOutput("map40902"))
                                 ),
                                 fluidRow(
                                #4.09.03 3变量散点图
                                   box(title = "3变量散点/气泡图",width = 6,status = "primary",
                                       eChartOutput("map40903")),
                                   #4.09.04 3变量数据----
                                   box(title = "3变量散点_数据值域",width = 6,status = "primary",
                                       eChartOutput("map40904"))
                                 ),
                                 fluidRow(
                                   #4.09.05 增加辅助线，点----
                                   box(title = "3变量散点_辅助线点",width = 6,status = "primary",
                                       eChartOutput("map40905")),
                                   box(),
                                   box()
                                 )),
                        tabPanel("柱状图",
                                 
                                 fluidRow(
                                   #4.10.01 single bar chart ----
                                   box(title = "柱状图1",width = 6,status = "primary",
                                       eChartOutput("map41001")),
                                   #4.10.02 柱状图，分系列----
                                   box(title = "柱状图2",width = 6,status = "primary",
                                       eChartOutput("map41002"))
                                 ),
                                 fluidRow(
                                   #4.10.03 柱状图，分系列，堆积图 ----
                                   box(title = "柱状图分系列堆积图",width = 6,status = "primary",
                                       eChartOutput("map41003")),
                                   #4.10.04----
                                   box(title = "柱状图4",width = 6,status = "primary",
                                       eChartOutput("map41004"))
                                 ),
                                 fluidRow(
                                   box(),
                                   box(),
                                   box()
                                 )),
                        tabPanel("拆线面积图",
                                #4.11.01 拆线图 
                                 fluidRow(
                                   box(title = "拆线图1",width = 6,status = "primary",
                                       eChartOutput("map41101")),
                                   box(title = "拆线图2",width = 6,status = "primary",
                                       eChartOutput("map41102"))
                                 ),
                                 fluidRow(
                                   box(title = "拆线图3",width = 6,status = "primary",
                                       eChartOutput("map41103")),
                                   box(title = "拆线图4",width = 6,status = "primary",
                                       eChartOutput("map41104"))
                                 ),
                                 fluidRow(
                                   box(),
                                   box(),
                                   box()
                                 )),
                        tabPanel("一般图表",
                                 
                                 fluidRow(
                                   #3.03.01 plotOutput----
                                   box(title = "plotOutput > renderPlot",width = 4, status = "primary",
                                       sliderInput("input30301A","Number of Observations",1,100,30),
                                       plotOutput("output30301",height = 250)),
                                   box(title = "verbatimTextOutput >renderText",width = 4, status = "primary",
                                       textInput(inputId="Input30101B","请输入文本："),
                                       checkboxInput("check30101B","统一为大写字母",value = FALSE),
                                       bookmarkButton("保存为标签"),
                                       tags$h4("显示输入文本："),
                                       br(),
                                       verbatimTextOutput("output30101B"))
                                   
                                 )
                        ),
                        #4.02----
                        tabPanel("信息面板",
                                 
                                 fluidRow(
                                   infoBoxOutput("progressBox3"),
                                   infoBoxOutput("progressBox4"),
                                   box(title = "Histogram", width=4,status = "primary",textInput(inputId="layout23","layout23"))
                                 ),
                                 fluidRow(
                                   valueBox(10 * 2, "valueBox (static)", icon = icon("credit-card")),
                                   valueBoxOutput("approvalBox4"),
                                   infoBox("infoBox static Demo", 10 * 2, icon = icon("credit-card")))
                        )  
                        
                                )
                                
                                
                                    
                        ),
                        #3.04 masterData----
                        tabItem(tabName = "mdDateTime",
                                fluidRow(
                                  # A static infoBox
                                  infoBox("New Orders", 10 * 2, icon = icon("credit-card")),
                                  # Dynamic infoBoxes
                                  infoBoxOutput("progressBox"),
                                  infoBoxOutput("approvalBox")
                                ),
                                # infoBoxes with fill=TRUE
                                fluidRow(
                                  infoBox("来源于陈美容的订单", 10 * 2, icon = icon("credit-card"), fill = TRUE),
                                  infoBoxOutput("progressBox2"),
                                  infoBoxOutput("approvalBox2")
                                ),
                                fluidRow(
                                  # Clicking this will increment the progress amount
                                  box(width = 4, actionButton("count", "Increment progress"))
                                )
                        ),
                        #3.05setting----
                        #3.05.01 settingParam----
                        tabItem(tabName = "settingParam",
                                fluidRow(
                                  # A static valueBox
                                  valueBox(10 * 2, "New Orders value", icon = icon("credit-card")),
                                  
                                  # Dynamic valueBoxes
                                  valueBoxOutput("vprogressBox"),
                                  
                                  valueBoxOutput("vapprovalBox")
                                ),
                                fluidRow(
                                  # Clicking this will increment the progress amount
                                  box(width = 4, actionButton("vcount", "Increment progress value"))
                                )
                        ),
                        #3.05.02 settingUser----
                        tabItem(tabName = "settingUser",
                                fluidRow(
                                  column(width = 4,
                                         box(
                                           title = "Box title", width = NULL, status = "primary",
                                           "Box content"
                                         ),
                                         box(
                                           title = "Title 1", width = NULL, solidHeader = TRUE, status = "primary",
                                           "Box content"
                                         ),
                                         box(
                                           width = NULL, background = "black",
                                           "A box with a solid black background"
                                         )
                                  ),
                                  
                                  column(width = 4,
                                         box(
                                           status = "warning", width = NULL,
                                           "Box content"
                                         ),
                                         box(
                                           title = "Title 3", width = NULL, solidHeader = TRUE, status = "warning",
                                           "Box content"
                                         ),
                                         box(
                                           title = "Title 5", width = NULL, background = "light-blue",
                                           "A box with a solid light-blue background"
                                         )
                                  ),
                                  
                                  column(width=4,
                                         box(
                                           title = "Title 2", width = NULL, solidHeader = TRUE,
                                           "Box content"
                                         ),
                                         box(
                                           title = "Title 6", width = NULL, background = "maroon",
                                           "A box with a solid maroon background"
                                         )
                                  )
                                )
                        )
                        
                     
                      )
                    )
)
)


