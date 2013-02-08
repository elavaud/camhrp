{**
* submissionsReport.tpl
*
* Generate report - meeting attendance 
**}

{strip}
{assign var="pageTitle" value="editor.reports.reportGenerator"}
{assign var="pageCrumbTitle" value="editor.reports.submissions"}
{include file="common/header.tpl"}

{/strip}
<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
{literal}<script type="text/javascript">
$(document).ready(function() {
		hideSubmissionCheckboxes();
		hideAuthorCheckboxes();
		hideProposalDetailsCheckboxes();
		hideSourceOfMonetaryCheckboxes();
		hideRiskAssessmentCheckboxes()
        //Restrict end date to (start date) + 1
        $( "#startDateBefore" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', onSelect: function(dateText, inst){
            		dayAfter = new Date();
                    dayAfter = $("#startDateBefore").datepicker("getDate");
                    dayAfter.setDate(dayAfter.getDate() + 1);
                    $("#endDateBefore").datepicker("option","minDate", dayAfter)
                }
        	}
        );
            
        $( "#endDateBefore" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy'
        	}
        );
        
        $( "#startDateAfter" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', onSelect: function(dateText, inst){
            		dayAfter = new Date();
                    dayAfter = $("#startDateAfter").datepicker("getDate");
                    dayAfter.setDate(dayAfter.getDate() + 1);
                    $("#endDateAfter").datepicker("option","minDate", dayAfter)
                }
            }
        );  
            
        $( "#endDateAfter" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy'
        	}
        );
        
        $( "#submittedBefore" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, maxDate: '0', dateFormat: 'dd-M-yy', onSelect: function(dateText, inst){
            		dayAfter = new Date();
                    dayAfter = $("#submittedBefore").datepicker("getDate");
                    dayAfter.setDate(dayAfter.getDate() + 1);
                    $("#approvedBefore").datepicker("option","minDate", dayAfter)
                }
            }
        );
        
        $( "#approvedBefore" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', maxDate: '0', onSelect: function(){
        			showProposalDetails();
        			$('.decisionField').remove();
        			$('#decisions').val('editor.article.decision.accept');
        		}
        	}
        );
        
        $( "#submittedAfter" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, maxDate: '-1 d', dateFormat: 'dd-M-yy', onSelect: function(dateText, inst){
            		dayAfter = new Date();
                    dayAfter = $("#submittedAfter").datepicker("getDate");
                    dayAfter.setDate(dayAfter.getDate() + 1);
                    $("#approvedAfter").datepicker("option","minDate", dayAfter)
                }
            }
        );

        $( "#approvedAfter" ).datepicker(
        	{
        		changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', maxDate: '-1 d', onSelect: function(){
        			showProposalDetails();
        			$('.decisionField').remove();
        			$('#decisions').val('editor.article.decision.accept');
        		}
        	}
        );
        
        $('#decisions').change(function(){
        	if ($('#decisions').val() != 'editor.article.decision.accept') {
        		if ($('#approvedAfter').val() != "" || $('#approvedBefore').val() != ""){
        			$('#approvedAfter').val("");
        			$('#approvedBefore').val("");
        		}
        	}
        });
        
        //Start code for multiple decisions
        $('#addAnotherDecision').click(
        	function(){
       			var decisionHtml = '<tr valign="top" class="decisionField">' + $('#firstDecision').html() + '</tr>';
            	$('#firstDecision').after(decisionHtml);
        		$('#firstDecision').next().find('select').attr('selectedIndex', 0);
        		$('.decisionField').find('.removeDecision').show();
        		$('.decisionField').find('.decisionTitle').hide();
        		$('.decisionField').find('.noDecisionTitle').show();
        		$('#firstDecision').find('.removeDecision').hide();
        		$('#firstDecision').find('.decisionTitle').show();
        		$('#firstDecision').find('.noDecisionTitle').hide();
        		if ($('#approvedAfter').val() != "" || $('#approvedBefore').val() != ""){
        			$('#approvedAfter').val("");
        			$('#approvedBefore').val("");
        		}
            	return false;
        	}
    	);

        $('.removeDecision').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
        
        //Start code for multiple primary sponsor
        $('#addAnotherPrimarySponsor').click(
        	function(){
       			var primarySponsorHtml = '<tr valign="top" class="primarySponsorField">' + $('#firstPrimarySponsor').html() + '</tr>';
            	$('#firstPrimarySponsor').after(primarySponsorHtml);
        		$('#firstPrimarySponsor').next().find('select').attr('selectedIndex', 0);
        		$('.primarySponsorField').find('.removePrimarySponsor').show();
        		$('.primarySponsorField').find('.primarySponsorTitle').hide();
        		$('.primarySponsorField').find('.noPrimarySponsorTitle').show();
        		$('#firstPrimarySponsor').find('.removePrimarySponsor').hide();
        		$('#firstPrimarySponsor').find('.primarySponsorTitle').show();
        		$('#firstPrimarySponsor').find('.noPrimarySponsorTitle').hide();
            	return false;
        	}
    	);

        $('.removePrimarySponsor').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
        
        //Start code for multiple primary sponsor
        $('#addAnotherSecondarySponsor').click(
        	function(){
       			var secondarySponsorHtml = '<tr valign="top" class="secondarySponsorField">' + $('#firstSecondarySponsor').html() + '</tr>';
            	$('#firstSecondarySponsor').after(secondarySponsorHtml);
        		$('#firstSecondarySponsor').next().find('select').attr('selectedIndex', 0);
        		$('.secondarySponsorField').find('.removeSecondarySponsor').show();
        		$('.secondarySponsorField').find('.secondarySponsorTitle').hide();
        		$('.secondarySponsorField').find('.noSecondarySponsorTitle').show();
        		$('#firstSecondarySponsor').find('.removeSecondarySponsor').hide();
        		$('#firstSecondarySponsor').find('.secondarySponsorTitle').show();
        		$('#firstSecondarySponsor').find('.noSecondarySponsorTitle').hide();
            	return false;
        	}
    	);

        $('.removeSecondarySponsor').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
        
        //Start code for multiple research Field
        $('#addAnotherResearchField').click(
        	function(){
       			var researchFieldHtml = '<tr valign="top" class="researchFieldField">' + $('#firstResearchField').html() + '</tr>';
            	$('#firstResearchField').after(researchFieldHtml);
        		$('#firstResearchField').next().find('select').attr('selectedIndex', 0);
        		$('.researchFieldField').find('.removeResearchField').show();
        		$('.researchFieldField').find('.researchFieldTitle').hide();
        		$('.researchFieldField').find('.noResearchFieldTitle').show();
        		$('#firstResearchField').find('.removeResearchField').hide();
        		$('#firstResearchField').find('.researchFieldTitle').show();
        		$('#firstResearchField').find('.noResearchFieldTitle').hide();
            	return false;
        	}
    	);

        $('.removeResearchField').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
        
                
        //Start code for multiple proposal type
        $('#addAnotherProposalType').click(
        	function(){
       			var proposalTypeHtml = '<tr valign="top" class="proposalTypeField">' + $('#firstProposalType').html() + '</tr>';
            	$('#firstProposalType').after(proposalTypeHtml);
        		$('#firstProposalType').next().find('select').attr('selectedIndex', 0);
        		$('.proposalTypeField').find('.removeProposalType').show();
        		$('.proposalTypeField').find('.proposalTypeTitle').hide();
        		$('.proposalTypeField').find('.noProposalTypeTitle').show();
        		$('#firstProposalType').find('.removeProposalType').hide();
        		$('#firstProposalType').find('.proposalTypeTitle').show();
        		$('#firstProposalType').find('.noProposalTypeTitle').hide();
            	return false;
        	}
    	);

        $('.removeProposalType').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
        
        //Start code for multiple provinces
        $('#addAnotherProvince').click(
        	function(){
       			var provinceHtml = '<tr valign="top" class="provinceField">' + $('#firstProvince').html() + '</tr>';
            	$('#firstProvince').after(provinceHtml);
        		$('#firstProvince').next().find('select').attr('selectedIndex', 0);
        		$('.provinceField').find('.removeProvince').show();
        		$('.provinceField').find('.provinceTitle').hide();
        		$('.provinceField').find('.noProvinceTitle').show();
        		$('#firstProvince').find('.removeProvince').hide();
        		$('#firstProvince').find('.provinceTitle').show();
        		$('#firstProvince').find('.noProvinceTitle').hide();
            	return false;
        	}
    	);

        $('.removeProvince').live(
        	'click', function(){
        		$(this).closest('tr').remove();
        		return false;
        	}
        );
});

function hideProposalDetails(){
	$('.decisionField').remove();
	$('.primarySponsorField').remove();
	$('.secondarySponsorField').remove();
	$('.researchFieldField').remove();
	$('.proposalTypeField').remove();
	
	$('#proposalDetails').hide();
	$('#academicDegreeField').hide();
	$('#showProposalDetails').show();
	
	$('#ercnioph').removeAttr('checked');
	$('#ercuhs').removeAttr('checked');
	$('#studentResearchy').removeAttr('checked');
	$('#studentResearchn').removeAttr('checked');
	
	$('#decisions').val("");
	$('#academicDegree').val("");
	$('#primarySponsors').val("");
	$('#secondarySponsors').val("");
	$('#researchFields').val("");
	$('#proposalTypes').val("");
	$('#dataCollection').val("");
	
	if ($('#approvedAfter').val() != "" || $('#approvedBefore').val() != ""){
    	$('#approvedAfter').val("");
        $('#approvedBefore').val("");
    }
}

function showProposalDetails(){
	$('#proposalDetails').show();
	$('#showProposalDetails').hide();	
}

function hideGeographicalAreas(){
	document.getElementById('firstProvince').style.display = 'none';
	document.getElementById('addAnotherProvince').style.display = 'none';
	$('#geographicalAreas').hide();
	$('.provinceField').remove();
	$('#showGeographicalAreas').show();
	$('#multicountryy').removeAttr('checked');
	$('#multicountryn').removeAttr('checked');
	$('#provinces').val("");
}

function showGeographicalAreas(){
	$('#geographicalAreas').show();
	$('#showGeographicalAreas').hide();	
}

function hideDates(){

	$('#dates').hide();
	$('#showDates').show();
	
	$('#researchDates').hide();
	$('#reviewDates').hide();

	$('#showResearchDates').show();
	$('#hideResearchDates').hide();

	$('#showReviewDates').show();
	$('#hideReviewDates').hide();
	
	$('#startDateBefore').val("");
	$('#startDateAfter').val("");
	$('#endDateBefore').val("");
	$('#endDateAfter').val("");
	
	$('#submittedBefore').val("");
	$('#submittedAfter').val("");
	$('#approvedBefore').val("");
	$('#approvedAfter').val("");
}

function showDates(){
	$('#dates').show();
	$('#showDates').hide();	
}

function showResearchDates(){
	$('#showResearchDates').hide();
	$('#researchDates').show();
	$('#hideResearchDates').show();	
}

function hideResearchDates(){
	$('#showResearchDates').show();
	$('#researchDates').hide();
	$('#hideResearchDates').hide();
	$('#startDateBefore').val("");
	$('#startDateAfter').val("");
	$('#endDateBefore').val("");
	$('#endDateAfter').val("");
}

function showReviewDates(){
	$('#showReviewDates').hide();
	$('#reviewDates').show();
	$('#hideReviewDates').show();	
}

function hideReviewDates(){
	$('#showReviewDates').show();
	$('#reviewDates').hide();
	$('#hideReviewDates').hide();
	$('#submittedBefore').val("");
	$('#submittedAfter').val("");
	$('#approvedBefore').val("");
	$('#approvedAfter').val("");
}

function showOrHideProvince(value){
	if (value == 'No'){
		document.getElementById('firstProvince').style.display = '';
		document.getElementById('addAnotherProvince').style.display = '';
	} else {
		document.getElementById('firstProvince').style.display = 'none';
		document.getElementById('addAnotherProvince').style.display = 'none';
		$('.provinceField').remove();
		$('#provinces').val("");
	}
}

function showOrHideAcademicDegreeField(value){
	if (value == 'Yes') {
		document.getElementById('academicDegreeField').style.display = '';	
	} else {
		document.getElementById('academicDegreeField').style.display = 'none';
		$('#academicDegree').val("");
	}
}

function submissionCheckAll(){
	$('.checkSubmission').attr('checked','checked');
}

function submissionUncheckAll(){
	$('.checkSubmission').removeAttr('checked');
}

function investigatorCheckAll(){
	$('.checkInvestigator').attr('checked','checked');
}

function investigatorUncheckAll(){
	$('.checkInvestigator').removeAttr('checked');
}

function detailsCheckAll(){
	$('.checkDetails').attr('checked','checked');
}

function detailsUncheckAll(){
	$('.checkDetails').removeAttr('checked');
}

function monetaryCheckAll(){
	$('.checkMonetary').attr('checked','checked');
}

function monetaryUncheckAll(){
	$('.checkMonetary').removeAttr('checked');
}

function riskCheckAll(){
	$('.checkRisk').attr('checked','checked');
}

function riskUncheckAll(){
	$('.checkRisk').removeAttr('checked');
}

function hideSubmissionCheckboxes(){
	$('#submission').hide();
	$('#hideSubmissionCheckboxes').hide();
	$('#showSubmissionCheckboxes').show();
}

function showSubmissionCheckboxes(){
	$('#submission').show();
	$('#hideSubmissionCheckboxes').show();
	$('#showSubmissionCheckboxes').hide();
}

function hideAuthorCheckboxes(){
	$('#author').hide();
	$('#hideAuthorCheckboxes').hide();
	$('#showAuthorCheckboxes').show();
}

function showAuthorCheckboxes(){
	$('#author').show();
	$('#hideAuthorCheckboxes').show();
	$('#showAuthorCheckboxes').hide();
}

function hideProposalDetailsCheckboxes(){
	$('#metadata').hide();
	$('#hideProposalDetailsCheckboxes').hide();
	$('#showProposalDetailsCheckboxes').show();
}

function showProposalDetailsCheckboxes(){
	$('#metadata').show();
	$('#hideProposalDetailsCheckboxes').show();
	$('#showProposalDetailsCheckboxes').hide();
}

function hideSourceOfMonetaryCheckboxes(){
	$('#sourceOfMonetary').hide();
	$('#hideSourceOfMonetaryCheckboxes').hide();
	$('#showSourceOfMonetaryCheckboxes').show();
}

function showSourceOfMonetaryCheckboxes(){
	$('#sourceOfMonetary').show();
	$('#hideSourceOfMonetaryCheckboxes').show();
	$('#showSourceOfMonetaryCheckboxes').hide();
}

function hideRiskAssessmentCheckboxes(){
	$('#riskAssessment').hide();
	$('#hideRiskAssessmentCheckboxes').hide();
	$('#showRiskAssessmentCheckboxes').show();
}

function showRiskAssessmentCheckboxes(){
	$('#riskAssessment').show();
	$('#hideRiskAssessmentCheckboxes').show();
	$('#showRiskAssessmentCheckboxes').hide();
}

</script>
<style type="text/css">
	.checkboxes tr {
		height : 30px;
		width : 700px;
	 }
	 .checkboxes input{
	 	margin-top: 0px;
		width: 15px;
    	height: 15px;
    	float: left;
	 }
	 .checkboxes label{
	 	float: left;
	 	padding-left: 15px;
	 	margin-top: 10px;
	 	font-size: 11px;
	 } 
</style>
{/literal}
<!--
<ul class="menu">
	<li><a href="{url op="submissionsReport"}">{translate key="editor.reports.submissions"}</a></li>
	<li class="current"><a href="{url op="meetingAttendanceReport"}">{translate key="editor.reports.meetingAttendance"}</a></li>
</ul>
<div class="separator"></div>
<h2>{translate key="editor.reports.submissions"}</h2>
-->
{include file="common/formErrors.tpl"}

<div id="submissionsReport">
<form method="post" action="{url op="submissionsReport"}">

	{if !$dateFrom}
	{assign var="dateFrom" value="--"}
	{/if}
	
	{if !$dateTo}
	{assign var="dateTo" value="--"}
	{/if}

<h5>{translate key="editor.metadataExport"}</h5>
<h4><a href="#submissionCheckboxes" onclick="hideSubmissionCheckboxes()" class="action" id="hideSubmissionCheckboxes">{translate key="article.submission"}</a></h4>
<h4><a href="#submissionCheckboxes" onclick="showSubmissionCheckboxes()" class="action" id="showSubmissionCheckboxes">{translate key="article.submission"}</a></h4>
<a name="submissionCheckboxes"></a>
<div id="submission">
<table width="100%" class="data">
	<tr valign="top">
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
	</tr>
	<tr>
		<td colspan="4" align="right"><a href="javascript:void(0)" onclick="submissionCheckAll()" id="submissionCheckAll">{translate key="editor.reports.checkAll"}</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:void(0)" onclick="submissionUncheckAll()" id="submissionUncheckAll">{translate key="editor.reports.uncheckAll"}</a></td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkProposalId" class="checkSubmission" checked="checked"/>&nbsp;{translate key="common.id"}</td>
		<td><input type="checkbox" name="checkDateApproved" class="checkSubmission"/>&nbsp;{translate key="common.approvalDate"}</td>
		<td><input type="checkbox" name="checkDecision" class="checkSubmission" checked="checked"/>&nbsp;{translate key="common.status"}</td>
		<td><input type="checkbox" name="checkDateSubmitted" class="checkSubmission"/>&nbsp;{translate key="common.dateSubmitted"}</td>
	</tr>
</table>
</div>
<h4><a href="#authorCheckboxes" onclick="hideAuthorCheckboxes()" class="action" id="hideAuthorCheckboxes">{translate key="editor.reports.author"}</a></h4>
<h4><a href="#authorCheckboxes" onclick="showAuthorCheckboxes()" class="action" id="showAuthorCheckboxes">{translate key="editor.reports.author"}</a></h4>
<a name="authorCheckboxes"></a>
<div id="author">
<table width="100%" class="data">
	<tr valign="top">
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
	</tr>
	<tr>
		<td colspan="4" align="right"><a href="javascript:void(0)" onclick="investigatorCheckAll()" id="investigatorCheckAll">{translate key="editor.reports.checkAll"}</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:void(0)" onclick="investigatorUncheckAll()" id="investigatorUncheckAll">{translate key="editor.reports.uncheckAll"}</a></td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkName" class="checkInvestigator" checked="checked"/>&nbsp;{translate key="common.fullName"}</td>
		<td><input type="checkbox" name="checkAffiliation" class="checkInvestigator" checked="checked"/>&nbsp;{translate key="user.affiliation"}</td>
		<td><input type="checkbox" name="checkEmail" class="checkInvestigator"/>&nbsp;{translate key="user.email"}</td>
	</tr>
</table>
</div>
<h4><a href="#proposalDetailsCheckboxes" onclick="hideProposalDetailsCheckboxes()" class="action" id="hideProposalDetailsCheckboxes">{translate key="submission.proposalDetails"}</a></h4>
<h4><a href="#proposalDetailsCheckboxes" onclick="showProposalDetailsCheckboxes()" class="action" id="showProposalDetailsCheckboxes">{translate key="submission.proposalDetails"}</a></h4>
<a name="proposalDetailsCheckboxes"></a>
<div id="metadata">
<table width="100%" class="data">
	<tr valign="top">
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
	</tr>
	<tr>
		<td colspan="4" align="right"><a href="javascript:void(0)" onclick="detailsCheckAll()" id="detailsCheckAll">{translate key="editor.reports.checkAll"}</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:void(0)" onclick="detailsUncheckAll()" id="detailsUncheckAll">{translate key="editor.reports.uncheckAll"}</a></td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkEngScientificTitle" class="checkDetails" checked="checked"/>&nbsp;{translate key="proposal.engScientificTitle"}</td>
		<td><input type="checkbox" name="checkCamScientificTitle" class="checkDetails"/>&nbsp;{translate key="proposal.camScientificTitle"}</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkPrimarySponsor" class="checkDetails" checked="checked"/>&nbsp;{translate key="proposal.primarySponsor"}</td>
		<td><input type="checkbox" name="checkSecondarSponsor" class="checkDetails" checked="checked"/>&nbsp;{translate key="proposal.secondarySponsors"}</td>
		<td><input type="checkbox" name="checkResearchFields" class="checkDetails" checked="checked"/>&nbsp;{translate key="proposal.researchField"}</td>
		<td><input type="checkbox" name="checkProposalTypes" class="checkDetails" checked="checked"/>&nbsp;{translate key="proposal.proposalType"}</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkArea" class="checkDetails" checked="checked"/>&nbsp;{translate key="proposal.proposalCountry"}</td>
		<td><input type="checkbox" name="checkDataCollection" class="checkDetails" checked="checked"/>&nbsp;{translate key="proposal.dataCollection"}</td>	
		<td><input type="checkbox" name="checkErcReview" class="checkDetails" checked="checked"/>&nbsp;{translate key="proposal.reviewedByOtherErc"}</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkDuration" class="checkDetails" checked="checked"/>&nbsp;{translate key="search.researchDates"}</td>
		<td><input type="checkbox" name="checkStudentResearch" class="checkDetails"/>&nbsp;{translate key="proposal.studentInitiatedResearch"}</td>
	</tr>
</table>
</div>
<h4><a href="#sourceOfMonetaryCheckboxes" onclick="hideSourceOfMonetaryCheckboxes()" class="action" id="hideSourceOfMonetaryCheckboxes">{translate key="proposal.sourceOfMonetary"}</a></h4>
<h4><a href="#sourceOfMonetaryCheckboxes" onclick="showSourceOfMonetaryCheckboxes()" class="action" id="showSourceOfMonetaryCheckboxes">{translate key="proposal.sourceOfMonetary"}</a></h4>
<a name="sourceOfMonetaryCheckboxes"></a>
<div id="sourceOfMonetary">
<table width="100%" class="data">
	<tr valign="top">
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
	</tr>
	<tr>
		<td colspan="4" align="right"><a href="javascript:void(0)" onclick="monetaryCheckAll()" id="monetaryCheckAll">{translate key="editor.reports.checkAll"}</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:void(0)" onclick="monetaryUncheckAll()" id="monetaryUncheckAll">{translate key="editor.reports.uncheckAll"}</a></td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkBudget" class="checkDetails" checked="checked"/>&nbsp;{translate key="proposal.fundsRequired"}</td>
		<td><input type="checkbox" name="checkIndustryGrant" class="checkMonetary"/>&nbsp;{translate key="proposal.industryGrant"}</td>
		<td><input type="checkbox" name="checkAgencyGrant" class="checkMonetary"/>&nbsp;{translate key="proposal.internationalGrant"}</td>
		<td><input type="checkbox" name="checkMohGrant" class="checkMonetary"/>&nbsp;{translate key="proposal.mohGrant"}</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkGovernmentGrant" class="checkMonetary"/>&nbsp;{translate key="proposal.governmentGrant"}</td>
		<td><input type="checkbox" name="checkUniversityGrant" class="checkMonetary"/>&nbsp;{translate key="proposal.universityGrant"}</td>
		<td><input type="checkbox" name="checkSelfFunding" class="checkMonetary"/>&nbsp;{translate key="proposal.selfFunding"}</td>
		<td><input type="checkbox" name="checkOtherGrant" class="checkMonetary"/>&nbsp;{translate key="proposal.otherGrant"}</td>
	</tr>
</table>
</div>
<h4><a href="#riskAssessmentCheckboxes" onclick="hideRiskAssessmentCheckboxes()" class="action" id="hideRiskAssessmentCheckboxes">{translate key="proposal.riskAssessment"}</a></h4>
<h4><a href="#riskAssessmentCheckboxes" onclick="showRiskAssessmentCheckboxes()" class="action" id="showRiskAssessmentCheckboxes">{translate key="proposal.riskAssessment"}</a></h4>
<a name="riskAssessmentCheckboxes"></a>
<div id="riskAssessment">
<table width="100%" class="data">
	<tr valign="top">
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
		<td width="25%"></td>
	</tr>
	<tr>
		<td colspan="4" align="right"><a href="javascript:void(0)" onclick="riskCheckAll()" id="riskCheckAll">{translate key="editor.reports.checkAll"}</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="javascript:void(0)" onclick="riskUncheckAll()" id="riskUncheckAll">{translate key="editor.reports.uncheckAll"}</a></td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkIdentityRevealed" class="checkRisk"/>&nbsp;{translate key="proposal.identityRevealedAbb"}</td>
		<td><input type="checkbox" name="checkUnableToConsent" class="checkRisk"/>&nbsp;{translate key="proposal.unableToConsentAbb"}</td>
		<td><input type="checkbox" name="checkUnder18" class="checkRisk"/>&nbsp;{translate key="proposal.under18Abb"}</td>
		<td><input type="checkbox" name="checkDependentRelationship" class="checkRisk"/>&nbsp;{translate key="proposal.dependentRelationshipAbb"}</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkEthnicMinority" class="checkRisk"/>&nbsp;{translate key="proposal.ethnicMinorityAbb"}</td>
		<td><input type="checkbox" name="checkImpairment" class="checkRisk"/>&nbsp;{translate key="proposal.impairmentAbb"}</td>
		<td><input type="checkbox" name="checkPregnant" class="checkRisk"/>&nbsp;{translate key="proposal.pregnantAbb"}</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkNewTreatment" class="checkRisk"/>&nbsp;{translate key="proposal.newTreatmentAbb"}</td>
		<td><input type="checkbox" name="checkBioSamples" class="checkRisk"/>&nbsp;{translate key="proposal.bioSamplesAbb"}</td>
		<td><input type="checkbox" name="checkRadiation" class="checkRisk"/>&nbsp;{translate key="proposal.radiationAbb"}</td>
		<td><input type="checkbox" name="checkDistress" class="checkRisk"/>&nbsp;{translate key="proposal.distressAbb"}</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkInducements" class="checkRisk"/>&nbsp;{translate key="proposal.inducementsAbb"}</td>
		<td><input type="checkbox" name="checkSensitiveInfo" class="checkRisk"/>&nbsp;{translate key="proposal.sensitiveInfoAbb"}</td>
		<td><input type="checkbox" name="checkDeception" class="checkRisk"/>&nbsp;{translate key="proposal.deceptionAbb"}</td>
		<td><input type="checkbox" name="checkReproTechnology" class="checkRisk"/>&nbsp;{translate key="proposal.reproTechnologyAbb"}</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkGenetics" class="checkRisk"/>&nbsp;{translate key="proposal.geneticsAbb"}</td>
		<td><input type="checkbox" name="checkStemCell" class="checkRisk"/>&nbsp;{translate key="proposal.stemCellAbb"}</td>
		<td><input type="checkbox" name="checkBiosafety" class="checkRisk"/>&nbsp;{translate key="proposal.biosafetyAbb"}</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkRiskLevel" class="checkRisk"/>&nbsp;{translate key="proposal.riskLevelAbb"}</td>
		<td><input type="checkbox" name="checkRiskApplyTo" class="checkRisk"/>&nbsp;{translate key="proposal.riskApplyToAbb"}</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="checkBenefitsFromTheProject" class="checkRisk"/>&nbsp;{translate key="proposal.benefitsFromTheProjectAbb"}</td>
		<td><input type="checkbox" name="checkMultiInstitutions" class="checkRisk"/>&nbsp;{translate key="proposal.multiInstitutionsAbb"}</td>
		<td><input type="checkbox" name="checkConflictOfInterest" class="checkRisk"/>&nbsp;{translate key="proposal.conflictOfInterestAbb"}</td>
	</tr>
</table>
</div>
<br/>
<h5>{translate key="editor.reports.filterBy"}</h5>
<a name="proposal"></a>
<table width="100%" class="data" id="proposalDetails" style="display:none">
	<tr valign="top">
		<td width="5%"></td>
		<td width="3%"></td>
		<td width="17%"></td>
		<td width="5%"></td>
		<td width="70%"></td>
	</tr>
	<tr><td colspan="5"><h4><a href="#proposal" onclick="hideProposalDetails()" class="action" id="hideProposalDetails">{translate key="submission.proposalDetails"}</a></h4></td></tr>

	<tr valign="top" id="firstDecision" class="decision">
		<td>&nbsp;</td>
		<td colspan="2" class="decisionTitle">{translate key="editor.reports.filterBy.decisions"}</td>
		<td colspan="2" class="noDecisionTitle" style="display: none;" align="right">{translate key="editor.reports.orCap"}&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">			
			<select name="decisions[]" id="decisions" class="selectMenu">
				<option value=""></option>
		 		{html_options_translate options=$decisionsOptions selected=$decisions}
			</select>
			<a href="" class="removeDecision" style="display:none">{translate key="editor.article.remove"}</a>
		</td>
	</tr>
	
    <tr id="addAnotherDecision">
    	<td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherDecision">{translate key="editor.reports.filterBy.addAnotherdecision"}</a></td>
    </tr>	

	<tr valign="top">
		<td>&nbsp;</td>
		<td colspan="2">{translate key="proposal.studentInitiatedResearch"}</td>
		<td colspan="2">
        	<input type="radio" name="studentResearch" id="studentResearchy" value="Yes" onclick="showOrHideAcademicDegreeField(this.value)"/>{translate key="common.yes"}
            &nbsp;&nbsp;&nbsp;&nbsp;
        	<input type="radio" name="studentResearch" id="studentResearchn" value="No" onclick="showOrHideAcademicDegreeField(this.value)"/>{translate key="common.no"}
        </td>
	</tr>
	<tr valign="top" id="academicDegreeField" style="display: none;">
		<td colspan="2">&nbsp;</td>
		<td>{translate key="editor.reports.studentAcademicDegree"}</td>
		<td colspan="2">
			<select name="academicDegree" id="academicDegree" class="selectMenu">
				<option value=""></option>
				<option value="Undergraduate">{translate key="editor.reports.undergraduate"}</option>
				<option value="Master">{translate key="editor.reports.master"}</option>
				<option value="Post-Doc">{translate key="editor.reports.postDoc"}</option>
				<option value="Ph.D">{translate key="editor.reports.phd"}</option>
				<option value="Other">{translate key="editor.reports.other"}</option>
			</select>
        </td>
	</tr>
	<tr valign="top" id="firstPrimarySponsor" class="primarySponsor">
		<td>&nbsp;</td>
		<td colspan="2" class="primarySponsorTitle">{translate key="editor.reports.primarySponsor"}</td>
		<td colspan="2" class="noPrimarySponsorTitle" style="display: none;" align="right">{translate key="editor.reports.orCap"}&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">			
        	<select name="primarySponsors[]" id="primarySponsors" class="selectMenu">
                <option value=""></option>
                {foreach from=$agencies key=id item=sponsor}
                	{if $sponsor.code != "NA"}
                        <option value="{$sponsor.code}">{$sponsor.name}</option>
                    {/if}
                {/foreach}
            </select>
            <a href="" class="removePrimarySponsor" style="display:none">{translate key="editor.article.remove"}</a>
		</td>
	</tr>
    <tr id="addAnotherPrimarySponsor">
    	<td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherPrimarySponsor">{translate key="editor.reports.filterBy.addAnotherPSponsor"}</a></td>
    </tr>
    
	<tr valign="top" id="firstSecondarySponsor" class="secondarySponsor">
		<td>&nbsp;</td>
		<td colspan="2" class="secondarySponsorTitle">{translate key="editor.reports.secondarySponsor"}</td>
		<td colspan="2" class="noSecondarySponsorTitle" style="display: none;" align="right">{translate key="editor.reports.orCap"}&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">			
        	<select name="secondarySponsors[]" id="secondarySponsors" class="selectMenu">
                <option value=""></option>
                {foreach from=$agencies key=id item=sponsor}
                	{if $sponsor.code != "NA"}
                        <option value="{$sponsor.code}">{$sponsor.name}</option>
                    {/if}
                {/foreach}
            </select>
            <a href="" class="removeSecondarySponsor" style="display:none">{translate key="editor.article.remove"}</a>
		</td>
	</tr>
	<tr id="addAnotherSecondarySponsor">
    	<td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherSecondarySponsor">{translate key="editor.reports.filterBy.addAnotherSSponsor"}</a></td>
    </tr>
    
	<tr valign="top" id="firstResearchField" class="researchField">
		<td>&nbsp;</td>
		<td colspan="2" class="researchFieldTitle">{translate key="editor.reports.researchField"}</td>
		<td colspan="2" class="noResearchFieldTitle" style="display: none;" align="right">{translate key="editor.reports.orCap"}&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">			
        	<select name="researchFields[]" id="researchFields" class="selectMenu">
                <option value=""></option>
                {foreach from=$researchFields key=id item=rfield}
                	{if $rfield.code != "NA"}
                        <option value="{$rfield.code}">{$rfield.name}</option>
                    {/if}
                {/foreach}
            </select>
            <a href="" class="removeResearchField" style="display:none">{translate key="editor.article.remove"}</a>
		</td>
	</tr>
    <tr id="addAnotherResearchField">
    	<td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherResearchField">{translate key="editor.reports.filterBy.addAnotherRField"}</a></td>
    </tr>
    
	<tr valign="top" id="firstProposalType" class="proposalType">
		<td>&nbsp;</td>
		<td colspan="2" class="proposalTypeTitle">{translate key="editor.reports.proposalType"}</td>
		<td colspan="2" class="noProposalTypeTitle" style="display: none;" align="right">{translate key="editor.reports.orCap"}&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">			
        	<select name="proposalTypes[]" id="proposalTypes" class="selectMenu">
                <option value=""></option>
                <option value="PNHS">{translate key="editor.reports.proposalType.pnhs"}</option>
                {foreach from=$proposalTypes key=id item=ptype}
                	{if $ptype.code != "NA"}
                        <option value="{$ptype.code}">{$ptype.name}</option>
                    {/if}
                {/foreach}
            </select>
            <a href="" class="removeProposalType" style="display:none">{translate key="editor.article.remove"}</a>
		</td>
	</tr>
    <tr id="addAnotherProposalType">
    	<td>&nbsp;</td>
        <td colspan="2">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherProposalType">{translate key="editor.reports.filterBy.addAnotherPType"}</a></td>
    </tr>
    
	<tr valign="top">
		<td>&nbsp;</td>
		<td colspan="2">{translate key="editor.reports.dataCollection"}</td>
		<td colspan="2">
			<select name="dataCollection" id="dataCollection" class="selectMenu">
            	<option value=""></option>
            	<option value="Primary">{translate key="editor.reports.primaryDC"}</option>
            	<option value="Secondary">{translate key="editor.reports.secondaryDC"}</option>
            	<option value="Both">{translate key="editor.reports.bothDC"}</option>
			</select>
		</td>
	</tr>
</table>
<h4><a href="#proposal" onclick="showProposalDetails()" class="action" id="showProposalDetails">{translate key="submission.proposalDetails"}</a></h4>

<a name="areas"></a>
<table width="100%" class="data" id="geographicalAreas"  style="display:none">
	<tr><td colspan="6"><h4><a href="#areas" onclick="hideGeographicalAreas()" class="action" id="hideGeographicalAreas">{translate key="editor.reports.country"}</a></h4></td></tr>
	<tr valign="top">
		<td width="5%"></td>
		<td width="5%"></td>
		<td width="5%"></td>
		<td width="5%"></td>
		<td width="5%"></td>
		<td width="75%"></td>
	</tr>
	<tr valign="top">
		<td>&nbsp;</td>
		<td colspan="4"><br/>{translate key="editor.reports.multiCountry"}</td>
		<td colspan="2"><br/>
        	<input type="radio" name="multicountry" id="multicountryy" value="Yes" onclick="showOrHideProvince(this.value)"/>{translate key="common.yes"}
            &nbsp;&nbsp;&nbsp;&nbsp;
        	<input type="radio" name="multicountry" id="multicountryn" value="No" onclick="showOrHideProvince(this.value)"/>{translate key="common.no"}
        </td>
	</tr>
	
	<tr valign="top" id="firstProvince" class="province" style="display: none;">
		<td>&nbsp;</td>
		<td colspan="4" class="provinceTitle">{translate key="editor.reports.province"}</td>
		<td colspan="4" class="noProvinceTitle" style="display: none;" align="right">{translate key="editor.reports.orCap"}&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td colspan="2">
			<select name="provinces[]" id="provinces" class="selectMenu">
		 		<option value=""></option>
		 		{html_options options=$countriesOptions selected=$countries}
			</select>
			<a href="" class="removeProvince" style="display:none">{translate key="editor.article.remove"}</a>
		</td>
	</tr>
	
	<tr id="addAnotherProvince" style="display: none;">
    	<td>&nbsp;</td>
        <td colspan="4">&nbsp;</td>
        <td colspan="2"><a href="#" id="addAnotherProvince">{translate key="editor.reports.filterBy.addAnotherProvince"}</a></td>
    </tr>	
</table>

<h4><a href="#areas" onclick="showGeographicalAreas()" class="action" id="showGeographicalAreas">{translate key="editor.reports.country"}</a></h4>

<a name="dates"></a>
<table width="100%" class="data" id="dates" style="display: none;">
	
	<tr><td colspan="2"><h4><a href="#dates" onclick="hideDates()" class="action" id="hideDates">{translate key="editor.reports.dates"}</a></h4></td></tr>
	
	<tr><td width="5%"></td><td><a href="#researchDates" onclick="showResearchDates()" class="action" id="showResearchDates">&#187; {translate key="editor.reports.duration"}</a></td></tr>
	<tr><td width="5%"></td><td><a href="#dates" onclick="hideResearchDates()" class="action" id="hideResearchDates" style="display:none;">&#187; {translate key="editor.reports.duration"}</a></td></tr>
	
	<tr><td colspan="2">
	<a name="researchDates"></a>
	<table width="100%" class="data" id="researchDates" style="display: none;">
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%"><br/><strong>{translate key="editor.reports.startDate"}</strong></td>
			<td width="10%"><br/>{translate key="editor.reports.before"}</td>
			<td width="70%"><br/><input type="text" class="textField" name="startDateBefore" id="startDateBefore" size="20" maxlength="255" /><br/><span><i>{translate key="editor.reports.lessThan"}</i></span></td>
		</tr>
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">{translate key="editor.reports.after"}</td>
			<td width="70%">
				<input type="text" class="textField" name="startDateAfter" id="startDateAfter" size="20" maxlength="255" /><br/>
				<span><i>{translate key="editor.reports.greaterThan"}</i></span>
			</td>
		</tr>
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%"><br/><strong>{translate key="editor.reports.endDate"}</strong></td>
			<td width="10%"><br/>{translate key="editor.reports.before"}</td>
			<td width="70%"><br/><input type="text" class="textField" name="endDateBefore" id="endDateBefore" size="20" maxlength="255" /><br/><span><i>{translate key="editor.reports.lessThan"}</i></span></td>
		</tr>
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">{translate key="editor.reports.after"}</td>
			<td width="70%"><input type="text" class="textField" name="endDateAfter" id="endDateAfter" size="20" maxlength="255" /><br/><span><i>{translate key="editor.reports.greaterThan"}</i></span></td>
		</tr>
	</table>
	</td></tr>

	<tr><td width="5%"></td><td><a href="#reviewDates" onclick="showReviewDates()" class="action" id="showReviewDates">&#187; {translate key="editor.reports.review"}</a></td></tr>
	<tr><td width="5%"></td><td><a href="#dates" onclick="hideReviewDates()" class="action" id="hideReviewDates" style="display:none;">&#187; {translate key="editor.reports.review"}</a></td></tr>
	
	<tr><td colspan="2">
	<a name="reviewDates"></a>
	<table width="100%" class="data" id="reviewDates" style="display: none;">
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%"><br/><strong>{translate key="editor.reports.submitDate"}</strong></td>
			<td width="10%"><br/>{translate key="editor.reports.before"}</td>
			<td width="70%"><br/><input type="text" class="textField" name="submittedBefore" id="submittedBefore" size="20" maxlength="255" /><br/><span><i>{translate key="editor.reports.lessThan"}</i></span></td>
		</tr>
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">{translate key="editor.reports.after"}</td>
			<td width="70%"><input type="text" class="textField" name="submittedAfter" id="submittedAfter" size="20" maxlength="255" /><br/><span><i>{translate key="editor.reports.greaterThan"}</i></span></td>
		</tr>	
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%"><br/><strong>{translate key="editor.reports.approveDate"}</strong></td>
			<td width="10%"><br/>{translate key="editor.reports.before"}</td>
			<td width="70%"><br/><input type="text" class="textField" name="approvedBefore" id="approvedBefore" size="20" maxlength="255" /><br/><span><i>{translate key="editor.reports.lessThan"}</i></span></td>
		</tr>
		<tr valign="top">
			<td width="10%">&nbsp;</td>
			<td width="10%">&nbsp;</td>
			<td width="10%">{translate key="editor.reports.after"}</td>
			<td width="70%"><input type="text" class="textField" name="approvedAfter" id="approvedAfter" size="20" maxlength="255" /><br/><span><i>{translate key="editor.reports.greaterThan"}</i></span></td>
		</tr>
		<tr>
		<td colspan="2">&nbsp</td>
		<td colspan="2"><span><i><strong>{translate key="editor.reports.approveDateInstruct"}</strong></i></span></td>
		</tr>
	</table>
	</td></tr>
</table>
<h4><a href="#dates" onclick="showDates()" class="action" id="showDates">{translate key="editor.reports.dates"}</a></h4>

	<input type="hidden" name="dateToHour" value="23" />
	<input type="hidden" name="dateToMinute" value="59" />
	<input type="hidden" name="dateToSecond" value="59" />
	<input type="hidden" id="isValid" name="isValid" value="{$isValid}" />
	
	<br/><br/>
	<input type="submit" name="generateSubmissionsReport" value="{translate key="editor.reports.generateReport"}" class="button defaultButton" />
	<input type="button" class="button" onclick="history.go(-1)" value="{translate key="common.cancel"}" />

</form>
</div>

{include file="common/footer.tpl"}
