<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>블리 - 충동구매보다 빠른 합리적 쇼핑!</title>
<link href="${initParam.root}img/favicon/favicon.ico" rel="shortcut icon" type="image/x-icon" />
<meta name="Keywords" content="" />
<meta name="Description" content="" />
<!-- css -->
<link rel="stylesheet" type="text/css" href="${initParam.root}css/reset.css" />
<link rel="stylesheet" type="text/css" href="${initParam.root}css/css.css" />
 <link rel="stylesheet" href="${initParam.root}css/jquery-ui.css">
<%-- <link href="${initParam.root}css/bootstrap.css" rel="stylesheet"> --%>

<link id="bs-css" href="//netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css" rel="stylesheet">
<link href="${initParam.root}css/ct-paper.css" rel="stylesheet"/>
<!--     Fonts and icons     -->
<link href="${initParam.root}css/font-awesome.min.css" rel="stylesheet" />
<!-- jquery -->
<script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
<script src="http://code.jquery.com/ui/1.11.4/jquery-ui.js"></script>

<script src="${initParam.root}js/bootstrap.min.js"></script>
<!--  Plugins -->
<script src="${initParam.root}js/ct-paper-radio.js"></script>
<script src="${initParam.root}js/ct-paper.js"></script> 

<body>
   
      <!-- Header -->
      <div class="wrapper">
			<div class="register-background" style="background-image: url('../img/modifyBg.jpg')"> 
      <tiles:insertAttribute name="header"/>
 	 <!-- <div class="jbContent"> -->
 	<!-- main -->
 	<tiles:insertAttribute name="main"/>
 	</div>
 	</div>
  	<!-- </div> -->
    </div>
    

</body>

</html>
