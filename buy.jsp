<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" import="java.sql.*"%>
	<!DOCTYPE html>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<%--

	データベースへのコネクションを取得

--%>
<sql:setDataSource driver="org.h2.Driver" url="jdbc:h2:sdev" />


<%--  詳細画面で入力した値を取得する--%>
<fmt:requestEncoding value="utf-8" />
<%-- 製品コードを変数[formCode]に格納する --%>
<c:set var="formCode" value="${param.productCode}" />
<%-- [購入者]を変数[formCustomerName]に格納する --%>
<c:set var="formCustomerName" value="${param.hiddenName}" />

<sql:query var="rs">
	<%--CUSTOMER_NAMEがformCustomerNameでまだ購入していない商品と数量×単価をRESULTに入れた表をrsに--%>
	SELECT *, PRICE*NUMBER AS RESULT FROM CART
	WHERE CUSTOMER_NAME=? AND HISTORY='yet' ORDER BY PRODUCT_CODE;
	<sql:param value="${formCustomerName}" />
</sql:query>

<c:forEach var="row" items="${rs.rows}">
	<%--購入していない商品の種類分SUMのRESULTに数量×単価を入れる--%>
	<sql:update>
		INSERT INTO SUM VALUES(?,?,?,?);
		<sql:param value="${formCustomerName}" />
		<sql:param value="${row.PRODUCT_CODE}" />
		<sql:param value="${row.RESULT}" />
		<sql:param value="yet" />
	</sql:update>
</c:forEach>

<sql:query var="su">
	<%--購入していない商品の合計金額を計算--%>
	SELECT CUSTOMER_NAME RESULT,SUM(RESULT) AS SUM FROM SUM
	WHERE CUSTOMER_NAME=? AND HISTORY=? GROUP BY CUSTOMER_NAME;
	<sql:param value="${formCustomerName}" />
	<sql:param value="yet" />
</sql:query>
<c:set var="sm" value="${su.rows[0]}" />


<sql:query var="ci">
	<%--ユーザー情報を検索--%>
	SELECT CUSTOMER_NAME, PASSWORD, ADDRESS, CARD_NUMBER, CARD_CODE
	FROM LOGIN_INFO  WHERE CUSTOMER_NAME = ?;
	<sql:param value="${formCustomerName}" />
</sql:query>
<c:set var="cs" value="${ci.rows[0]}" />

<sql:query var="mk">
	SELECT MAKER_CODE, MAKER_NAME
	FROM MAKER_INFO ORDER BY MAKER_CODE;
</sql:query>

<%--
注文内容をデータベースに登録するSQL文を実行する
[PURCHASE_HISTORY]テーブルに、[PRODUCT_CODE], [CUSTOMER_NAME],
[PURCHASE_DATE], [PRODUCT_NUM],[PRICE] を登録するSQL文
--%>
<c:forEach var="row" items="${rs.rows}">
	<sql:update>
		INSERT INTO PURCHASE_HISTORY (PRODUCT_CODE,CUSTOMER_NAME,PURCHASE_DATE,PRODUCT_NUM,PRICE) VALUES(?, ?, ?, ?, ?);
		<sql:param value="${row.PRODUCT_CODE}" />
		<sql:param value="${formCustomerName}" />
		<sql:dateParam value="<%=new java.util.Date()%>" type="TIMESTAMP" />
		<sql:param value="${row.NUMBER}" />
		<sql:param value="${row.PRICE}" />
	</sql:update>


	<sql:update>
		<%--在庫を更新--%>
		UPDATE PRODUCT_STOCK SET STOCK_NUM = STOCK_NUM - ? WHERE PRODUCT_CODE = ?;
		<sql:param value="${row.NUMBER}" />
		<sql:param value="${row.PRODUCT_CODE}" />
	</sql:update>
</c:forEach>

<sql:update>
	UPDATE CART SET HISTORY='bought' WHERE CUSTOMER_NAME=?
	<sql:param value="${formCustomerName}" />
</sql:update>

<sql:update>
	UPDATE SUM SET HISTORY='bought' WHERE CUSTOMER_NAME=?
	<sql:param value="${formCustomerName}" />
</sql:update>


<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			<TITLE>購入結果</TITLE>
			<%--

			表示方法の設定

		--%>
		<STYLE type="text/css">
		body {background-color:#696969;}
		img {vertical-align: middle;}
		.main { width:80%; float:left;text-align: center; font-family:serif;}
		.side { width:20%; float:left; font-family:serif;}
		.header img{width: 100%;}
		.row{position: relative; margin : 20px; font-family:serif;
			width:300px; height: 350px; float:left; border:1px solid #ff6a00;}
			.row a{display:block; position: absolute;
				top:0; left: 0;
				width: 100%; height: 100%;}
				.row:hover{	color: #ffffff;	background-color: #a9a9a9;}
				.detail{padding-left: 40px; text-align:left;}
				.info{margin:0 auto; width: 300px;}
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
				<a href="list2.jsp"><img src="image/top.jpg" alt="トップ画像"/></a>
			</p>
			<div class="side">
				<c:choose>
					<c:when test="${!empty formCustomerName}">
						ユーザー名：${formCustomerName}
						<FORM action="list2.jsp" method="POST">
							<INPUT type="submit" name="logout" value="ログアウト">
							</FORM>
						</c:when>
						<c:otherwise>

							未ログイン
							<FORM action="login.jsp" method="POST">
								<input type="hidden" name="jspCode" value="list2" />
								<INPUT type="submit" name="login" value="ログイン">
								</FORM>
							</c:otherwise>
						</c:choose>

						<ul>
							<li><a class="category">Brand</a></li>
							<c:forEach var="row" items="${mk.rows}">
								<li><a href="list3.jsp?makerName=${row.MAKER_NAME}&hiddenName=${formName}"> ${row.MAKER_NAME}</a></li>
							</c:forEach>
						</ul>
					</div>

					<div class="main">
						<FONT size="25" color="#000000"><B>ご購入ありがとうございました。</B><br>
						<B>よいパンツライフを!!</B></FONT>
						<div class="buy">
							<h2>購入した商品</h2>
							<c:forEach var="row" items="${rs.rows}">
								<div class="row">
									<a href="detail.jsp?productCode=${row.PRODUCT_CODE}"></a>
									<img src="image/${row.IMAGE}" height="200px" /><BR>
									<BR>
										<div class="detail">
											メーカー:${row.MAKER_NAME}<BR>
											購入価格:${row.PRICE}円<BR>
											数量：${row.Number}着<BR>
										</div>
									</div>
								</c:forEach>
							</div>
							<div class="info">

								<h2>購入情報</h2>
								<div class="detail">
									購入者氏名：${cs.CUSTOMER_NAME}<br>
									配達先住所：${cs.ADDRESS}<br>
									決済したカード番号：${cs.CARD_NUMBER}<br>
									合計決済金額：${sm.SUM}円<br>
								</div>
							</div>
							<FORM ACTION="list2.jsp" METHOD="post">
								<input type="hidden" name="hiddenName" value="${formCustomerName}" />
								<INPUT TYPE="submit" value=" トップへ ">
								</FORM>
							</div>
						</BODY>
					</HTML>
