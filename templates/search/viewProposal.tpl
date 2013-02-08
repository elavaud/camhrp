
{strip}
{assign var=pageTitle value="search.summary"}
{include file="common/header.tpl"}
{/strip}

{if !$dateFrom}
{assign var="dateFrom" value="--"}
{/if}

{if !$dateTo}
{assign var="dateTo" value="--"}
{/if}

{assign var="cam" value="kh_CA"}
{assign var="eng" value="en_US"}

<br/>
<form name="revise" action="{url op="advanced"}" method="post">
	<input type="hidden" name="query" value="{$query|escape}"/>
	<div style="display:none">
		{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
		{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	</div>
</form>
<a href="javascript:document.revise.submit()" class="action">{translate key="search.reviseSearch"}</a>&nbsp;&nbsp;
<!--<a href="javascript:document.generate.submit()" class="action">| Export Search Results</a><br />-->
<form name="generate" action="{url op="generateCSV"}" method="post">
	<input type="hidden" name="query" value="{$query|escape}"/>
	<div style="display:none">
		{html_select_date prefix="dateFrom" time=$dateFrom all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
		{html_select_date prefix="dateTo" time=$dateTo all_extra="class=\"selectMenu\"" year_empty="" month_empty="" day_empty="" start_year="-5" end_year="+1"}
	</div>
</form>

<div id="authors">
<h4>{translate key="article.authors"}(s)</h4>
<table width="100%" class="data">
	<tr valign="top">
		<td width="50%">
			<table width="100%" class="data">
				{foreach name=authors from=$submission->getAuthors() item=author}
				<tr><td><br/></td></tr>
				<tr valign="top">
					<td width="40%" class="label">{translate key="user.name"}</td>
					<td width="60%" class="value">
						{assign var=emailString value=$author->getFullName()|concat:" <":$author->getEmail():">"}
						{url|assign:"url" page="user" op="email" redirectUrl=$currentUrl to=$emailString|to_array subject=$submission->getLocalizedTitle()|strip_tags articleId=$submission->getId()}
						{$author->getFullName()|escape} {icon name="mail" url=$url}
					</td>
				</tr>
				{if $author->getUrl()}
					<tr valign="top">
						<td class="label">{translate key="user.url"}</td>
						<td class="value"><a href="{$author->getUrl()|escape:"quotes"}">{$author->getUrl()|escape}</a></td>
					</tr>
				{/if}
				{if $author->getLocalizedAffiliation()}
				<tr valign="top">
					<td class="label">{translate key="user.affiliation"}</td>
					<td class="value">{$author->getAffiliation($eng)|escape|nl2br|default:"&mdash;"}</td>
				</tr>
				{/if}
				{if $author->getCountryLocalized()}
				<tr valign="top">
					<td class="label">{translate key="common.country"}</td>
					<td class="value">{$author->getCountryLocalized()|escape|default:"&mdash;"}</td>
				</tr>
				{/if}
				{/foreach}
			</table>
		</td>
		<td width="50%" align="center">
			{if $submission->getStatus() == 11}
				{foreach name="suppFiles" from=$suppFiles item=suppFile}
					{if $suppFile->getType() == "COMPLETION_REPORT"}
						<br/><a href="{url op="downloadFile" path=$submission->getArticleId()|to_array:$suppFile->getFileId()}" class="file"><b>{translate key="search.completionReport"}</b></a>
					{/if}
				{/foreach}
			{/if}
		</td>
	</tr>
</table>
</div>

<div id="titleAndAbstract">
<h4>{translate key="search.title"}</h4>

<table width="100%" class="data" id="title">
	<tr>
		<td width="20%" class="label"><br/>{translate key="article.scientificTitle"}</td>
		<td width="80%"><br/>{$submission->getLocalizedTitle()|strip_unsafe_html}</td>
	</tr>
</table>
<h4>{translate key="search.abstract"}</h4>
<table width="100%" class="data" id="abstract">
	<tr valign="top">
		<td width="20%" class="label"><br/>{translate key="search.background"}</td>
		<td width="80%" class="value"><br/>{$submission->getLocalizedBackground()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
	<tr valign="top">
		<td width="20%" class="label"><br/>{translate key="search.objectives"}</td>
		<td width="80%" class="value"><br/>{$submission->getLocalizedObjectives()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
	<tr valign="top">
		<td width="20%" class="label"><br/>{translate key="search.studyMatters"}</td>
		<td width="80%" class="value"><br/>{$submission->getLocalizedStudyMatters()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
	<tr valign="top">
		<td width="20%" class="label"><br/>{translate key="search.expectedOutcomes"}</td>
		<td width="80%" class="value"><br/>{$submission->getLocalizedExpectedOutcomes()|strip_unsafe_html|nl2br|default:"&mdash;"}</td>
	</tr>
</table>
<h4>{translate key="article.metadata"}</h4>
<table width="100%" class="data" id="metadata">
	<tr>
		<td width="20%" class="label"><br/>{translate key="common.status"}</td>
		<td width="80%"><br/>{if $submission->getStatus() == 11}{translate key="common.complete"}{else}{translate key="common.ongoing"}{/if}</td>
	</tr>
	<tr>
		<td width="20%" class="label">{translate key="common.id"}</td>
		<td width="80%">{$submission->getWhoId($eng)|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">{translate key="search.startDateAbr"}</td>
		<td class="value">{$submission->getStartDate($eng)|strip_unsafe_html}</td>
	</tr>
	<tr>
		<td class="label">{translate key="search.endDateAbr"}</td>
		<td class="value">{$submission->getEndDate($eng)|strip_unsafe_html}</td>
	</tr>
	
	{if $submission->getLocalizedMultiCountryResearch() == "Yes"}
	<tr>
		<td class="label">{translate key="search.multiCountry"}</td>
		<td class="value">{$submission->getLocalizedMultiCountryText()}</td>
	</tr>
	{/if}
	<tr>
		<td class="label">{translate key='proposal.proposalCountry'}</td>
		<td class="value">{$submission->getLocalizedProposalCountryText()}</td>
	</tr>
    <tr valign="top">
        <td class="label">{translate key="proposal.withHumanSubjects"}</td>
        <td class="value">
        	{if ($submission->getWithHumanSubjects($eng)) == "Yes"}
        		{translate key="common.yes"}
        	{else}
        		{translate key="common.no"}
        	{/if}
        </td>
    </tr>
    {if ($submission->getWithHumanSubjects($eng)) == "Yes"}
    <tr valign="top">
        <td class="label">&nbsp;</td>
        <td class="value">{$submission->getLocalizedProposalTypeText()}</td>
    </tr>
    {/if}
    <tr valign="top">
        <td class="label">{translate key="proposal.researchField"}</td>
        <td class="value">{$submission->getLocalizedResearchFieldText()}</td>
    </tr>
    
    <tr valign="top">
        <td class="label">{translate key="proposal.primarySponsor"}</td>
        <td class="value">
        	{if $submission->getPrimarySponsor($eng)}
        		{$submission->getLocalizedPrimarySponsorText()}
        	{/if}
        </td>
    </tr>
    {if $submission->getSecondarySponsors($eng)}
    <tr valign="top">
        <td class="label" width="20%">{translate key="proposal.secondarySponsors"}</td>
        <td class="value">
        	{if $submission->getLocalizedSecondarySponsors()}
        		{$submission->getLocalizedSecondarySponsorText()}
        	{/if}        
        </td>
    </tr>
    {/if}

</table>
</div>

{include file="common/footer.tpl"}

