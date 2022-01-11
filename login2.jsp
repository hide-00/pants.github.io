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
<c:set var="customerName" value="${param.customerName}" />
<%--  データベースからデータを取得して、変数lgに結果を入れる。
[LOGIN_INFO]テーブルからcustomerNameが[CUSTOMER_NAME]の[PASSWORD]を入れる--%>
<sql:query var="lg">
	SELECT PASSWORD FROM LOGIN_INFO WHERE CUSTOMER_NAME=?
	<sql:param value="${customerName}" />
</sql:query> ;
<c:set var="password" value="${param.password}" />
<c:set var="dbPass" value="${lg.rows[0].PASSWORD}" />
<c:set var="productCode" value="${param.hiddenCode}" />
<c:set var="formjsp" value="${param.jspCode}" />



<sql:query var="rs">
	SELECT PRODUCT_CODE, PRODUCT_NAME, CATEGORY_NAME, MAKER_NAME, DETAIL, MATERIAL, SIZE, IMAGE, PRICE
	FROM PRODUCT_INFO WHERE PRODUCT_CODE=? ORDER BY PRODUCT_CODE;
	<sql:param value="${productCode}" />
</sql:query>
<%-- 一行目を変数rowに代入 --%>
<c:set var="row" value="${rs.rows[0]}" />
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
		<TITLE>衣料品販売</TITLE>
		<STYLE type="text/css">
		body {background-color:#696969;}
		</style>
	</head>
	<body>
		"${formjsp}"
		"${productCode}"
		<c:choose>
			<c:when test="${password == dbPass and !empty formjsp}"><%--パスワードがあっていた時--%>
			<%--商品詳細以外からきていた時--%>
			<FORM action="list2.jsp" method="POST">
				<meta http-equiv="refresh"content="0;URL=list2.jsp?hiddenName=${customerName}">
				</form>
			</c:when>
			<c:when test="${password == dbPass and empty formjsp}"><%--パスワードがあっていた時--%>
			<%--商品詳細からきていた時--%>
			<FORM action="detail.jsp" method="POST">
				<meta http-equiv="refresh"content="0;URL=detail.jsp?productCode=${productCode}&hiddenName=${customerName}">
				</form>
			</c:when>
			<c:when test="${password != dbPass and !empty formjsp}"><%--パスワードが違った時--%>
			<%--商品詳細以外からきていた時--%>
			<FORM action="login.jsp" method="POST">
				<meta http-equiv="refresh"content="0;URL=login.jsp?jspCode=${formjsp}">
				</form>
			</c:when>
			<c:otherwise><%--パスワードが違って商品詳細からきていた時--%>
			<FORM action="login.jsp" method="POST">
				<meta http-equiv="refresh"content="0;URL=login.jsp?productCode=${productCode}">
				</form>
			</c:otherwise>
		</c:choose>
	</body>
</HTML>
