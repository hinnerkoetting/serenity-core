<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Home</title>
    <link rel="shortcut icon" href="favicon.ico">
    <link rel="stylesheet" href="font-awesome/css/font-awesome.min.css">
    <!--[if IE 7]>
    <link rel="stylesheet" href="font-awesome/css/font-awesome-ie7.min.css">
    <![endif]-->
    <link rel="stylesheet" href="css/core.css"/>
    <link rel="stylesheet" href="css/link.css"/>
    <link type="text/css" media="screen" href="css/screen.css" rel="Stylesheet"/>

    <!--[if IE]>
    <script language="javascript" type="text/javascript" src="jit/Extras/excanvas.js"></script>
    <![endif]-->

    <!-- JQuery -->
    <script type="text/javascript" src="scripts/jquery-1.11.1.min.js"></script>

    <!-- Bootstrap -->
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <script src="bootstrap/js/bootstrap.min.js"></script>

    <!-- jQplot -->
    <link rel="stylesheet" type="text/css" href="jqplot/1.0.8/jquery.jqplot.min.css"/>
    <script type="text/javascript" src="jqplot/1.0.8/jquery.jqplot.min.js"></script>
    <script type="text/javascript" src="jqplot/1.0.8/plugins/jqplot.categoryAxisRenderer.min.js"></script>
    <script type="text/javascript" src="jqplot/1.0.8/plugins/jqplot.dragable.min.js"></script>
    <script type="text/javascript" src="jqplot/1.0.8/plugins/jqplot.highlighter.min.js"></script>
    <script type="text/javascript" src="jqplot/1.0.8/plugins/jqplot.dateAxisRenderer.min.js"></script>
   	<script type="text/javascript" src="jqplot/1.0.8/plugins/jqplot.cursor.min.js"></script>

    <!-- JQuery-UI -->
    <link type="text/css" href="jqueryui/1.11.2-start/jquery-ui.min.css" rel="Stylesheet" />
    <script type="text/javascript" src="jqueryui/1.11.2-start/jquery-ui.min.js"></script>

    <script class="code" type="text/javascript">$(document).ready(function () {

        var specified = [];
        var done = [];
        var skipped = [];
        var failing = [];
        var min_date;

        <#assign row = 0>
        <#assign max_specified = 0>
        <#foreach snapshot in history>
        var date = new Date(${snapshot.time.toString('yyyy')}, ${snapshot.time.toString('M')?number - 1}, ${snapshot.time.toString('d')},${snapshot.time.toString('H')}, ${snapshot.time.toString('m')}, ${snapshot.time.toString('s')});

        specified.push([date, ${snapshot.specifiedSteps}]);
        done.push([date,${snapshot.passingSteps}]);
        skipped.push([date,${snapshot.skippedSteps}]);
        failing.push([date,${snapshot.failingSteps}]);

        <#if row == 0 >
            min_date = date;
        </#if>

        <#if snapshot.specifiedSteps &gt; max_specified >
            <#assign max_specified = snapshot.specifiedSteps>
        </#if>

        <#assign row = row + 1>
        </#foreach>

        targetPlot = $.jqplot('chart_div', [failing,skipped,done,specified], {

            axesDefaults : {
                labelRenderer : $.jqplot.CanvasAxisLabelRenderer
            },

            axes : {

                xaxis : {
                    renderer : $.jqplot.DateAxisRenderer,
                    tickOptions: {formatString:'%b %#d'},
                    min : min_date,
                    tickInterval: '1 week'
                },

                yaxis : {
                    min: 0,
                    max: ${max_specified},
                    tickInterval: ${max_specified} / 5,
                    tickOptions: {formatString: '%d' }
                }

            },

            legend: {
                show:true,
                location: 'nw'
            },

			cursor:{
					show: true,
					zoom:true,
					showTooltip:true
    		},

            series: [
                {color:'#ff0000', label:'Failing'},
   				{color:'#ff9131', label:'Skipped'},
                {color:'#00ff00', label:'Done'},
                {color:'#0000ff', label:'Specified'}

            ]


        });

        controllerPlot = $.jqplot('controller_div', [failing,skipped,done,specified], {

            seriesDefaults:{ showMarker: false },

            series: [
                {color:'#ff0000', label:'Failing'},
				{color:'#ff9131', label:'Skipped'},
				{color:'#00ff00', label:'Done'},
				{color:'#0000ff', label:'Specified'}
            ],

            cursor:{
                show: true,
                showTooltip: false,
                zoom:true,
                constrainZoomTo: 'x'
            },

            axesDefaults: {
                useSeriesColor:true,
                rendererOptions: {
                    alignTicks: true
                }
            },

            axes : {

                xaxis : {
                    renderer : $.jqplot.DateAxisRenderer,
                    tickOptions: {formatString:'%b %#d'},
                    min : min_date,
                    tickInterval: '1 week'
                },

                yaxis : {
				show:false,
                    min: 0,
                    max: ${max_specified},
                    tickInterval: ${max_specified} / 5,
                    tickOptions: {formatString: '%d' }
                }
            } //axes
        }); //conroller plot

        $.jqplot.Cursor.zoomProxy(targetPlot, controllerPlot);

        $.jqplot._noToImageButton = true;

    });
    </script>

</head>

<body>
<div id="topheader">
    <div id="topbanner">
        <div id="logo"><a href="index.html"><img src="images/serenity-bdd-logo.png" border="0"/></a></div>
        <div id="projectname-banner" style="float:right">
            <span class="projectname">${reportOptions.projectName}</span>
        </div>
    </div>
</div>

<div class="middlecontent">
    <div id="contenttop">
        <div class="leftbg"></div>
        <div class="middlebg">
            <span class="bluetext"><a href="index.html" class="bluetext">Home</a> > History</span>
        </div>
        <div class="rightbg"></div>
    </div>

    <div class="clr"></div>

    <!--/* starts second table*/-->
<#include "menu.ftl">
<@main_menu selected="history" />
    <div class="clr"></div>
    <div id="beforetable"></div>
    <div id="results-dashboard">
        <div class="middlb">
            <div class="table">
                 <table class='overview'>
                  <tr>
                     <td>
                       <div id='chart_div' style='width: 700px; height: 400px;'></div>
                     </td>
                  <tr>
                  <tr>
                     <td>
                       <div id='controller_div' style='width: 700px; height: 100px;'></div>
                     </td>
                  <tr>


                 </table>
            </div>
        </div>
    </div>
</div>
<div id="beforefooter"></div>
<div id="bottomfooter"></div>

</body>
</html>
