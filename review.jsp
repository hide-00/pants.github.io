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
<c:set var="formCode" value="${param.productCode}" />
<c:set var="formName" value="${param.hiddenName}" />

<%--

口コミテーブルからのデータの取得

[PRODUCT_REVIEW]テーブルから前ページで選択したリンクと一致する商品の
[COMMENT],[SCORE]を検索するSQL文

--%>
<sql:query var="rs">
	SELECT COMMENT,SCORE
	FROM PRODUCT_REVIEW WHERE PRODUCT_CODE =?;
	<sql:param value="${formCode}"/>
</sql:query>

<sql:query var="mk">
	SELECT MAKER_CODE, MAKER_NAME
	FROM MAKER_INFO ORDER BY MAKER_CODE;
</sql:query>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<TITLE>口コミ</TITLE>
		<%--

		表示方法の設定

	--%>
	<STYLE type="text/css">
	body {background-color:#696969; font-size:20px;}
	table {border-collapse:separate; border-spacing:2px; width:1000px; margin-top: 20px;}
	th {background-color:#333333; text-align:center; font-size:large; font-weight:bold; color:white;}
	td {background-color:#EFEFEF; font-size:normal; color:black;}
	.main { width:80%; float:left; font-family:serif;}
	.side { width:20%; float:left; font-family:serif;}
	.header img{width: 100%;}
	.review{margin-top: 40px; margin-left: 40px; line-height:50px; text-align: left;}
	.text{text-align: left; margin-left: 40px;}
	ul {
		margin: 10 ;
		padding: 0;
		list-style-type: none;
		background-color: #505050;
	}
	li a {
		display: block;
		padding: 8px 16px;
		text-decoration: none;
		color: #000000;
		border-bottom: solid;
		border-bottom-color: #000000;
	}
	li a.category{
		color: #ffffff;
		background-color: #544a47;
	}
	li a:hover:not(.category) {
		color: #ffffff;
		background-color: #a9a9a9;
	}

</STYLE>
</head>
<BODY>

	<p class="header">
		<a href="list2.jsp?hiddenName=${formName}"><img src="image/top.jpg" alt="トップ画像"/></a>
	</p>

	<div class="side">
		<ul>
			<li><a class="category">Brand</a></li>
			<c:forEach var="row2" items="${mk.rows}">
				<li><a href="list3.jsp?makerName=${row2.MAKER_NAME}&hiddenName=${formName}"> ${row2.MAKER_NAME}</a></li>
			</c:forEach>
		</ul>
	</div>

	<CENTER>
		<div class="main">

			<H2>レビュー一覧</H2>

			商品コード：${formCode}

			<TABLE>
				<TR>
					<TH>口コミ</TH>
					<TH>採点</TH>
				</TR>

				<c:forEach var="row" items="${rs.rows}">

					<TR>
						<TD>${row.COMMENT}</TD>
						<TD>${row.SCORE}</TD>
					</TR>

				</c:forEach>

			</TABLE>
			<div class="review">
				口コミ入力欄<br>
				<FORM ACTION="review2.jsp" METHOD="post">
					<input type="hidden" name="hiddenCode" value="${formCode}">
					<input type="hidden" name="hiddenName" value="${formName}">
					<label for="name">口コミ</label>
					<INPUT TYPE="text" NAME="field1" SIZE="42" MAXLENGTH="80" value=""><BR>
					<label for="name">	採点</label>
					<INPUT TYPE="radio" NAME="radio1" VALUE="1" CHECKED>１点
					<INPUT TYPE="radio" NAME="radio1" VALUE="2">２点
					<INPUT TYPE="radio" NAME="radio1" VALUE="3">３点
					<INPUT TYPE="radio" NAME="radio1" VALUE="4">４点
					<INPUT TYPE="radio" NAME="radio1" VALUE="5">５点<br>
					<INPUT TYPE="submit" value=" 送 信 ">
				</FORM>
			</div>
		</div>
  </CENTER>
</BODY>
</html>
