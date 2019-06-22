#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(recharts)
library(leaflet)
library(dygraphs)

#0 data prepared----

#0.01 china gdp----

totGDP <- data.table::dcast(ChinaGDP, Prov~., sum, value.var='GDP')
ChinaGDP <- ChinaGDP[order(ChinaGDP$Year),]
# ChinaGDP
#0.02 china pm2.5----

names(chinapm25) <- c('name', 'value', 'lng', 'lat')

#0.03 china flight----
route <- flight$route
names(route) <- c('name1', 'name2')
coord <- flight$coord
target <- data.frame(
  name1=c(rep('北京', 10), rep('上海', 10), rep('广州', 10)),
  name2=c(
    "上海","广州","大连","南宁","南昌","拉萨","长春","包头","重庆","常州",
    "包头","昆明","广州","郑州","长春","重庆","长沙","北京","丹东","大连",
    "福州","太原","长春","重庆","西安","成都","常州","北京","北海","海口"),
  value=c(95,90,80,70,60,50,40,30,20,10,95,90,80,70,60,50,40,30,20,10,95,90,
          80,70,60,50,40,30,20,10))
# series column mapping series of addML/addMP
target$series <- paste0(target$name1, 'Top10')

## apply addGeoCoord, and add markLines without values
g <- echartr(NULL, type='map_china') %>% addGeoCoord(coord) %>%
  addML(series=1, data=route, symbol=c('none', 'circle'), symbolSize=1, 
        smooth=TRUE, itemStyle=list(normal=itemStyle(
          color='#fff', borderWidth=1, borderColor='rgba(30,144,255,0.5)')))

## modify itemStyle of the base map to align the areaStyle with bgColor and 
## disable `hoverable`
g <- g %>% setSeries(hoverable=FALSE, itemStyle=list(
  normal=itemStyle(
    borderColor='rgba(100,149,237,1)', borderWidth=0.5, 
    areaStyle=areaStyle(color='#1b1b1b'))
))

## add markLines with values
line.effect <- list(
  show=TRUE, scaleSize=1, period=30, color='#fff', shadowBlur=10)
line.style <- list(normal=itemStyle(
  borderWidth=1, lineStyle=lineStyle(type='solid', shadowBlur=10)))
g1 <- g %>% 
  addML(series=c('北京Top10', '上海Top10', '广州Top10'), data=target, 
        smooth=TRUE, effect=line.effect, itemStyle=line.style)
## add markPoints
## series better be 2, 3, 4 rather than the series names
jsSymbolSize <- JS('function (v) {return 10+v/10;}')
mp.style <- list(normal=itemStyle(label=labelStyle(show=FALSE)), 
                 emphasis=itemStyle(label=labelStyle(position='top')))
g2 <- g1 %>%
  addMP(series=2:4, data=target[,c("name2", "value", "series")],
        effect=list(show=TRUE), symbolSize=jsSymbolSize, 
        itmeStyle=mp.style) 
## setDataRange
g3 <- g2 %>%
  setDataRange(
    color=c('#ff3333', 'orange', 'yellow','limegreen','aquamarine'),
    valueRange=c(0, 100), textStyle=list(color='#fff'),
    splitNumber=0)

## setTheme
g3 <- g3 %>% setLegend(pos=10, selected='上海Top10', textStyle=list(color='#fff')) %>%
  setTheme(palette=c('gold','aquamarine','limegreen'), bgColor='#1b1b1b') %>%
  setToolbox(pos=3) %>% 
  setTitle('china flight3', 'Fictious Data', pos=12, 
           textStyle=list(color='white'))


# china heat map----
heatmap <- sapply(1:15, function(i){
  x <- 100 + runif(1, 0, 1) * 16
  y <- 24 + runif(1, 0, 1) * 12
  lapply(0:floor(50 * abs(rnorm(1))), function(j){
    c(x+runif(1, 0, 1)*2, y+runif(1, 0, 1)*2, runif(1, 0, 1))
  })
})
heatmap <- data.frame(matrix(unlist(heatmap), byrow=TRUE, ncol=3))

#provice Revelue----
revelue <-round(runif(9)*10000000,2)
provice=c(rep("上海",3),rep("浙江",3),rep("江苏",3))
city <-c("浦东新区","奉贤区","金山区","宁波市","杭州市","台州市","宿迁市","南京市","镇江市")
chinaRevalue <-data.frame(provice,city,revelue)

#treemap data prepared----
treedata <- data.frame(
  node=c('IOS', 'Android', 'Samsung', 'Apple', 'Huawei', 'Lenovo', 'Xiaomi', 
         'Others', 'LG', 'Oppo', 'Vivo', 'ZTE', 'Other'),
  parent=c(rep(NA, 2), 'Android', 'IOS', rep('Android', 4), rep('Others', 5)),
  series=(rep('Smartphone', 13)),
  value=c(231.5, 1201.4, 324.8, 231.5, 106.6, 74, 70.8, 625.2, 51.7, 49.1,
          42.6, 40, 243))
treedata1 <- treedata[3:13,]
treedata1$series <- c('Android', 'IOS', rep('Android', 9))
treedata1$parent[1:6] <- NA

#dashboard data----
db_data = data.frame(x=rep(c('KR/min', 'Kph'), 2), y=c(6.3, 54, 7.5, 82), 
                  z=c(rep('t1', 2), rep('t2', 2)))


# bar chart data  ----
titanic <- data.table::melt(apply(Titanic, c(1,4), sum))
names(titanic) <- c('Class', 'Survived', 'Count')

# line chart data----

aq <- airquality
aq$Date <- as.Date(paste('1973', aq$Month, aq$Day, sep='-'))
aq$Day <- as.character(aq$Day)
aq$Month <- factor(aq$Month, labels=c("May", "Jun", "Jul", "Aug", "Sep"))

#dygraphs data prepared----
lungDeaths <- cbind(mdeaths, fdeaths)

#shinyserver start point----
 shinyServer(function(input, output) {
   
   #3.03.01 renderPlot----
   set.seed(122)
   histdata <- rnorm(500)
   
   output$output30301 <- renderPlot({
     data <- histdata[seq_len(input$input30301A)]
     hist(data)
   })
   output$TabBoxSelected <-renderText({
     paste0("您选择的是：",input$tabset1)
   })
   output$anyTextShow <- renderText({
     input$anyTextInput
   })
   output$progressBox3 <-renderInfoBox({
     infoBox(
       "infoBox Render", paste0(25 + 2, "%"), icon = icon("list"),
       color = "purple"
     )
   })
   output$progressBox4 <-renderInfoBox({
     infoBox(
       "infoBox Render (filled)", paste0(25 + 55, "%"), icon = icon("list"),
       color = "purple",fill=TRUE
     )
   })
   output$approvalBox4 <- renderValueBox({
     valueBox(
       "80%", "value box Render", icon = icon("thumbs-up", lib = "glyphicon"),
       color = "yellow"
     )
   })
   output$map40301 <-renderEChart({
     
     # generate bins based on input$bins from ui.R
     
     
     
     p<-echartr(ChinaGDP, Prov, GDP, Year, type="map_china") 
     p <-p  %>%  setDataRange(splitNumber=0, valueRange=range(totGDP[, 2]), 
                              color=c('red','orange','yellow','limegreen','green')) 
     p <-p %>%    setTitle("China GDP by Provice, 2012-2014")
     
     print(p)
     
     
   })
   #4.03.02 china map with timeline----
   output$map40302 <-renderEChart({
     p <- echartr(ChinaGDP, Prov, GDP, t=Year, type="map_china", subtype='average')
     p <- p %>% setDataRange(splitNumber=0,color=c('red','orange','yellow','limegreen','green')) 
     p <- p %>% setTitle("China GDP by Provice")
     print(p)
   })
   #4.03.03 china map fight----
   output$map40303 <- renderEChart({
    
     print(g1)
   })
   #4.03.04 china map flight2----
   output$map40304 <- renderEChart({
     print(g2)
   })
   #4.03.05 china map flight3----
   output$map40305 <- renderEChart({
     print(g3)
   })
   output$map40306 <- renderEChart({
     mp4 <- echartr(NULL, type="map_china") 
     mp4 <- mp4 %>% addHeatmap(data=heatmap)
     print(mp4)
   })
   output$map40501 <- renderEChart({
     revedata<-chinaRevalue[chinaRevalue$provice ==input$Input40501,c("city","revelue")]
     mp5<-NULL
     if (nrow(revedata) > 0)
     {
       mp5<-echartr(revedata,city,revelue, type='map_china', subtype=input$Input40501) 
       
     }else{
       mp5<-echartr(NULL, type='map_china', subtype=input$Input40501)
     }
      mp5 <- mp5 %>% setTitle(paste0("中国",input$Input40501,"地图"))
     print(mp5)
     
    
   })
   #4.05.02leaflet-----
   output$leftlet40502 <- renderLeaflet({
     points <- cbind(rnorm(40) * 2 + 13, rnorm(40) + 48)
     p<-leaflet() %>%
       addProviderTiles(providers$Stamen.TonerLite,
                        options = providerTileOptions(noWrap = TRUE)
       ) %>% addMarkers(data = points)
     print(p)
   })
   # #4.05.03----
   # 
   # 
   # output$dygraph <- renderDygraph({
   # 
   #   p <- dygraph(lungDeaths) 
   #   p <- p %>% dySeries("mdeaths", label = "Male") 
   #   p <- p %>% dySeries("fdeaths", label = "Female") 
   #   p <- p %>% dyOptions(stackedGraph = TRUE) 
   #   p <- p %>% dyRangeSelector(height = 20)
   #   print(p)
   # })
   # 
   output$map40601 <- renderEChart({
     mp6<- echartr(stock, as.character(date), c(open, close, low, high), type='k') 
     mp6 <- mp6 %>% setXAxis(name='日期', axisLabel=list(rotate=30)) 
     mp6 <- mp6 %>% setYAxis(name="价格")
     print(mp6)
   })
   output$map40701 <- renderEChart({
     mp7 <- echartr(treedata, c(node, parent), value, facet=series, type='treemap') 
     mp7 <- mp7 %>% setTitle('Smartphone Sales 2015 (Million)', pos=5)
     print(mp7)
   })
   output$map40702 <- renderEChart({
     mp8 <- echartr(treedata1, c(node, parent), value, facet=series, type='treemap') 
     mp8 <- mp8 %>% setTitle('Smartphone Sales 2015 (Million)', pos=5)
     print(mp8)
     
     
   })
   #4.08.01 dashboard 1----
   output$map40801 <- renderEChart({
     p9 <- echartr(db_data, x, y, type='gauge')
     print(p9)
   })
   output$map40802 <- renderEChart({
     p10 <- echartr(db_data, x, y,facet=x, type='gauge')
     print(p10)
     
   })
   output$map40803 <- renderEChart({
     p11 <- echartr(db_data, x, y,facet=x,t=z, type='gauge')
     print(p11)
   })
   output$map40901 <- renderEChart({
     p<- echartr(iris, x=Sepal.Width, y=Petal.Width)
     print(p)
     
   })
   output$map40902 <- renderEChart({
     p<- echartr(iris, x=Sepal.Width, y=Petal.Width, series=Species)
     print(p)
   })
   output$map40903 <- renderEChart({
     p<- echartr(iris, Sepal.Width, Petal.Width, weight=Petal.Length, type='bubble')
     print(p)
   })
   output$map40904 <- renderEChart({
     p <- echartr(iris, Sepal.Width, Petal.Width, weight=Petal.Length) 
     p <- p %>% setDataRange(calculable=TRUE, splitNumber=0, labels=c('Big', 'Small'),
                    color=c('red', 'yellow', 'green'), valueRange=c(0, 2.5))
     print(p)
   })
   output$map40905 <- renderEChart({
     lm <- with(iris, lm(Petal.Width~Sepal.Width))
     pred <- predict(lm, data.frame(Sepal.Width=c(2, 4.5)))
     p<- echartr(iris, Sepal.Width, Petal.Width, Species) 
     p <- p %>% addML(series=1, data=data.frame(name1='Max', type='max')) 
     p <- p %>% addML(series=2, data=data.frame(name1='Mean', type='average')) 
     p <- p %>% addML(series=3, data=data.frame(name1='Min', type='min')) 
     p <- p %>% addMP(series=2, data=data.frame(name='Max', type='max')) 
     p <- p %>% addML(series='Linear Reg', data=data.frame(
         name1='Reg', value=lm$coefficients[2], 
         xAxis1=2, yAxis1=pred[1], xAxis2=4.5, yAxis2=pred[2]))
     print(p)
   })
   output$map41001 <- render_echart({
     p <- echartr(titanic[titanic$Survived=='Yes',], Class, Count) 
     p <- p %>% setTitle('Titanic: 生存人员按乘坐等级计数')
     print(p)
   })
   output$map41002 <- renderEChart({
     p <- echartr(titanic, Class, Count, Survived) 
     p <- p %>% setTitle('Titanic:所有人员按乘坐等级计数')
     print(p)
     
   })
   output$map41003 <- renderEChart({
     p <- echartr(titanic, Class, Count, Survived, type='hbar', subtype='stack') 
     p <- p %>% setTitle('Titanic: 按乘坐等级计数堆积展示') 
     print(p)
     
   })
   output$map41004 <- renderEChart({
     titanic_tc <- titanic
     titanic_tc$Count[titanic_tc$Survived=='No'] <- 
       - titanic_tc$Count[titanic_tc$Survived=='No']
     g <- echartr(titanic_tc, Class, Count, Survived, type='hbar') 
     g <- g %>% setTitle("Titanic: 暴风图")
     g <- g %>% setYAxis(axisLine=list(onZero=TRUE)) 
     g <- g %>%  setXAxis(axisLabel=list(formatter=JS('function (value) {return Math.abs(value);}')))
     print (g)
   })
   output$map41101 <- renderEChart({
     p <- echartr(aq, Date, Temp, type='line') 
     p <- p %>% setTitle('NY Temperature May - Sep 1973') 
     p <- p %>% setSymbols('none')
     print(p)
   })
   output$map41102 <- renderEChart({
     p <- echartr(aq, Day, Temp, Month, type='line') 
     p <- p %>% setTitle('NY Temperature May - Sep 1973, by Month') 
     p <- p %>% setSymbols('emptycircle')
     print(p)
   })
   output$map41103 <- renderEChart({
    p <- echartr(aq, Date, Temp, type='wave') 
    p <- p %>% setTitle('NY Temperature May - Sep 1973') 
    p <- p %>% setSymbols('emptycircle')
    print(p)
   })
   output$map41104 <- renderEChart({
     p <- echartr(aq, Day, Temp, Month, type='wave', subtype='stack') %>%
       setTitle('NY Temperature May - Sep 1973, by Month') %>% 
       setSymbols('emptycircle')
     print(p)
     
   })
   output$datatable40401<-renderDataTable({
     mtcars[  ,input$input40401,drop=FALSE]
   },options = list(orderClasses = TRUE,
                    lengthMenu = c(5, 15,30,50,75,100), 
                    pageLength = 5))
  #option 是可以使用的参数 
   #orderClasses确认了选中进行高亮； 
   #lengthMenu定义了下拉框的选项
   #pageLength=定义了默认的页面大小
   
   output$output30101B <- renderText({
     if (input$check30101B)
       toupper(input$Input30101B)
     else
       input$Input30101B
   })
})
