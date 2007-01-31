<%@ include file="/WEB-INF/template/include.jsp" %>

<openmrs:require privilege="Manage Modules" otherwise="/login.htm" redirect="/admin/modules/module.list" />
	
<%@ include file="/WEB-INF/template/header.jsp" %>
<%@ include file="localHeader.jsp" %>

<h2><spring:message code="Module.header" /></h2>	

<br/>

<b class="boxHeader"><spring:message code="Module.add" /></b>
<div class="box">
	<form id="moduleAddForm" action="module.list" method="post" enctype="multipart/form-data">
		<spring:message code="Module.addJar"/>: 
		<input type="file" name="moduleFile" size="40" <c:if test="${allowUpload!='true'}">disabled="disabled"</c:if> /> 
		<br />
		<input type="hidden" name="action" value="upload"/>
		<br/>
		<c:choose>
			<c:when test="${allowUpload == 'true'}">
				<input type="submit" value='<spring:message code="Module.add"/>'/>
			</c:when>
			<c:otherwise>
				${disallowUploads}
			</c:otherwise>
		</c:choose>
	</form>
</div>

<br/>

<c:forEach var="module" items="${moduleList}" varStatus="varStatus">
	<c:if test="${varStatus.first}">
		<b class="boxHeader"><spring:message code="Module.manage" /></b>
		<div class="box" id="moduleListing">
			<table cellpadding="5" cellspacing="0">
				<thead>
					<tr>
						<th colspan="2"><spring:message code="general.action"/></th>
						<th><spring:message code="general.name"/></th>
						<th><spring:message code="general.version"/></th>
						<th><spring:message code="general.author"/></th>
						<th><spring:message code="general.description"/></th>
						<th></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
	</c:if>
			
					<form method="post">
					<input type="hidden" name="moduleId" value="${module.moduleId}" />
					<tr class="<c:choose><c:when test="${varStatus.index % 2 == 0}">oddRow</c:when><c:otherwise>evenRow</c:otherwise></c:choose>" id="${module.moduleId}">
						<td valign="top">
							<c:choose>
								<c:when test="${not module.started}">
									<input type="image" src="${pageContext.request.contextPath}/images/play.gif" name="action" value="start" title="<spring:message code="Module.start"/>" alt="<spring:message code="Module.start"/>" />
								</c:when>
								<c:otherwise>
									<input type="image" src="${pageContext.request.contextPath}/images/stop.gif" name="action" value="stop" alt="<spring:message code="Module.stop"/>" />
								</c:otherwise>
							</c:choose>
						</td>
						<td valign="top"><input type="image" src="${pageContext.request.contextPath}/images/delete.gif" name="action" value="unload" onclick="return confirm('<spring:message code="Module.unloadWarning"/>');" title="<spring:message code="Module.stop"/>" title="<spring:message code="Module.unload"/>" alt="<spring:message code="Module.unload"/>" /></td>
						<td valign="top">${module.name} <c:if test="${not module.started}"><b id="moduleNotStarted" style="white-space: nowrap">[<spring:message code="Module.notStarted"/>]</b></c:if></td>
						<td valign="top">${module.version}</td>
						<td valign="top">${module.author}</td>
						<td valign="top">${module.description}</td>
						<c:choose>
							<c:when test="${module.startupErrorMessage != null}">
								<td class="error"><pre style="margin: 0px;">${module.startupErrorMessage}</pre></td>
							</c:when>
							<c:otherwise>
								<td></td>
							</c:otherwise>
						</c:choose>
						<c:choose>
							<c:when test="${module.downloadURL != null}">
								<td>
									<spring:message code="Module.updateAvailable" /> 
									${module.updateVersion}: 
									<a href="${module.downloadURL}">${module.downloadURL}</a>
								</td>
							</c:when>
							<c:otherwise>
								<td> </td>
							</c:otherwise>
						</c:choose>
					</tr>
				</form>
				
	<c:if test="${varStatus.last}">
			</tbody>
			<tfoot>
				<tr>
					<td colspan="7"><form method="post"><input type="submit" value='<spring:message code="Module.checkForUpdates"/>'/></form></td>
				</tr>
			</tfoot>
	
			</table>
		</div>

	</c:if>
	
</c:forEach>

<c:if test="${fn:length(moduleList) == 0}">
	<i> &nbsp; <spring:message code="Module.noLoadedModules"/></i><br/>
</c:if>

<br/>

<b class="boxHeader"><spring:message code="Module.help" /></b>
<div class="box">
	<ul>
		<li><i><spring:message code="Module.help.load"/></i> <br/>
		<c:if test="${fn:length(moduleList) > 0}">
			<li><i><spring:message code="Module.help.unload"/></i> <br/>
			<li><i><spring:message code="Module.help.startStop"/></i> <br/>
			<li><i><spring:message code="Module.help.update"/></i> <br/>
		</c:if>
	</ul>
</div>

<%@ include file="/WEB-INF/template/footer.jsp" %>