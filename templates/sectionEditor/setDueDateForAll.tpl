{**
 * setDueDate.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Form to set the due date for a review.
 *
 * $Id$
 *}

<script type="text/javascript" src="http://localhost/camhrp-release1/camhrp/lib/pkp/js/lib/jquery/jquery.min.js"></script>
<script type="text/javascript" src="http://localhost/camhrp-release1/camhrp/lib/pkp/js/lib/jquery/plugins/jqueryUi.min.js"></script>

{strip}
{assign var="pageTitle" value="submission.dueDate"}
{include file="common/header.tpl"}
{/strip}

{literal}
<script type="text/javascript" src="http://localhost/camhrp/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"></script>
<style type="text/css" src="http://localhost/whorr/lib/pkp/styles/jquery-ui-timepicker-addon.css"></style>

<script type="text/javascript">
	$(document).ready(function() {
	$( "#dueDate" ).datepicker({changeMonth: true, dateFormat: 'yy-mm-dd', changeYear: true, minDate: '+0 d'});
	});
</script>
{/literal}

<div id="setDueDate">
<h3>Due Date for reviewers to review Proposal {$submission->getLocalizedWhoId()}</h3>

<p>{translate key="editor.article.designateDueDateDescription"}</p>

<form method="post" action="{url op=setDueDateForAll path=$articleId}">
	<table class="data" width="100%">
		<tr valign="top">
			<td class="label" width="20%">{translate key="editor.article.todaysDate"}</td>
			<td class="value" width="80%">{$todaysDate|escape}</td>
		</tr>
		<tr valign="top">
			<td class="label">{translate key="editor.article.requestedByDate"}</td>
			<td class="value">
				<input type="text" size="11" maxlength="10" name="dueDate" id="dueDate" value="{if $dueDate}{$dueDate|date_format:"%Y-%m-%d"}{/if}" class="textField" onfocus="this.form.numWeeks.value=''" />
				<span class="instruct">{translate key="editor.article.dueDateFormat"}</span>
			</td>
		</tr>
		{********************************************************************
		 * Set due date only by specifying date, not number of weeks
		 * Edited by aglet, ayveemallare
		 * Last Update: 6/3/2011, 6/30/2011
		<tr valign="top">
			<td>&nbsp;</td>
			<td class="value"><span class="instruct">{translate key="common.or"}</span></td>
		</tr>
		<tr valign="top">
			<td class="label">{translate key="editor.article.numberOfWeeks"}</td>
			<td class="value"><input type="text" name="numWeeks" value="{if not $dueDate}{$numWeeksPerReview|escape}{/if}" size="3" maxlength="2" class="textField" onfocus="this.form.dueDate.value=''" /></td>
		</tr>
		 *********************************************************************}
		 		
	</table>
<p><input type="submit" value="Set Due Date" class="button defaultButton" /> <input type="button" class="button" onclick="history.go(-1)" value="{translate key="common.cancel"}" /></p>
</form>
</div>
{include file="common/footer.tpl"}

