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

<fmt:requestEncoding value="utf-8" />
<%-- リンクで渡されたパラメータを、変数 formCode に格納する --%>
<c:set var="formCode" value="${param.hiddenCode}" />
<c:set var="formComment" value="${param.field1}" />
<c:set var="formScore" value="${param.radio1}" />
<c:set var="formName" value="${param.hiddenName}" />

<sql:update>
	INSERT INTO PRODUCT_REVIEW (PRODUCT_CODE, COMMENT, SCORE) VALUES(?, ?, ?);
	<sql:param value="${formCode}" />
	<sql:param value="${formComment}" />
	<sql:param value="${formScore}" />
</sql:update>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<TITLE>口コミ</TITLE>
		<STYLE type="text/css">
		body {background-color:#696969;}
	</STYLE>
</head>
<BODY>
	<meta http-equiv="refresh"content="0;URL=review.jsp?productCode=${formCode}&hiddenName=${formName}">
	</BODY>
</html>
