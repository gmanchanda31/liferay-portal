<%
/**
 * Copyright (c) 2000-2007 Liferay, Inc. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
%>

<%@ include file="/html/portlet/enterprise_admin/init.jsp" %>

<%
String cmd = ParamUtil.getString(request, Constants.CMD);

tabs1 = "roles";
String tabs2 = ParamUtil.getString(request, "tabs2", "current");

String cur = ParamUtil.getString(request, "cur");

Role role = (Role)request.getAttribute(WebKeys.ROLE);

String portletResource = ParamUtil.getString(request, "portletResource");
String modelResource = ParamUtil.getString(request, "modelResource");

String portletResourceName = null;

if (Validator.isNotNull(portletResource)) {
	Portlet portlet = PortletLocalServiceUtil.getPortletById(company.getCompanyId(), portletResource);

	portletResourceName = PortalUtil.getPortletTitle(portlet, application, locale);
}

String modelResourceName = ResourceActionsUtil.getModelResource(pageContext, modelResource);

List modelResources = null;

if (Validator.isNotNull(portletResource) && Validator.isNull(modelResource)) {
	modelResources = ResourceActionsUtil.getPortletModelResources(portletResource);
}

String selResource = modelResource;
String selResourceName = modelResourceName;

if (Validator.isNull(modelResource)) {
	selResource = portletResource;
	selResourceName = portletResourceName;
}

PortletURL portletURL = renderResponse.createRenderURL();

portletURL.setWindowState(WindowState.MAXIMIZED);

portletURL.setParameter("struts_action", "/enterprise_admin/edit_role_permissions");
portletURL.setParameter("tabs1", tabs1);
portletURL.setParameter("tabs2", tabs2);
portletURL.setParameter("roleId", String.valueOf(role.getRoleId()));
portletURL.setParameter("portletResource", portletResource);
portletURL.setParameter("modelResource", modelResource);

PortletURL addPermissionsURL = renderResponse.createRenderURL();

addPermissionsURL.setWindowState(WindowState.MAXIMIZED);

addPermissionsURL.setParameter("struts_action", "/enterprise_admin/edit_role_permissions");
addPermissionsURL.setParameter(Constants.CMD, Constants.EDIT);
addPermissionsURL.setParameter("tabs1", "roles");
addPermissionsURL.setParameter("redirect", currentURL);
addPermissionsURL.setParameter("roleId", String.valueOf(role.getRoleId()));

boolean editPortletPermissions = ParamUtil.getBoolean(request, "editPortletPermissions");

if ((modelResources != null) && (modelResources.size() == 0)) {
	editPortletPermissions = true;
}

int totalSteps = 0;

if (portletResource.equals(PortletKeys.PORTAL)) {
	totalSteps = 1;
}
else if (role.getType() == RoleImpl.TYPE_REGULAR) {
	totalSteps = 3;
}
else if ((role.getType() == RoleImpl.TYPE_COMMUNITY) || (role.getType() == RoleImpl.TYPE_ORGANIZATION)) {
	totalSteps = 3;
}

// Breadcrumbs

PortletURL breadcrumbsURL = renderResponse.createRenderURL();

breadcrumbsURL.setWindowState(WindowState.MAXIMIZED);

breadcrumbsURL.setParameter("struts_action", "/enterprise_admin/view");
breadcrumbsURL.setParameter("tabs1", tabs1);
breadcrumbsURL.setParameter("roleId", String.valueOf(role.getRoleId()));

String breadcrumbs = "<a href=\"" + breadcrumbsURL.toString() + "\">" + LanguageUtil.get(pageContext, "roles") + "</a> &raquo; ";

breadcrumbsURL.setParameter("struts_action", "/enterprise_admin/edit_role_permissions");
breadcrumbsURL.setParameter(Constants.CMD, Constants.VIEW);

breadcrumbs += "<a href=\"" + breadcrumbsURL.toString() + "\">" + role.getName() + "</a>";

breadcrumbsURL.setParameter(Constants.CMD, Constants.EDIT);

if (!cmd.equals(Constants.VIEW) && Validator.isNotNull(portletResource)) {
	breadcrumbsURL.setParameter("portletResource", portletResource);

	breadcrumbs += " &raquo; <a href=\"" + breadcrumbsURL.toString() + "\">" + portletResourceName + "</a>";
}

if (!cmd.equals(Constants.VIEW) && Validator.isNotNull(modelResource)) {
	breadcrumbsURL.setParameter("modelResource", modelResource);

	breadcrumbs += " &raquo; <a href=\"" + breadcrumbsURL.toString() + "\">" + modelResourceName + "</a>";
}
%>

<script type="text/javascript">
	function <portlet:namespace />addPermissions(type) {
		var addPermissionsURL = "<%= addPermissionsURL.toString() %>";

		if (type == "portal") {
			addPermissionsURL += "&<portlet:namespace />portletResource=<%= PortletKeys.PORTAL %>";
		}

		self.location = addPermissionsURL;
	}

	function <portlet:namespace />updateActions() {
		document.<portlet:namespace />fm.<portlet:namespace /><%= Constants.CMD %>.value = "actions";
		document.<portlet:namespace />fm.<portlet:namespace />redirect.value = "<%= portletURL.toString() %>";
		submitForm(document.<portlet:namespace />fm);
	}

	function <portlet:namespace />removeGroup(pos, target) {
		var selectedGroupIds = document.<portlet:namespace />fm['<portlet:namespace />groupIds' + target].value.split(",");
		var selectedGroupNames = document.<portlet:namespace />fm['<portlet:namespace />groupNames' + target].value.split("@@");

		selectedGroupIds.splice(pos, 1);
		selectedGroupNames.splice(pos, 1);

		<portlet:namespace />updateGroups(selectedGroupIds, selectedGroupNames, target);
	}

	function <portlet:namespace />selectGroup(groupId, name, target) {
		var selectedGroupIds = [];
		var selectedGroupIdsField = document.<portlet:namespace />fm['<portlet:namespace />groupIds' + target].value;

		if (selectedGroupIdsField != "") {
			selectedGroupIds = selectedGroupIdsField.split(",");
		}

		var selectedGroupNames = [];
		var selectedGroupNamesField = document.<portlet:namespace />fm['<portlet:namespace />groupNames' + target].value;

		if (selectedGroupNamesField != "") {
			selectedGroupNames = selectedGroupNamesField.split("@@");
		}

		selectedGroupIds.push(groupId);
		selectedGroupNames.push(name);

		<portlet:namespace />updateGroups(selectedGroupIds, selectedGroupNames, target);
	}

	function <portlet:namespace />toggleGroupDiv(target) {
		var scope = document.<portlet:namespace />fm['<portlet:namespace />scope' + target].value;

		if (scope == '<%= ResourceImpl.SCOPE_GROUP %>') {
			document.getElementById("<portlet:namespace />groupDiv" + target).style.display = "";
		}
		else {
			document.getElementById("<portlet:namespace />groupDiv" + target).style.display = "none";
		}
	}

	function <portlet:namespace />updateGroups(selectedGroupIds, selectedGroupNames, target) {
		document.<portlet:namespace />fm['<portlet:namespace />groupIds' + target].value = selectedGroupIds.join(',');
		document.<portlet:namespace />fm['<portlet:namespace />groupNames' + target].value = selectedGroupNames.join('@@');

		var nameEl = document.getElementById("<portlet:namespace />groupHTML" + target);

		var groupsHTML = '';

		for (var i = 0; i < selectedGroupIds.length; i++) {
			var id = selectedGroupIds[i];
			var name = selectedGroupNames[i];

			groupsHTML += '<span>' + name + '&nbsp;[<a href="javascript: <portlet:namespace />removeGroup(' + i + ', \'' + target + '\' );">x</a>]</span>';

			if (i < selectedGroupIds.length) {
				groupsHTML += ',&nbsp;'
			}
		}

		nameEl.innerHTML = groupsHTML;
	}
</script>

<form action="<portlet:actionURL windowState="<%= WindowState.MAXIMIZED.toString() %>"><portlet:param name="struts_action" value="/enterprise_admin/edit_role_permissions" /></portlet:actionURL>" id="<portlet:namespace />fm" method="post" name="<portlet:namespace />fm">
<input name="<portlet:namespace /><%= Constants.CMD %>" type="hidden" value="" />
<input name="<portlet:namespace />tabs2" type="hidden" value="<%= tabs2 %>" />
<input name="<portlet:namespace />redirect" type="hidden" value="" />
<input name="<portlet:namespace />roleId" type="hidden" value="<%= role.getRoleId() %>" />
<input name="<portlet:namespace />portletResource" type="hidden" value="<%= portletResource %>" />
<input name="<portlet:namespace />modelResource" type="hidden" value="<%= modelResource %>" />

<liferay-util:include page="/html/portlet/enterprise_admin/tabs1.jsp">
	<liferay-util:param name="tabs1" value="<%= tabs1 %>" />
</liferay-util:include>

<c:choose>
	<c:when test="<%= cmd.equals(Constants.VIEW) %>">

		<%
		portletURL.setParameter(Constants.CMD, Constants.VIEW);
		%>

		<div class="breadcrumbs">
			<%= breadcrumbs %>
		</div>

		<liferay-ui:success key="permissionDeleted" message="the-permission-was-deleted" />
		<liferay-ui:success key="permissionsUpdated" message="the-role-permissions-were-updated" />

		<%
		List headerNames = new ArrayList();

		headerNames.add("resource");
		headerNames.add("action");

		if ((role.getType() == RoleImpl.TYPE_REGULAR)) {
			headerNames.add("scope");
			headerNames.add("community");
		}

		headerNames.add(StringPool.BLANK);

		SearchContainer searchContainer = new SearchContainer(renderRequest, null, null, SearchContainer.DEFAULT_CUR_PARAM, SearchContainer.DEFAULT_DELTA, portletURL, headerNames, "this-role-does-have-any-permissions");

		List permissions = PermissionLocalServiceUtil.getRolePermissions(role.getRoleId());

		List permissionsDisplay = new ArrayList(permissions.size());

		for (int i = 0; i < permissions.size(); i++) {
			Permission permission = (Permission)permissions.get(i);

			Resource resource = ResourceLocalServiceUtil.getResource(permission.getResourceId());

			String resourceName = resource.getName();
			String resourceNameParam = null;
			String resourceLabel = null;
			String actionId = permission.getActionId();
			String actionLabel = ResourceActionsUtil.getAction(pageContext, actionId);

			if (PortletLocalServiceUtil.hasPortlet(company.getCompanyId(), resourceName)) {
				Portlet portlet = PortletLocalServiceUtil.getPortletById(company.getCompanyId(), resourceName);

				resourceLabel = PortalUtil.getPortletTitle(portlet, application, locale);
				resourceNameParam = "portletResource";
			}
			else {
				resourceLabel = ResourceActionsUtil.getModelResource(pageContext, resourceName);
				resourceNameParam = "modelResource";
			}

			permissionsDisplay.add(new PermissionDisplay(permission, resource, resourceName, resourceNameParam, resourceLabel, actionId, actionLabel));
		}

		Collections.sort(permissionsDisplay);

		int total = permissionsDisplay.size();

		searchContainer.setTotal(total);

		List results = ListUtil.subList(permissionsDisplay, searchContainer.getStart(), searchContainer.getEnd());

		searchContainer.setResults(results);

		List resultRows = searchContainer.getResultRows();

		for (int i = 0; i < results.size(); i++) {
			PermissionDisplay permissionDisplay = (PermissionDisplay)results.get(i);

			Permission permission = permissionDisplay.getPermission();
			Resource resource = permissionDisplay.getResource();
			String resourceName = permissionDisplay.getResourceName();
			String resourceNameParam = permissionDisplay.getResourceNameParam();
			String resourceLabel = permissionDisplay.getResourceLabel();
			String actionId = permissionDisplay.getActionId();
			String actionLabel = permissionDisplay.getActionLabel();

			ResultRow row = new ResultRow(new Object[] {permission, role}, actionId, i);

			boolean hasCompanyScope = (role.getType() == RoleImpl.TYPE_REGULAR) && PermissionLocalServiceUtil.hasRolePermission(role.getRoleId(), company.getCompanyId(), resourceName, ResourceImpl.SCOPE_COMPANY, actionId);
			boolean hasGroupTemplateScope = ((role.getType() == RoleImpl.TYPE_COMMUNITY) || (role.getType() == RoleImpl.TYPE_ORGANIZATION)) && PermissionLocalServiceUtil.hasRolePermission(role.getRoleId(), company.getCompanyId(), resourceName, ResourceImpl.SCOPE_GROUP_TEMPLATE, actionId);
			boolean hasGroupScope = (role.getType() == RoleImpl.TYPE_REGULAR) && PermissionLocalServiceUtil.hasRolePermission(role.getRoleId(), company.getCompanyId(), resourceName, ResourceImpl.SCOPE_GROUP, actionId);

			PortletURL editResourcePermissionsURL = renderResponse.createRenderURL();

			editResourcePermissionsURL.setWindowState(WindowState.MAXIMIZED);

			editResourcePermissionsURL.setParameter("struts_action", "/enterprise_admin/edit_role_permissions");
			editResourcePermissionsURL.setParameter("tabs1", "roles");
			editResourcePermissionsURL.setParameter("redirect", currentURL);
			editResourcePermissionsURL.setParameter("roleId", String.valueOf(role.getRoleId()));

			if (resourceNameParam.equals("modelResource")) {
				List portletResources = ResourceActionsUtil.getModelPortletResources(resourceName);

				if (portletResources.size() > 0) {
					editResourcePermissionsURL.setParameter("portletResource", (String)portletResources.get(0));
				}
			}

			editResourcePermissionsURL.setParameter(resourceNameParam, resourceName);

			row.addText(resourceLabel, editResourcePermissionsURL);
			row.addText(actionLabel);

			if (hasCompanyScope) {
				row.addText(LanguageUtil.get(pageContext, "enterprise"));
				row.addText(StringPool.BLANK);
			}
			else if (hasGroupTemplateScope) {
			}
			else if (hasGroupScope) {
				row.addText(LanguageUtil.get(pageContext, "community"));

				long groupId = GetterUtil.getLong(resource.getPrimKey());

				Group group = GroupLocalServiceUtil.getGroup(groupId);

				row.addText(group.getName());
			}

			// Action

			row.addJSP("right", SearchEntry.DEFAULT_VALIGN, "/html/portlet/enterprise_admin/permission_action.jsp");

			if (hasCompanyScope || hasGroupTemplateScope || hasGroupScope) {
				resultRows.add(row);
			}
		}
		%>

		<input type="button" value="<liferay-ui:message key="add-portlet-permissions" />" onclick="<portlet:namespace />addPermissions('portlet');" />

		<c:if test="<%= role.getType() == RoleImpl.TYPE_REGULAR%>">
			<input type="button" value="<liferay-ui:message key="add-portal-permissions" />" onclick="<portlet:namespace />addPermissions('portal');" />
		</c:if>

		<br /><br />

		<liferay-ui:search-iterator searchContainer="<%= searchContainer %>" />
	</c:when>
	<c:when test="<%= editPortletPermissions || Validator.isNotNull(modelResource) %>">
		<liferay-ui:error key="missingGroupIdsForAction" message="select-at-least-one-community-for-each-action-with-scope-set-to-communities" />

		<%
		List actions = ResourceActionsUtil.getResourceActions(company.getCompanyId(), portletResource, modelResource);

		Collections.sort(actions, new ActionComparator(company.getCompanyId(), locale));
		%>

		<div class="portlet-section-body" style="border: 1px solid <%= colorScheme.getPortletFontDim() %>; padding: 5px;">
			<c:choose>
				<c:when test="<%= portletResource.equals(PortletKeys.PORTAL) %>">
					<%= LanguageUtil.format(pageContext, "step-x-of-x", new String[] {"1", String.valueOf(totalSteps)}) %>

					<%= LanguageUtil.format(pageContext, "select-the-scope-of-the-action-that-this-role-can-perform-on-the-x", portletResourceName) %>

					<c:if test="<%= actions.size() > 0 %>">
						<liferay-ui:message key="you-can-choose-more-than-one" />
					</c:if>
				</c:when>
				<c:when test="<%= role.getType() == RoleImpl.TYPE_REGULAR %>">
					<%= LanguageUtil.format(pageContext, "step-x-of-x", new String[] {"3", String.valueOf(totalSteps)}) %>

					<c:choose>
						<c:when test="<%= Validator.isNotNull(modelResource) %>">
							<%= LanguageUtil.format(pageContext, "select-the-scope-of-the-action-that-this-role-can-perform-on-the-x-resource", modelResourceName) %>
						</c:when>
						<c:otherwise>
							<%= LanguageUtil.format(pageContext, "select-the-scope-of-the-action-that-this-role-can-perform-on-the-x-portlet", portletResourceName) %>
						</c:otherwise>
					</c:choose>

					<c:if test="<%= actions.size() > 0 %>">
						<liferay-ui:message key="you-can-choose-more-than-one" />
					</c:if>
				</c:when>
				<c:otherwise>
					<%= LanguageUtil.format(pageContext, "step-x-of-x", new String[] {"3", String.valueOf(totalSteps)}) %>

					<c:choose>
						<c:when test="<%= Validator.isNotNull(modelResource) %>">
							<%= LanguageUtil.format(pageContext, "select-the-action-that-this-role-can-perform-on-the-x-resource", modelResourceName) %>
						</c:when>
						<c:otherwise>
							<%= LanguageUtil.format(pageContext, "select-the-action-that-this-role-can-perform-on-the-x-portlet", portletResourceName) %>
						</c:otherwise>
					</c:choose>

					<c:if test="<%= actions.size() > 0 %>">
						<liferay-ui:message key="you-can-choose-more-than-one" />
					</c:if>
				</c:otherwise>
			</c:choose>
		</div>

		<br />

		<div class="breadcrumbs">
			<%= breadcrumbs %>
		</div>

		<table class="liferay-table">
		<tr>
			<th>
				<liferay-ui:message key="action" />
			</th>
			<th>
				<c:choose>
					<c:when test="<%= role.getType() == RoleImpl.TYPE_REGULAR %>">
						<liferay-ui:message key="scope" />
					</c:when>
					<c:when test="<%= (role.getType() == RoleImpl.TYPE_COMMUNITY) || (role.getType() == RoleImpl.TYPE_ORGANIZATION) %>">
						<input name="<portlet:namespace />actionAllBox" type="checkbox" />
					</c:when>
				</c:choose>
			</th>
			<th></th>
		</tr>

		<%
		for (int i = 0; i < actions.size(); i++) {
			String actionId = (String)actions.get(i);

			int scopeParam = ParamUtil.getInteger(renderRequest, "scope" + actionId);

			boolean hasCompanyScope = false;
			boolean hasGroupTemplateScope = false;
			boolean hasGroupScope = false;

			if (scopeParam > 0) {
				hasCompanyScope = (scopeParam == ResourceImpl.SCOPE_COMPANY);
				hasGroupTemplateScope = (scopeParam == ResourceImpl.SCOPE_GROUP_TEMPLATE);
				hasGroupScope = (scopeParam == ResourceImpl.SCOPE_GROUP);
			}
			else {
				hasCompanyScope = (role.getType() == RoleImpl.TYPE_REGULAR) && PermissionLocalServiceUtil.hasRolePermission(role.getRoleId(), company.getCompanyId(), selResource, ResourceImpl.SCOPE_COMPANY, actionId);
				hasGroupTemplateScope = ((role.getType() == RoleImpl.TYPE_COMMUNITY)  || (role.getType() == RoleImpl.TYPE_ORGANIZATION))  && PermissionLocalServiceUtil.hasRolePermission(role.getRoleId(), company.getCompanyId(), selResource, ResourceImpl.SCOPE_GROUP_TEMPLATE, actionId);
				hasGroupScope = (role.getType() == RoleImpl.TYPE_REGULAR) && PermissionLocalServiceUtil.hasRolePermission(role.getRoleId(), company.getCompanyId(), selResource, ResourceImpl.SCOPE_GROUP, actionId);
			}
		%>

			<tr>
				<td>
					<%= ResourceActionsUtil.getAction(pageContext, actionId) %>
				</td>
				<td>
					<c:choose>
						<c:when test="<%= role.getType() == RoleImpl.TYPE_REGULAR %>">
							<select name="<portlet:namespace />scope<%= actionId %>" onchange="<portlet:namespace/>toggleGroupDiv('<%= actionId %>');">
								<option value=""></option>
									<option <%= hasCompanyScope ? "selected" : "" %> value="<%= ResourceImpl.SCOPE_COMPANY %>"><liferay-ui:message key="enterprise" /></option>

									<c:if test="<%= !portletResource.equals(PortletKeys.ENTERPRISE_ADMIN) && !portletResource.equals(PortletKeys.ORGANIZATION_ADMIN) && !portletResource.equals(PortletKeys.PORTAL) %>">
										<option <%= (hasGroupScope) ? "selected" : "" %> value="<%= ResourceImpl.SCOPE_GROUP %>"><liferay-ui:message key="communities" /></option>
									</c:if>
							</select>
						</c:when>
						<c:when test="<%= (role.getType() == RoleImpl.TYPE_COMMUNITY) || (role.getType() == RoleImpl.TYPE_ORGANIZATION) %>">

							<%
							boolean disabled = portletResource.equals(PortletKeys.ENTERPRISE_ADMIN) || portletResource.equals(PortletKeys.ORGANIZATION_ADMIN) || portletResource.equals(PortletKeys.PORTAL);

							if ((role.getType() == RoleImpl.TYPE_ORGANIZATION) && ResourceActionsUtil.isOrganizationModelResource(modelResourceName)) {
								disabled = false;
							}
							%>

							<liferay-ui:input-checkbox
								param='<%= "scope" + actionId %>'
								defaultValue="<%= hasGroupTemplateScope %>"
								onClick='<%= "document.getElementById('" + renderResponse.getNamespace() + "scope" + actionId + "').value = (this.checked ? '" + ResourceImpl.SCOPE_GROUP + "' : '');" %>'
								disabled="<%= disabled %>"
							/>

							<c:if test="<%= hasGroupTemplateScope %>">
								<script type="text/javascript">
									document.getElementById("<%= renderResponse.getNamespace() %>scope<%= actionId %>").value =	"<%= ResourceImpl.SCOPE_GROUP %>";
								</script>
							</c:if>
						</c:when>
					</c:choose>
				</td>
				<td>

					<%
					StringMaker groupsHTML = new StringMaker();

					String groupIds = ParamUtil.getString(request, "groupIds" + actionId, null);
					long[] groupIdsArray = StringUtil.split(groupIds, 0L);

					List groupNames = new ArrayList();
					%>

					<c:if test="<%= hasGroupScope %>">

						<%
						LinkedHashMap groupParams = new LinkedHashMap();

						List rolePermissions = new ArrayList();

						rolePermissions.add(selResource);
						rolePermissions.add(new Integer(ResourceImpl.SCOPE_GROUP));
						rolePermissions.add(actionId);
						rolePermissions.add(new Long(role.getRoleId()));

						groupParams.put("rolePermissions", rolePermissions);

						List groups = GroupLocalServiceUtil.search(company.getCompanyId(), null, null, groupParams, QueryUtil.ALL_POS, QueryUtil.ALL_POS);

						groupIdsArray = new long[groups.size()];

						for (int j = 0; j < groups.size(); j++) {
							Group group = (Group)groups.get(j);

							groupIdsArray[j] = group.getGroupId();

							groupNames.add(group.getName());

							groupsHTML.append("<span>");
							groupsHTML.append(group.getName());

							groupsHTML.append("&nbsp;[<a href='javascript: ");
							groupsHTML.append(renderResponse.getNamespace());
							groupsHTML.append("removeGroup(");
							groupsHTML.append(i);
							groupsHTML.append(");'>x</a>]");

							groupsHTML.append("</span>");

							if ((j + 1) != groups.size()) {
								groupsHTML.append(",&nbsp;");
							}
						}
						%>

					</c:if>

					<input name="<portlet:namespace />groupIds<%= actionId %>" type="hidden" value="<%= StringUtil.merge(groupIdsArray) %>" />
					<input name="<portlet:namespace />groupNames<%= actionId %>" type="hidden" value='<%= StringUtil.merge(groupNames, "@@") %>' />

					<div id="<portlet:namespace />groupDiv<%= actionId %>" <%= hasGroupScope ? "" : "style=\"display: none;\"" %>>
						<span id="<portlet:namespace />groupHTML<%= actionId %>">
							<%= groupsHTML.toString() %>
						</span>

						<input type="button" value="<liferay-ui:message key="select" />" onclick="var groupWindow = window.open('<portlet:renderURL windowState="<%= LiferayWindowState.POP_UP.toString() %>"><portlet:param name="struts_action" value="/enterprise_admin/select_community" /><portlet:param name="target" value="<%= actionId %>" /></portlet:renderURL>', 'community', 'directories=no,height=640,location=no,menubar=no,resizable=yes,scrollbars=no,status=no,toolbar=no,width=680'); void(''); groupWindow.focus();" />
					</div>
				</td>
			</tr>

		<%
		}
		%>

		</table>

		<br />

		<input type="button" value="<liferay-ui:message key="save" />" onclick="<portlet:namespace />updateActions();" />

		<script type="text/javascript">
			jQuery(
				function() {
					var form = jQuery("#<portlet:namespace />fm");

					var allBox = form.find("input[@name=<portlet:namespace />actionAllBox]");
					var inputs = form.find("input[@type=checkbox]").not(allBox);

					var inputsCount = inputs.length;

					if (inputs.not(":checked").length == 0) {
						allBox.attr("checked", true);
					}

					allBox.click(
						function() {
							var allBoxChecked = this.checked;

							if (allBoxChecked) {
								var uncheckedInputs = inputs.not(":checked");

								uncheckedInputs.trigger("click");
							}
							else {
								var checkedInputs = inputs.filter(":checked");

								checkedInputs.trigger("click");
							}

							allBox.attr("checked", allBoxChecked);
						}
					);

					inputs.click(
						function() {
							var uncheckedCount = inputs.not(":checked").length;

							if (this.checked) {
								if (uncheckedCount == 0) {
									allBox.attr("checked", true);
								}
							}
							else {
								if (inputsCount > uncheckedCount) {
									allBox.attr("checked", false);
								}
							}
						}
					);
				}
			);
		</script>
	</c:when>
	<c:when test="<%= Validator.isNotNull(portletResource) %>">
		<div class="portlet-section-body" style="border: 1px solid <%= colorScheme.getPortletFontDim() %>; padding: 5px;">
			<%= LanguageUtil.format(pageContext, "step-x-of-x", new String[] {"2", String.valueOf(totalSteps)}) %>

			<liferay-ui:message key="choose-a-resource-or-proceed-to-the-next-step" />
		</div>

		<br />

		<div class="breadcrumbs">
			<%= breadcrumbs %>
		</div>

		<%= LanguageUtil.format(pageContext, "proceed-to-the-next-step-to-define-permissions-on-the-x-portlet-itself", portletResourceName) %>

		<br /><br />

		<input type="button" value="<liferay-ui:message key="next" />" onclick="self.location = '<%= portletURL.toString() %>&editPortletPermissions=1';" />

		<c:if test="<%= modelResources.size() > 0 %>">
			<br /><br />

			<liferay-ui:tabs names="resources" />

			<%= LanguageUtil.format(pageContext, "define-permissions-on-a-resource-that-belongs-to-the-x-portlet", portletResourceName) %>

			<br /><br />

			<%
			SearchContainer searchContainer = new SearchContainer();

			List headerNames = new ArrayList();

			headerNames.add("name");

			searchContainer.setHeaderNames(headerNames);

			Collections.sort(modelResources, new ModelResourceComparator(company.getCompanyId(), locale));

			List resultRows = searchContainer.getResultRows();

			for (int i = 0; i < modelResources.size(); i++) {
				String curModelResource = (String)modelResources.get(i);

				ResultRow row = new ResultRow(curModelResource, curModelResource, i);

				boolean selectable = true;

				if ((role.getType() != RoleImpl.TYPE_REGULAR) && ResourceActionsUtil.isPortalModelResource(curModelResource)) {
					selectable = false;
				}

				String help = StringPool.BLANK;

				PortletURL rowURL = null;

				if (selectable) {
					rowURL = renderResponse.createRenderURL();

					rowURL.setWindowState(WindowState.MAXIMIZED);

					rowURL.setParameter("struts_action", "/enterprise_admin/edit_role_permissions");
					rowURL.setParameter("roleId", String.valueOf(role.getRoleId()));
					rowURL.setParameter("portletResource", portletResource);
					rowURL.setParameter("modelResource", curModelResource);
				}
				else {
				    help = "&nbsp;(" + LanguageUtil.get(pageContext, "not-available-for-this-type-of-role") + ")";
				}

				// Name

				row.addText(ResourceActionsUtil.getModelResource(pageContext, curModelResource) + help, rowURL);

				// Add result row

				resultRows.add(row);
			}
			%>

			<liferay-ui:search-iterator searchContainer="<%= searchContainer %>" />
		</c:if>
	</c:when>
	<c:otherwise>

		<%
		List headerNames = new ArrayList();

		headerNames.add("portlet");

		SearchContainer searchContainer = new SearchContainer(renderRequest, null, null, SearchContainer.DEFAULT_CUR_PARAM, SearchContainer.DEFAULT_DELTA, portletURL, headerNames, null);

		List portlets = PortletLocalServiceUtil.getPortlets(company.getCompanyId(), false, false);

		Collections.sort(portlets, new PortletTitleComparator(application, locale));

		int total = portlets.size();

		searchContainer.setTotal(total);

		List results = ListUtil.subList(portlets, searchContainer.getStart(), searchContainer.getEnd());

		searchContainer.setResults(results);

		List resultRows = searchContainer.getResultRows();

		for (int i = 0; i < results.size(); i++) {
			Portlet portlet = (Portlet)results.get(i);

			ResultRow row = new ResultRow(portlet, portlet.getId(), i);

			PortletURL rowURL = renderResponse.createRenderURL();

			rowURL.setWindowState(WindowState.MAXIMIZED);

			rowURL.setParameter("struts_action", "/enterprise_admin/edit_role_permissions");
			rowURL.setParameter("roleId", String.valueOf(role.getRoleId()));
			rowURL.setParameter("portletResource", portlet.getPortletId());

			// Name

			row.addText(PortalUtil.getPortletTitle(portlet, application, locale), rowURL);

			// Add result row

			resultRows.add(row);
		}
		%>

		<div class="portlet-section-body" style="border: 1px solid <%= colorScheme.getPortletFontDim() %>; padding: 5px;">
			<%= LanguageUtil.format(pageContext, "step-x-of-x", new String[] {"1", String.valueOf(totalSteps)}) %>

			<liferay-ui:message key="choose-a-portlet" />
		</div>

		<br />

		<div class="breadcrumbs">
			<%= breadcrumbs %>
		</div>

		<liferay-ui:search-iterator searchContainer="<%= searchContainer %>" />
	</c:otherwise>
</c:choose>

</form>