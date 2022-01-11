<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
	<!DOCTYPE html>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

	<%--
	データベースへのコネクションを取得
--%>
<sql:setDataSource driver="org.h2.Driver" url="jdbc:h2:sdev" />
<c:set var="productCode" value="${param.hiddenCode}" />
<c:set var="customerName" value="${param.customerName}" />
<c:set var="password" value="${param.password}" />
<c:set var="address" value="${param.address}" />
<c:set var="cardNumber" value="${param.cardNumber}" />
<c:set var="cardCode" value="${param.cardCode}" />
<c:set var="jspCode" value="${param.jspCode}" />

<sql:update>
	INSERT INTO LOGIN_INFO VALUES(?, ?, ?, ?, ?);
	<sql:param value="${customerName}" />
	<sql:param value="${password}" />
	<sql:param value="${address}" />
	<sql:param value="${cardNumber}" />
	<sql:param value="${cardCode}" />
</sql:update>


<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
		<TITLE>衣料品販売</TITLE>

		<%--表示方法の設定--%>
		<STYLE type="text/css">
		body {background-color:#696969;}
		</style>
	</head>
	<body>
		<c:choose>
			<c:when test="${!empty productCode}">
				<%--商品詳細からきていた時--%>
				<meta http-equiv="refresh"content="0;URL=login.jsp?productCode=${productCode}">
				</c:when>
				<c:otherwise>
					<%--商品詳細以外からきていた時--%>
					<meta http-equiv="refresh"content="0;URL=login.jsp?jspCode=${jspCode}">
					</c:otherwise>
				</c:choose>
			</body>
		</HTML>
