{**
 * step2.tpl
 *
 * Step 2 of author article submission.
 *
 * $Id$
 *}
{assign var="pageTitle" value="author.submit.step2"}
{include file="author/submit/submitHeader.tpl"}

{url|assign:"competingInterestGuidelinesUrl" page="information" op="competingInterestGuidelines"}

{assign var="cam" value="kh_CA"}
{assign var="eng" value="en_US"}

{if $journalSettings.supportPhone}
	{assign var="howToKeyName" value="author.submit.howToSubmit"}
{else}
	{assign var="howToKeyName" value="author.submit.howToSubmitNoPhone"}
{/if}

<p>{translate key=$howToKeyName supportName=$journalSettings.supportName supportEmail=$journalSettings.supportEmail supportPhone=$journalSettings.supportPhone}</p>

<div class="separator"></div>
	<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
	<p><span class="formRequired">{translate key="common.mouseOver"}</span></p>
<form name="submit" method="post" action="{url op="saveSubmit" path=$submitStep}">
    <input type="hidden" name="articleId" value="{$articleId|escape}" />
    
{include file="common/formErrors.tpl"}

{literal}
<script type="text/javascript">

    // Move author up/down
    function moveAuthor(dir, authorIndex) {
            var form = document.submit;
            form.moveAuthor.value = 1;
            form.moveAuthorDir.value = dir;
            form.moveAuthorIndex.value = authorIndex;
            form.submit();
    }

	function showOrHideGovernmentGrant(value){
		if (value == 'Yes'){
			document.getElementById('governmentGrantNameField').style.display = '';
			$('#governmentGrantName').val("");
		} else {
			if (document.getElementById('governmentGrantY').checked) {
				document.getElementById('governmentGrantNameField').style.display = '';			
			} else {
				document.getElementById('governmentGrantNameField').style.display = 'none';
				$('#governmentGrantName').val("NA");		
			}
		}
	}
	
	function showOrHideOtherPrimarySponsorField(value){
		if (value == 'OTHER') {
			document.getElementById('otherPrimarySponsorField').style.display = '';
			$('#otherPrimarySponsor').val("");
		} else {
			var other = false
			var list = document.getElementsByName("primarySponsor[en_US][]");
			for (i=0; i<list.length; i++){
				var strUser = list[i].options[list[i].selectedIndex].value;
				if (strUser == 'OTHER'){
					other = true;
				}
			}
			if (other == false){
				document.getElementById('otherPrimarySponsorField').style.display = 'none';
				$('#otherPrimarySponsor').val("NA");
			} else {
				document.getElementById('otherPrimarySponsorField').style.display = '';
			}
		} 	
	}
	
	function showOrHideOtherInternationalGrantName(value){
		if (value == 'OTHER') {
			document.getElementById('otherInternationalGrantNameField').style.display = '';
			$('#otherInternationalGrantName').val("");
		} else {
			var other = false
			var list = document.getElementsByName("internationalGrantName[en_US][]");
			for (i=0; i<list.length; i++){
				var strUser = list[i].options[list[i].selectedIndex].value;
				if (strUser == 'OTHER'){
					other = true;
				}
			}
			if (other == false){
				document.getElementById('otherInternationalGrantNameField').style.display = 'none';
				$('#otherInternationalGrantName').val("NA");
			} else {
				document.getElementById('otherInternationalGrantNameField').style.display = '';
			}
		}
	}

	function showOrHideOtherSecondarySponsor(value){
		if (value == 'OTHER') {
			document.getElementById('otherSecondarySponsorField').style.display = '';
			$('#otherSecondarySponsor').val("");
		} else {
			var other = false
			var list = document.getElementsByName("secondarySponsors[en_US][]");
			for (i=0; i<list.length; i++){
				var strUser = list[i].options[list[i].selectedIndex].value;
				if (strUser == 'OTHER'){
					other = true;
				}
			}
			if (other == false){
				document.getElementById('otherSecondarySponsorField').style.display = 'none';
				$('#otherSecondarySponsor').val("NA");
			} else {
				document.getElementById('otherSecondarySponsorField').style.display = '';
			}
		}
	}
	
	function showOrHideOtherResearchField(value){
		if (value == 'OTHER') {
			document.getElementById('otherResearchFieldField').style.display = '';
			$('#otherResearchField').val("");
		} else {
			var other = false
			var list = document.getElementsByName("researchField[en_US][]");
			for (i=0; i<list.length; i++){
				var strUser = list[i].options[list[i].selectedIndex].value;
				if (strUser == 'OTHER'){
					other = true;
				}
			}
			if (other == false){
				document.getElementById('otherResearchFieldField').style.display = 'none';
				$('#otherResearchField').val("NA");
			}
		}
	}

	function showOrHideOtherProposalType(value){
		if (value == 'OTHER') {
			document.getElementById('otherProposalTypeField').style.display = '';
			$('#otherProposalType').val("");
		} else {
			var other = false
			var list = document.getElementsByName("proposalType[en_US][]");
			for (i=0; i<list.length; i++){
				var strUser = list[i].options[list[i].selectedIndex].value;
				if (strUser == 'OTHER'){
					other = true;
				}
			}
			if (other == false){
				document.getElementById('otherProposalTypeField').style.display = 'none';
				$('#otherProposalType').val("NA");
			} else {
				document.getElementById('otherProposalTypeField').style.display = '';
			}
		}
	}
    
    function isNumeric(elem, helperMsg){
    	var numericExpression = /^([\s]*[0-9]+[\s]*)+$/;
    	if (elem.value.match(numericExpression)){
    		return true;
    	} else {
    		alert(helperMsg);
    		elem.focus();
    		return false;
    	}
    }
    
    $(document).ready(
    	function() {
        	showOrHideGovernmentGrant();
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 Human Subject               ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        	// Add filter of proposal types: with Human Subjects vs. without Human Subjects
        	if($('input[name^="withHumanSubjects"]:checked').val() == "No" || $('input[name^="withHumanSubjects"]:checked').val() == null) {
            	$('#proposalTypeField').hide();
            	$('#firstProposalType').hide();
            	$('#otherProposalTypeField').hide();
            	$('#addAnotherType').hide();
            	$('#proposalType').append('<option value="PNHS"></option>');
            	$('#proposalType').val("PNHS");
            	$('#otherProposalType').val("NA");
        	} 

        	$('input[name^="withHumanSubjects"]').change(
        		function(){
            		var answer = $('input[name^="withHumanSubjects"]:checked').val();
            		if(answer == "Yes") {
                		$('#proposalTypeField').show();
                		$('#firstProposalType').show();
                		$('#addAnotherType').show();
                		$('#proposalType option[value="PNHS"]').remove();
            		} else {
            			$('.proposalTypeSupp').remove();
                		$('#firstProposalType').hide();
                		$('#otherProposalTypeField').hide();
                		$('#otherProposalType').val("NA");
                		$('#addAnotherType').hide();
                		$('#proposalType').append('<option value="PNHS"></option>');
                		$('#proposalType').val("PNHS");
            		}
        		}
        	); 
        	//Start code for multiple proposal types
        	
        	$('#addAnotherType').click(
        		function(){
            		var proposalTypeHtml = '<tr valign="top" class="proposalTypeSupp">' + $('#firstProposalType').html() + '</tr>';
            		$('#firstProposalType').after(proposalTypeHtml);
            		$('#firstProposalType').next().find('select').attr('selectedIndex', 0);
            		$('.proposalTypeSupp').find('.removeProposalType').show();
            		$('#firstProposalType').find('.removeProposalType').hide();
            		return false;
        		}
        	);

        	$('.removeProposalType').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		showOrHideOtherProposalType();
            		return false;
        		}
        	);
        	//End code for multiple proposal types
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 Agency Grant               ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        	// Add filter of international grant
        	if($('input[name^="internationalGrant"]:checked').val() == "No" || $('input[name^="industryGrant"]:checked').val() == null) {
            	$('#internationalGrantNameField').hide();
            	$('#firstInternationalGrantName').hide();
            	$('#otherInternationalGrantNameField').hide();
            	$('#addAnotherInternationalGrantName').hide();
            	$('#internationalGrantName').append('<option value="NA"></option>');
            	$('#internationalGrantName').val("NA");
            	$('#otherInternationalGrantName').val("NA");
        	}
            
        	$('input[name^="internationalGrant"]').change(
        		function(){
              		var answer = $('input[name^="internationalGrant"]:checked').val();
              		if(answer == "Yes") {
            			$('#internationalGrantNameField').show();
            			$('#firstInternationalGrantName').show();
            			$('#addAnotherInternationalGrantName').show();
        				$('#internationalGrantName option[value="NA"]').remove();
              		} else {
            			$('.internationalGrantNameSupp').remove();
            			$('#firstInternationalGrantName').hide();
            			$('#otherInternationalGrantNameField').hide();
            			$('#otherInternationalGrantName').val("NA");
            			$('#addAnotherInternationalGrantName').hide();
            			$('#internationalGrantName').append('<option value="NA"></option>');
            			$('#internationalGrantName').val("NA");	
              		}
        		}
        	);
        	        	
        	//Start code for multiple international grants
        	$('#addAnotherInternationalGrantName').click(
        		function(){
            		var internationalGrantNameHtml = '<tr valign="top" class="internationalGrantNameSupp">' + $('#firstInternationalGrantName').html() + '</tr>';
            		$('#firstInternationalGrantName').after(internationalGrantNameHtml);
            		$('#firstInternationalGrantName').next().find('select').attr('selectedIndex', 0);
            		$('.internationalGrantNameSupp').find('.removeInternationalGrantName').show();
            		$('.internationalGrantNameSupp').find('.internationalGrantNameTitle').hide();
            		$('#firstInternationalGrantName').find('.internationalGrantNameTitle').show();
            		$('#firstInternationalGrantName').find('.removeInternationalGrantName').hide();
            		return false;
        		}
        	);

        	$('.removeInternationalGrantName').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		showOrHideOtherInternationalGrantName();
            		return false;
        		}
        	);
        	//End code for international grants
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 Multi Country               ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

        	//Add filter of multi-country research
        	if($('input[name^="multiCountryResearch"]:checked').val() == "No" || $('input[name^="multiCountryResearch"]:checked').val() == null) {
            	$('#multiCountryField').hide();
            	$('#firstMultiCountry').hide();
            	$('#addAnotherCountry').hide();
            	$('#multiCountry').val("MCNA");
        	} else {
            	$('#multiCountry option[value="MCNA"]').remove();
        	}
            
        	$('input[name^="multiCountryResearch"]').change(
        		function(){
              		var answer = $('input[name^="multiCountryResearch"]:checked').val();
              		if(answer == "Yes") {
                  		$('#multiCountryField').show();
                  		$('#firstMultiCountry').show();
                  		$('#addAnotherCountry').show();
                  		$('#multiCountry option[value="MCNA"]').remove();
              		} else {
                  		$('#multiCountryField').hide();
            			$('#firstMultiCountry').hide();
            			$('.multiCountrySupp').remove();
            			$('#addAnotherCountry').hide();
                  		$('#multiCountry').append('<option value="MCNA"></option>');
                  		$('#multiCountry').val("MCNA");
              		}
        		}
        	);
        	
        	//Start code for multi-country proposals
        	$('#addAnotherCountry').click(
        		function(){
            		var multiCountryHtml = '<tr valign="top" class="multiCountrySupp">' + $('#firstMultiCountry').html() + '</tr>';
            		$('#firstMultiCountry').after(multiCountryHtml);
            		$('#firstMultiCountry').next().find('select').attr('selectedIndex', 0);
            		$('.multiCountrySupp').find('.removeMultiCountry').show();
            		$('#firstMultiCountry').find('.removeMultiCountry').hide();
            		return false;
        		}
        	);

        	$('.removeMultiCountry').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		return false;
        		}
        	);
        	
        	//End code for multi-country proposals
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 multi-province              ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

        	//Start code for multi-provinces proposals
        	$('#addAnotherProvince').click(
        		function(){
            		var proposalCountryHtml = '<tr valign="top" class="proposalCountrySupp">' + $('#firstProposalCountry').html() + '</tr>';
            		$('#firstProposalCountry').after(proposalCountryHtml);
            		$('#firstProposalCountry').next().find('select').attr('selectedIndex', 0);
            		$('.proposalCountrySupp').find('.removeProposalProvince').show();
            		$('#firstProposalCountry').find('.removeProposalProvince').hide();
            		$('.proposalCountrySupp').find('.proposalCountryTitle').hide();
        			$('.proposalCountrySupp').find('.noProposalCountryTitle').show();
            		$('#firstProposalCountry').find('.proposalCountryTitle').show();
        			$('#firstProposalCountry').find('.noProposalCountryTitle').hide();
            		return false;
        		}
        	);
        			
        	$('.removeProposalProvince').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		return false;
        		}
        	);
        	
        	//End code for multi-provinces proposals
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////               Student Research              ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        	// Add filter of sudent research
        	if($('input[name^="studentInitiatedResearch"]:checked').val() == "No" || $('input[name^="withHumanSubjects"]:checked').val() == null) {
            	$('#academicDegreeField').hide();
            	$('#supervisorFullNameField').hide();
            	$('#supervisorFullName').val("NA");
            	$('#supervisorEmailField').hide();
            	$('#supervisorEmail').val("NA");
            	$('#supervisorPhoneField').hide();
            	$('#supervisorPhone').val("NA");
            	$('#academicDegree').append('<option value="NA"></option>');
            	$('#academicDegree').val("NA");
            	$('#studentInstitutionField').hide();
            	$('#studentInstitution').val("NA");
            	$('#supervisorAffiliationField').hide();
            	$('#supervisorAffiliation').val("NA");
            	$('#supervisor').hide();
        	} else {
            	$('#studentInstitutionField').show();
				$('#academicDegreeField').show();
				$('#supervisor').show();
				$('#academicDegree option[value="NA"]').remove();
            	$('#supervisorFullNameField').show();
            	$('#supervisorEmailField').show();
            	$('#supervisorPhoneField').show();
            	$('#supervisorAffiliationField').show();
			}

        	$('input[name^="studentInitiatedResearch"]').change(
        		function(){
            		var answer = $('input[name^="studentInitiatedResearch"]:checked').val();
            		if(answer == "Yes") {
            			$('#studentInstitutionField').show();
            			$('#studentInstitution').val("");
                		$('#academicDegreeField').show();
                		$('#supervisor').show();
                		$('#academicDegree option[value="NA"]').remove();
            			$('#supervisorFullNameField').show();
            			$('#supervisorFullName').val("");
            			$('#supervisorEmailField').show();
            			$('#supervisorEmail').val("");
                    	$('#supervisorPhoneField').show();
            			$('#supervisorPhone').val("");
            	        $('#supervisorAffiliationField').show();
            			$('#supervisorAffiliation').val("");
            		} else {
                		$('#academicDegreeField').hide();
            			$('#supervisorFullNameField').hide();
            			$('#supervisorFullName').val("NA");
            			$('#supervisorEmailField').hide();
            			$('#supervisorEmail').val("NA");
                		$('#supervisorPhoneField').hide();
            			$('#supervisorPhone').val("NA");
            			$('#supervisor').hide();
                		$('#academicDegree').append('<option value="NA"></option>');
                		$('#academicDegree').val("NA");
                		$('#studentInstitutionField').hide();
            			$('#studentInstitution').val("NA");
                		$('#supervisorAffiliationField').hide();
            			$('#supervisorAffiliation').val("NA");
            		}
        		}
        	);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 ERC Decision                ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        	// Add filter of ERC decisions
        	if($('input[name^="reviewedByOtherErc"]:checked').val() == "No" || $('input[name^="reviewedByOtherErc"]:checked').val() == null) {
            	$('#otherErcDecisionField').hide();
            	$('#otherErcDecision').val("NA");
        	} else {
            	$('#otherErcDecision option[value="NA"]').remove();
        	}
            
        	$('input[name^="reviewedByOtherErc"]').change(
        		function(){
              		var answer = $('input[name^="reviewedByOtherErc"]:checked').val();
              		if(answer == "Yes") {
                  		$('#otherErcDecisionField').show();
                  		$('#otherErcDecision option[value="NA"]').remove();
              		} else {
                  		$('#otherErcDecisionField').hide();
                  		$('#otherErcDecision').append('<option value="NA"></option>');
                  		$('#otherErcDecision').val("NA");
              		}
        		}
        	);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                Industry Grant               ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        	// Add filter of industry grant
        	if($('input[name^="industryGrant"]:checked').val() == "No" || $('input[name^="industryGrant"]:checked').val() == null) {
            	$('#nameOfIndustryField').hide();
            	$('#nameOfIndustry').val("NA");
        	} else {
        		$('#nameOfIndustryField').show();
        	}
            
        	$('input[name^="industryGrant"]').change(
        		function(){
              		var answer = $('input[name^="industryGrant"]:checked').val();
              		if(answer == "Yes") {
                  		$('#nameOfIndustryField').show();
                  		$('#nameOfIndustry').val("");
              		} else {
                  		$('#nameOfIndustryField').hide();
                  		$('#nameOfIndustry').val("NA");
              		}
        		}
        	);
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                 Other Grant                 ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

        	// Add filter of other grant
        	if($('input[name^="otherGrant"]:checked').val() == "No" || $('input[name^="otherGrant"]:checked').val() == null) {
            	$('#specifyOtherGrantField').hide();
            	$('#specifyOtherGrant').val("NA");
        	} else {
        		$('#specifyOtherGrantField').show();
        	}
            
        	$('input[name^="otherGrant"]').change(
        		function(){
              		var answer = $('input[name^="otherGrant"]:checked').val();
              		if(answer == "Yes") {
                  		$('#specifyOtherGrantField').show();
                  		$('#specifyOtherGrant').val("");
              		} else {
                  		$('#specifyOtherGrantField').hide();
                  		$('#specifyOtherGrant').val("NA");
              		}
        		}
        	);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                    Dates                    ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

        	//Restrict end date to (start date) + 1
        	$( "#startDate" ).datepicker(
        		{
        			changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', minDate: '-1 y', onSelect: function(dateText, inst){
                        dayAfter = new Date();
                        dayAfter = $("#startDate").datepicker("getDate");
                        dayAfter.setDate(dayAfter.getDate() + 1);
                        $("#endDate").datepicker("option","minDate", dayAfter)
                	}
        		}
        	);
            
        	$( "#endDate" ).datepicker(
        		{
        			changeMonth: true, changeYear: true, dateFormat: 'dd-M-yy', minDate: '-1 y'
        		}
        	);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////               Seconday Sponsor              ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

          	//Start code for multiple secondary sponsor
        	$('#addAnotherSecondarySponsor').click(
        		function(){
            		var secondarySponsorHtml = '<tr valign="top" class="secondarySponsorSupp">' + $('#firstSecondarySponsor').html() + '</tr>';
            		$('#firstSecondarySponsor').after(secondarySponsorHtml);
            		$('#firstSecondarySponsor').next().find('select').attr('selectedIndex', 0);
            		$('.secondarySponsorSupp').find('.removeSecondarySponsor').show();
                	$('.secondarySponsorSupp').find('.secondarySponsorTitle').hide();
        			$('.secondarySponsorSupp').find('.noSecondarySponsorTitle').show();
            		$('#firstSecondarySponsor').find('.removeSecondarySponsor').hide();
            		$('#firstSecondarySponsor').find('.secondarySponsorTitle').show();
        			$('#firstSecondarySponsor').find('.noSecondarySponsorTitle').hide();
            		return false;
        		}
        	);

        	$('.removeSecondarySponsor').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		showOrHideOtherSecondarySponsor();
            		return false;
        		}
        	);
        	//End code for multiple secondary sponsors
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////               Research Fields               ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////        
   
   			//Start code for multiple research fields
        	$('#addAnotherField').click(
        		function(){
            		var proposalFieldHtml = '<tr valign="top" class="researchFieldSupp">' + $('#firstResearchField').html() + '</tr>';
            		$('#firstResearchField').after(proposalFieldHtml);
            		$('#firstResearchField').next().find('select').attr('selectedIndex', 0);
            		$('.researchFieldSupp').find('.removeResearchField').show();
            		$('.researchFieldSupp').find('.researchFieldTitle').hide();
            		$('.researchFieldSupp').find('.noResearchFieldTitle').show();
            		$('#firstResearchField').find('.removeResearchField').hide();
            		$('#firstResearchField').find('.researchFieldTitle').show();
            		$('#firstResearchField').find('.noResearchFieldTitle').hide();
            		return false;
        		}
        	);

        	$('.removeResearchField').live(
        		'click', function(){
            		$(this).closest('tr').remove();
            		showOrHideOtherResearchField();
            		return false;
        		}
        	);
        	//End code for multiple research fields
        	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////               Risk Levels               ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  

        	// Add filter of sudent research
        	if (($('select[name="riskLevel[{/literal}{$eng|escape}{literal}]"]').val() != 'No more than minimal risk') && ($('select[name="riskLevel[{/literal}{$eng|escape}{literal}]"]').val() != '')){
            	$('#listRisksField').show();
            	$('#howRisksMinimizedField').show();
        	} else {
            	$('#listRisksField').hide();
            	$('#howRisksMinimizedField').hide();
            	$('#listRisks').val("NA");
				$('#howRisksMinimized').val("NA");
			}

        	$('select[name="riskLevel[{/literal}{$eng|escape}{literal}]"]').change(
        		function(){
            		var answer = $('select[name="riskLevel[{/literal}{$eng|escape}{literal}]"]').val();
            		if(answer != "No more than minimal risk" && answer != "") {
            			$('#listRisksField').show();
            			$('#howRisksMinimizedField').show();
            			$('#listRisks').val("");
						$('#howRisksMinimized').val("");
            		} else {
            			$('#listRisksField').hide();
            			$('#howRisksMinimizedField').hide();
            			$('#listRisks').val("NA");
						$('#howRisksMinimized').val("NA");
            		}
        		}
        	);
    	}
    );
</script>
{/literal}
<!--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////                   Authors                   ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
-->
<div class="separator"></div>
    <div id="authors">
        <h3>{translate key="article.authors"}</h3>

        <input type="hidden" name="deletedAuthors" value="{$deletedAuthors|escape}" />
        <input type="hidden" name="moveAuthor" value="0" />
        <input type="hidden" name="moveAuthorDir" value="" />
        <input type="hidden" name="moveAuthorIndex" value="" />

{foreach name=authors from=$authors key=authorIndex item=author}
        <input type="hidden" name="authors[{$authorIndex|escape}][authorId]" value="{$author.authorId|escape}" />
        <input type="hidden" name="authors[{$authorIndex|escape}][seq]" value="{$authorIndex+1}" />

{if $smarty.foreach.authors.total <= 1}
        <input type="hidden" name="primaryContact" value="{$authorIndex|escape}" />
{/if}
{if $authorIndex == 1}<h3>{translate key="user.role.coinvestigator"}</h3>{/if}
        <table width="100%" class="data">
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-firstName" required="true" key="user.firstName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][firstName]" id="authors-{$authorIndex|escape}-firstName" value="{$author.firstName|escape}" size="20" maxlength="40" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-middleName" key="user.middleName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][middleName]" id="authors-{$authorIndex|escape}-middleName" value="{$author.middleName|escape}" size="20" maxlength="40" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-lastName" required="true" key="user.lastName"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][lastName]" id="authors-{$authorIndex|escape}-lastName" value="{$author.lastName|escape}" size="20" maxlength="90" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-email" required="true" key="user.email"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authors[{$authorIndex|escape}][email]" id="authors-{$authorIndex|escape}-email" value="{$author.email|escape}" size="30" maxlength="90" /></td>
            </tr>
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authorPhoneNumber" required="true" key="user.phone"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="authorPhoneNumber[{$eng|escape}]" id="authorPhoneNumber" value="{$authorPhoneNumber[$eng]|escape}" size="20" />
                <br/><i>{translate key="proposal.phoneIncludeCountry"}</i>
                </td>
            </tr>            
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-affiliation" required="true" key="user.affiliation"}</td>
                <td width="80%" class="value">
                    <textarea name="authors[{$authorIndex|escape}][affiliation][{$eng|escape}]" class="textArea" id="authors-{$authorIndex|escape}-affiliation" rows="5" cols="40">{$author.affiliation[$eng]|escape}</textarea><br/>
                    <span class="instruct">{translate key="user.affiliation.description"}</span>
                </td>
            </tr>
            
{if $currentJournal->getSetting('requireAuthorCompetingInterests')}
            <tr valign="top">
                <td width="20%" class="label">{fieldLabel name="authors-$authorIndex-competingInterests" key="author.competingInterests" competingInterestGuidelinesUrl=$competingInterestGuidelinesUrl}</td>
                <td width="80%" class="value"><textarea name="authors[{$authorIndex|escape}][competingInterests][{$eng|escape}]" class="textArea" id="authors-{$authorIndex|escape}-competingInterests" rows="5" cols="40">{$author.competingInterests[$eng]|escape}</textarea></td>
            </tr>
{/if}{* requireAuthorCompetingInterests *}

{call_hook name="Templates::Author::Submit::Authors"}

{if $smarty.foreach.authors.total > 1}
            <tr valign="top">
                <td width="80%" class="value" colspan="2">
                    <div style="display:none">
                        <input type="radio" name="primaryContact" value="{$authorIndex|escape}"{if $primaryContact == $authorIndex} checked="checked"{/if} /> <label for="primaryContact">{*translate key="author.submit.selectPrincipalContact"*}</label>
                    </div>
            {if $authorIndex > 0}
                    <input type="submit" name="delAuthor[{$authorIndex|escape}]" value="{*translate key="author.submit.deleteAuthor"*}Delete Co-Investigator" class="button" />
            {else}
                    &nbsp;
            {/if}
                </td>
            </tr>
            <tr>
                <td colspan="2"><br/></td>
            </tr>
{/if}
        </table>

{/foreach}
        <br /><br />
        {if $authorIndex<3}<p><input type="submit" class="button" name="addAuthor" value="{translate key="author.submit.addAuthor"}" /></p>{/if}
    </div>
    <div class="separator"></div>
<!--    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////              Title and Abstract             ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-->
    <div id="titleAndAbstract">
        <h3>{translate key="submission.titleAndAbstract"}</h3>

        <table width="100%" class="data">
        	<tr valign="top"><td title="{translate key="proposal.scientificTitleInstruct"}" colspan="2"><b><br/>[?] {translate key="proposal.scientificTitle"}<br/></b></td></tr>
            <tr valign="top" id="engScientificTitleField">
                <td width="20%" class="label">{fieldLabel name="scientificTitle" required="true" key="proposal.engScientificTitle"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="scientificTitle[{$eng|escape}]" id="scientificTitle" value="{$scientificTitle[$eng]|escape}" size="70" maxlength="255" /></td>
            </tr>
            <tr valign="top" id="camScientificTitleField">
                <td width="20%" class="label">{fieldLabel name="scientificTitle" required="true" key="proposal.camScientificTitle"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="scientificTitle[{$cam|escape}]" id="scientificTitle" value="{$scientificTitle[$cam]|escape}" size="70" maxlength="255" /></td>
            </tr>
            <!--
        	<tr valign="top"><td title="{translate key="proposal.publicTitleInstruct"}" colspan="2"><b><br/>[?] {translate key="proposal.publicTitle"}<br/></b></td></tr>
            <tr valign="top" id="engPublicTitleField">
                <td width="20%" class="label">{fieldLabel name="publicTitle" required="true" key="proposal.engPublicTitle"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="publicTitle[{$eng|escape}]" id="publicTitle" value="{$publicTitle[$eng]|escape}" size="70" maxlength="255" /></td>
            </tr>
            <tr valign="top" id="camPublicTitleField">
                <td width="20%" class="label">{fieldLabel name="publicTitle" required="true" key="proposal.camPublicTitle"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="publicTitle[{$cam|escape}]" id="publicTitle" value="{$publicTitle[$cam]|escape}" size="70" maxlength="255" /></td>
            </tr>
            -->
        	<tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.engAbstract"}<br/></b></td></tr>
            <tr valign="top" id="engBackgroundField">
                <td title="{translate key="proposal.backgroundInstruct"}" width="20%" class="label">[?] {fieldLabel name="background" required="true" key="proposal.background"}</td>
                <td width="80%" class="value"><textarea name="background[{$eng|escape}]" id="background" class="textArea" rows="5" cols="70">{$background[$eng]|escape}</textarea></td>
            </tr>
            <tr valign="top" id="engObjectivesField">
                <td title="{translate key="proposal.objectivesInstruct"}" width="20%" class="label">[?] {fieldLabel name="objectives" required="true" key="proposal.objectives"}</td>
                <td width="80%" class="value"><textarea name="objectives[{$eng|escape}]" id="objectives" class="textArea" rows="5" cols="70">{$objectives[$eng]|escape}</textarea></td>
            </tr>
            <tr valign="top" id="engStudyMattersField">
                <td title="{translate key="proposal.studyMattersInstruct"}" width="20%" class="label">[?] {fieldLabel name="studyMatters" required="true" key="proposal.studyMatters"}</td>
                <td width="80%" class="value"><textarea name="studyMatters[{$eng|escape}]" id="studyMatters" class="textArea" rows="5" cols="70">{$studyMatters[$eng]|escape}</textarea></td>
            </tr>  
            <tr valign="top" id="engExpectedOutcomesField">
                <td title="{translate key="proposal.expectedOutcomesInstruct"}" width="20%" class="label">[?] {fieldLabel name="expectedOutcomes" required="true" key="proposal.expectedOutcomes"}</td>
                <td width="80%" class="value"><textarea name="expectedOutcomes[{$eng|escape}]" id="expectedOutcomes" class="textArea" rows="5" cols="70">{$expectedOutcomes[$eng]|escape}</textarea></td>
            </tr>
            
        	<tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.camAbstract"}<br/></b></td></tr>
            <tr valign="top" id="camBackgroundField">
                <td title="{translate key="proposal.backgroundInstruct"}" width="20%" class="label">[?] {fieldLabel name="background" required="true" key="proposal.background"}</td>
                <td width="80%" class="value"><textarea name="background[{$cam|escape}]" id="background" class="textArea" rows="5" cols="70">{$background[$cam]|escape}</textarea></td>
            </tr>
            <tr valign="top" id="camObjectivesField">
                <td title="{translate key="proposal.objectivesInstruct"}" width="20%" class="label">[?] {fieldLabel name="objectives" required="true" key="proposal.objectives"}</td>
                <td width="80%" class="value"><textarea name="objectives[{$cam|escape}]" id="objectives" class="textArea" rows="5" cols="70">{$objectives[$cam]|escape}</textarea></td>
            </tr>
            <tr valign="top" id="camStudyMattersField">
                <td title="{translate key="proposal.studyMattersInstruct"}" width="20%" class="label">[?] {fieldLabel name="studyMatters" required="true" key="proposal.studyMatters"}</td>
                <td width="80%" class="value"><textarea name="studyMatters[{$cam|escape}]" id="studyMatters" class="textArea" rows="5" cols="70">{$studyMatters[$cam]|escape}</textarea></td>
            </tr>
            <tr valign="top" id="camExpectedOutcomesField">
                <td title="{translate key="proposal.expectedOutcomesInstruct"}" width="20%" class="label">[?] {fieldLabel name="expectedOutcomes" required="true" key="proposal.expectedOutcomes"}</td>
                <td width="80%" class="value"><textarea name="expectedOutcomes[{$cam|escape}]" id="expectedOutcomes" class="textArea" rows="5" cols="70">{$expectedOutcomes[$cam]|escape}</textarea></td>
            </tr>
            
        	<tr valign="top"><td title="{translate key="proposal.keywordsInstruct"}" colspan="2"><b><br/>[?] {translate key="proposal.keywords"}<br/></b></td></tr>
            <tr valign="top" id="engKeywordsField">
                <td width="20%" class="label">{fieldLabel name="keywords" required="true" key="proposal.engKeywords"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="keywords[{$eng|escape}]" id="keywords" value="{$keywords[$eng]|escape}" size="70" maxlength="255" /></td>
            </tr>
            <tr valign="top" id="camKeywordsField">
                <td width="20%" class="label">{fieldLabel name="keywords" required="true" key="proposal.camKeywords"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="keywords[{$cam|escape}]" id="keywords" value="{$keywords[$cam]|escape}" size="70" maxlength="255" /></td>
            </tr>
        </table>
    </div>

    <div class="separator"></div>
<!--    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////               Proposal Details              ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-->
    <div id="proposalDetails">
        <h3>{translate key="submission.proposalDetails"}</h3>

        <table width="100%" class="data">
            
            <tr valign="top" id="studentInitiatedResearchField">
                <td title="{translate key="proposal.studentInitiatedResearchInstruct"}" width="20%" class="label">[?] {fieldLabel name="studentInitiatedResearch" required="true" key="proposal.studentInitiatedResearch"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="studentInitiatedResearch[{$eng|escape}]" id="studentInitiatedResearch" value="Yes" {if  $studentInitiatedResearch[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                   	&nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="studentInitiatedResearch[{$eng|escape}]" id="studentInitiatedResearch" value="No" {if  $studentInitiatedResearch[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}
                	<table width="100%" class="data">
               			<tr valign="top" id="studentInstitutionField">
                			<td title="{translate key="proposal.studentInstitutionInstruct"}" width="20%" class="label">[?] {fieldLabel name="studentInstitution" required="false" key="proposal.studentInstitution"}</td>
                			<td width="80%" class="value">
            					<input type="text" class="textField" name="studentInstitution[{$eng|escape}]" id="studentInstitution" value="{$studentInstitution[$eng]|escape}" size="50" maxlength="255" />
            				</td>
            			</tr>
             			<tr valign="top" id="academicDegreeField">
                			<td title="{translate key="proposal.academicDegreeInstruct"}" width="20%" class="label">[?] {fieldLabel name="academicDegree" required="false" key="proposal.academicDegree"}</td>
                			<td width="80%" class="value">
								<select name="academicDegree[{$eng|escape}]" id="academicDegree" class="selectMenu">
									<option value=""></option>
									<option value="Undergraduate" {if  $academicDegree[$eng] == "Undergraduate" } selected="selected"{/if}>{translate key="proposal.undergraduate"}</option>
									<option value="Master" {if  $academicDegree[$eng] == "Master" } selected="selected"{/if}>{translate key="proposal.master"}</option>
									<option value="Post-Doc" {if  $academicDegree[$eng] == "Post-Doc" } selected="selected"{/if}>{translate key="proposal.postDoc"}</option>
									<option value="Ph.D" {if  $academicDegree[$eng] == "Ph.D" } selected="selected"{/if}>{translate key="proposal.phd"}</option>
									<option value="Other" {if  $academicDegree[$eng] == "Other" } selected="selected"{/if}>{translate key="common.other"}</option>
								</select>
                			</td>
            			</tr>
                		<tr valign="top" id="supervisor"><td colspan="2"><b>{translate key="proposal.supervisor"}</b></td></tr>
                		<tr valign="top" id="supervisorFullNameField">
                			<td title="{translate key="proposal.supervisorFullNameInstruct"}" width="20%" class="label">[?] {fieldLabel name="supervisorFullName" required="false" key="proposal.supervisorFullName"}</td>
                			<td width="80%" class="value">
            					<input type="text" class="textField" name="supervisorFullName[{$eng|escape}]" id="supervisorFullName" value="{$supervisorFullName[$eng]|escape}" size="50" maxlength="255" />
            				</td>
            			</tr>
                		<tr valign="top" id="supervisorEmailField">
                			<td title="{translate key="proposal.supervisorEmailInstruct"}" width="20%" class="label">[?] {fieldLabel name="supervisorEmail" required="false" key="user.email"}</td>
                			<td width="80%" class="value">
            					<input type="text" class="textField" name="supervisorEmail[{$eng|escape}]" id="supervisorEmail" value="{$supervisorEmail[$eng]|escape}" size="50" maxlength="255" />
            				</td>
            			</tr>
                        <tr valign="top" id="supervisorPhoneField">
                			<td title="{translate key="proposal.supervisorPhoneInstruct"}" width="20%" class="label">[?] {fieldLabel name="supervisorPhone" required="false" key="user.phone"}</td>
                			<td width="80%" class="value">
            					<input type="text" class="textField" name="supervisorPhone[{$eng|escape}]" id="supervisorPhone" value="{$supervisorPhone[$eng]|escape}" size="50" maxlength="255" />
            				</td>
            			</tr>
                		<tr valign="top" id="supervisorAffiliationField">
                			<td title="{translate key="proposal.supervisorAffiliationInstruct"}" width="20%" class="label">[?] {fieldLabel name="supervisorAffiliation" required="true" key="user.affiliation"}</td>
                			<td width="80%" class="value">
                    		<textarea name="supervisorAffiliation[{$eng|escape}]" class="textArea" id="supervisorAffiliation" rows="5" cols="50">{$supervisorAffiliation[$eng]|escape}</textarea><br/>
                			</td>
            			</tr>
            		</table>
            	</td>
            </tr>
            
            <tr valign="top" id="startDateField">
                <td title="{translate key="proposal.startDateInstruct"}" width="20%" class="label">[?] {fieldLabel name="startDate" required="true" key="proposal.startDate"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="startDate[{$eng|escape}]" id="startDate" value="{$startDate[$eng]|escape}" size="20" maxlength="255" /></td>
            </tr>

            <tr valign="top" id="endDateField">
                <td title="{translate key="proposal.endDateInstruct"}" width="20%" class="label">[?] {fieldLabel name="endDate" required="true" key="proposal.endDate"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="endDate[{$eng|escape}]" id="endDate" value="{$endDate[$eng]|escape}" size="20" maxlength="255" /></td>
            </tr>
            
{assign var="isOtherPrimarySponsorSelected" value=false}
{foreach from=$primarySponsor[$eng] key=i item=sponsor}           
            <tr valign="top" {if $i == 0}id="firstPrimarySponsor" class="primarySponsor"{else}id="primarySponsorField"  class="primarySponsorSupp"{/if}>
                <td title="{translate key="proposal.primarySponsorInstruct"}" width="20%" class="label">
				{if $i == 0}[?] {fieldLabel name="primarySponsor" required="true" key="proposal.primarySponsor"}{/if}</td>
                <td width="80%" class="value">
                    <select name="primarySponsor[{$eng|escape}][]" id="primarySponsor" class="selectMenu" onchange="showOrHideOtherPrimarySponsorField(this.value);">
                        <option value=""></option>
                        {foreach from=$agencies key=id item=sponsor}
                            {if $sponsor.code != "NA"}
                                {assign var="isSelected" value=false}
                                {foreach from=$primarySponsor[$eng] key=id item=selectedTypes}
                                    {if $primarySponsor[$eng][$i] == $sponsor.code}
                                        {assign var="isSelected" value=true}
                                    {/if}
                                    {if $primarySponsor[$eng][$i] == "OTHER"}{assign var="isOtherPrimarySponsorSelected" value=true}{/if}
                                {/foreach}
                                <option value="{$sponsor.code}" {if $isSelected==true}selected="selected"{/if} >{$sponsor.name}</option>
                            {/if}
                        {/foreach}
                    </select>
                </td>
            </tr>
{/foreach}

            <tr valign="top" id="otherPrimarySponsorField" {if $isOtherPrimarySponsorSelected == false}style="display: none;"{/if}>
                <td width="20%" class="label"></td>
                <td width="80%" class="value">
                <span title="{translate key="proposal.otherPrimarySponsorInstruct"}" style="font-style: italic;">[?] {fieldLabel name="otherPrimarySponsor" required="true" key="proposal.otherPrimarySponsor"}</span>&nbsp;&nbsp;
                <input type="text" class="textField" name="otherPrimarySponsor[{$eng|escape}]" id="otherPrimarySponsor" value="{if $isOtherPrimarySponsorSelected == false}NA{else}{$otherPrimarySponsor[$eng]|escape}{/if}" size="20" maxlength="255" />
                </td>
            </tr>
            
{assign var="isOtherSecondarySponsorSelected" value=false}
{foreach from=$secondarySponsors[$eng] key=i item=sponsor}
            <tr valign="top" {if $i == 0}id="firstSecondarySponsor" class="secondarySponsor"{else}id="secondarySponsorField" class="secondarySponsorSupp"{/if}>
                <td title="{translate key="proposal.secondarySponsorsInstruct"}" width="20%" class="secondarySponsorTitle">{if $i == 0}[?] {fieldLabel name="secondarySponsors" key="proposal.secondarySponsors"}{/if}</td>
				<td class="noSecondarySponsorTitle" style="display: none;">&nbsp;</td>
                <td width="80%" class="value">
                    <select name="secondarySponsors[{$eng|escape}][]" id="secondarySponsors" class="selectMenu" onchange="showOrHideOtherSecondarySponsor(this.value);">
                        <option value=""></option>
                        {foreach from=$agencies key=id item=sponsor}
                            {if $sponsor.code != "NA"}
                                {assign var="isSelected" value=false}
                                {foreach from=$secondarySponsors[$eng] key=id item=selectedTypes}
                                    {if $secondarySponsors[$eng][$i] == $sponsor.code}
                                        {assign var="isSelected" value=true}
                                    {/if}
                                    {if $secondarySponsors[$eng][$i] == "OTHER"}{assign var="isOtherSecondarySponsorSelected" value=true}{/if}
                                {/foreach}
                                <option value="{$sponsor.code}" {if $isSelected==true}selected="selected"{/if} >{$sponsor.name}</option>
                            {/if}
                        {/foreach}
                    </select>
                    <a href="" class="removeSecondarySponsor" {if $i == 0} style="display:none"{/if}>{translate key="common.remove"}</a>
                </td>
            </tr>
{/foreach} 
            <tr id="addAnotherSecondarySponsor">
                <td width="20%">&nbsp;</td>
                <td width="40%"><a href="#" id="addAnotherSecondarySponsor">{translate key="proposal.addAnotherSecondarySponsor"}</a></td>
            </tr>
            
            <tr valign="top" id="otherSecondarySponsorField" {if $isOtherSecondarySponsorSelected == false}style="display: none;"{/if}>
                <td width="20%" class="label"></td>
                <td width="80%" class="value">
                <span title="{translate key="proposal.otherSecondarySponsorInstruct"}" style="font-style: italic;">[?] {fieldLabel name="otherSecondarySponsor" required="true" key="proposal.otherSecondarySponsor"}</span>&nbsp;&nbsp;
                <input type="text" class="textField" name="otherSecondarySponsor[{$eng|escape}]" id="otherSecondarySponsor" value="{if $isOtherSecondarySponsorSelected == false}NA{else}{$otherSecondarySponsor[$eng]|escape}{/if}" size="20" maxlength="255" />
                </td>
            </tr>
            
            <tr valign="top" id="multiCountryResearchField">
                <td title="{translate key="proposal.multiCountryResearchInstruct"}" width="20%" class="label">[?] {fieldLabel name="multiCountryResearch" required="true" key="proposal.multiCountryResearch"}</td>
                <td width="80%" class="value">
                	<input type="radio" name="multiCountryResearch[{$eng|escape}]" id="multiCountryResearch" value="Yes" {if  $multiCountryResearch[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="multiCountryResearch[{$eng|escape}]" id="multiCountryResearch" value="No" {if  $multiCountryResearch[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}
                </td>
            </tr>
            
{foreach from=$multiCountry[$eng] key=i item=country}
            <tr valign="top" {if $i == 0}id="firstMultiCountry" class="multiCountry"{else}id="mutliCountryField" class="multiCountrySupp"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span style="font-style: italic;">{fieldLabel name="multiCountry" required="true" key="proposal.multiCountry"}</span>&nbsp;&nbsp;
                    <select name="multiCountry[{$eng|escape}][]" id="multiCountry" class="selectMenu">
                        <option value="MCNA"></option><option value=""></option>
		{html_options options=$countries selected=$multiCountry[$eng][$i]}
                    </select>
                    <a href="" class="removeMultiCountry" {if $i == 0}style="display:none"{/if}>{translate key="common.remove"}</a>
                </td>
            </tr>
{/foreach}

            <tr id="addAnotherCountry">
                <td width="20%">&nbsp;</td>
                <td><a href="#" id="addAnotherCountry">{translate key="proposal.addAnotherCountry"}</a></td>
            </tr> 
            
            <tr valign="top" id="nationwideField">
                <td title="{translate key="proposal.nationwideInstruct"}" width="20%" class="label">[?] {fieldLabel name="nationwide" required="true" key="proposal.nationwide"}</td>
                <td width="80%" class="value">
                	<input type="radio" name="nationwide[{$eng|escape}]" id="nationwide" value="Yes" {if  $nationwide[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="nationwide[{$eng|escape}]" id="nationwide" value="No" {if  $nationwide[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}
                </td>
            </tr>
            
{foreach from=$proposalCountry[$eng] key=i item=country}
            <tr valign="top" {if $i == 0}id="firstProposalCountry" class="proposalCountry"{else}id="proposalCountryField" class="proposalCountrySupp"{/if}>
                <td title="{translate key="proposal.proposalCountryInstruct"}" width="20%" class="proposalCountryTitle" {if $i != 0}style="display:none;"{/if}>[?] {fieldLabel name="proposalCountry" required="true" key="proposal.proposalCountry"}</td>
				<td class="noProposalCountryTitle" {if $i == 0}style="display:none;"{/if}>&nbsp;</td>
                <td width="80%" class="value">
                    <select name="proposalCountry[{$eng|escape}][]" id="proposalCountry" class="selectMenu">
                        <option value=""></option>
		{html_options options=$proposalCountries selected=$proposalCountry[$eng][$i]}
                    </select>
                    <a href="" class="removeProposalProvince" {if $i == 0}style="display:none"{/if}>{translate key="common.remove"}</a>
                </td>
            </tr>
{/foreach}

            <tr id="addAnotherProvince">
                <td width="20%">&nbsp;</td>
                <td><a href="#" id="addAnotherProvince">{translate key="proposal.addAnotherArea"}</a></td>
            </tr>        

{assign var="isOtherResearchFieldSelected" value=false}
{foreach from=$researchField[$eng] key=i item=field}
            <tr valign="top"  {if $i == 0}id="firstResearchField" class="researchField"{else}id="researchFieldField" class="researchFieldSupp"{/if}>
                <td width="20%" class="researchFieldTitle">{if $i == 0}{fieldLabel name="researchField" required="true" key="proposal.researchField"}{else} &nbsp; {/if}</td>
				<td class="noResearchFieldTitle" style="display: none;">&nbsp;</td>
                <td width="80%" class="value">
                    <select name="researchField[{$eng|escape}][]" class="selectMenu" onchange="showOrHideOtherResearchField(this.value);">
                    	<option value=""></option>
                            {foreach from=$researchFields key=if item=rfield}
                            {if $rfield.code != "NA"}
                                {assign var="isSelected" value=false}
                                {foreach from=$researchField[$eng] key=if item=selectedFields}
                                    {if $researchField[$eng][$i] == $rfield.code}
                                        {assign var="isSelected" value=true}
                                    {/if}
                                    {if $researchField[$eng][$i] == "OTHER"}{assign var="isOtherResearchFieldSelected" value=true}{/if}
                                {/foreach}
                                <option value="{$rfield.code}" {if $isSelected==true}selected="selected"{/if} >{$rfield.name}</option>
                            {/if}
                            {/foreach}
                    </select>
                    <a href="" class="removeResearchField" {if $i == 0}style="display:none"{/if}>{translate key="common.remove"}</a>
                </td>
            </tr>           
{/foreach}
            <tr id="addAnotherField">
                <td width="20%">&nbsp;</td>
                <td><a href="#" id="addAnotherField">{translate key="proposal.addAnotherFieldOfResearch"}</a></td>
            </tr>
            
            <tr valign="top" id="otherResearchFieldField" {if $isOtherResearchFieldSelected == false}style="display: none;"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span style="font-style: italic;">{fieldLabel name="otherResearchField" key="proposal.otherResearchField"}</span>&nbsp;&nbsp;
            		<input type="text" class="textField" name="otherResearchField[{$eng|escape}]" id="otherResearchField" value="{if $isOtherResearchFieldSelected == false}NA{else}{$otherResearchField[$eng]|escape}{/if}" size="30" maxlength="255" />
            	</td>
            </tr>
            
            <tr valign="top" id="humanSubjectField">
                <td width="20%" class="label">{fieldLabel name="withHumanSubjects" required="true" key="proposal.withHumanSubjects"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="withHumanSubjects[{$eng|escape}]" id="withHumanSubjects" value="Yes" {if  $withHumanSubjects[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="withHumanSubjects[{$eng|escape}]" id="withHumanSubjects" value="No" {if  $withHumanSubjects[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}
                </td>
            </tr>

{assign var="isOtherProposalTypeSelected" value=false}
{foreach from=$proposalType[$eng] key=i item=type}
            <tr valign="top" {if $i == 0}id="firstProposalType" class="proposalType"{else}id="proposalTypeField" class="proposalTypeSupp"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span style="font-style: italic;">{fieldLabel name="proposalType" required="false" key="proposal.proposalType"}</span>&nbsp;&nbsp;
                    <select name="proposalType[{$eng|escape}][]" id="proposalType" class="selectMenu" onchange="showOrHideOtherProposalType(this.value);">
                        <option value=""></option>
                            {foreach from=$proposalTypes key=id item=ptype}
                            {if $ptype.code != "PNHS"}
                                {assign var="isSelected" value=false}
                                {foreach from=$proposalType[$eng] key=id item=selectedTypes}
                                    {if $proposalType[$eng][$i] == $ptype.code}
                                        {assign var="isSelected" value=true}
                                    {/if}
                                    {if $proposalType[$eng][$i] == "OTHER"}{assign var="isOtherProposalTypeSelected" value=true}{/if}
                                {/foreach}
                                <option value="{$ptype.code}" {if $isSelected==true}selected="selected"{/if} >{$ptype.name}</option>
                            {/if}
                            {/foreach}
                    </select>
                    <a href="" class="removeProposalType" {if $i == 0}style="display:none"{/if}>{translate key="common.remove"}</a>
                </td>
            </tr>
{/foreach}          
            <tr id="addAnotherType">
                <td width="20%">&nbsp;</td>
                <td width="40%"><a href="#" id="addAnotherType">{translate key="proposal.addAnotherProposalType"}</a></td>
            </tr>
            
            <tr valign="top" id="otherProposalTypeField" {if $isOtherProposalTypeSelected == false}style="display: none;"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span style="font-style: italic;">{fieldLabel name="otherProposalType" key="proposal.otherProposalType" required="true"}</span>&nbsp;&nbsp;
            		<input type="text" class="textField" name="otherProposalType[{$eng|escape}]" id="otherProposalType" value="{if $isOtherProposalTypeSelected == false}NA{else}{$otherProposalType[$eng]|escape}{/if}" size="30" maxlength="255" />
            	</td>
            </tr>

            <tr valign="top" id="dataCollectionField">
            	<td width="20%" class="label">{fieldLabel name="dataCollection" required="true" key="proposal.dataCollection"}</td>
            	<td width="80%" class="value">
            		<select name="dataCollection[{$eng|escape}]" class="selectMenu">
            			<option value=""></option>
            			<option value="Primary" {if  $dataCollection[$eng] == "Primary" } selected="selected"{/if}>{translate key="proposal.primaryDataCollection"}</option>
            			<option value="Secondary" {if  $dataCollection[$eng] == "Secondary" } selected="selected"{/if}>{translate key="proposal.secondaryDataCollection"}</option>
            			<option value="Both" {if  $dataCollection[$eng] == "Both" } selected="selected"{/if}>{translate key="proposal.bothDataCollection"}</option>
					</select>
            	</td>
            </tr>

            <tr valign="top" id="otherERCField">
                <td title="{translate key="proposal.reviewedByOtherErcInstruct"}" width="20%" class="label">[?] {fieldLabel name="reviewedByOtherErc" required="true" key="proposal.reviewedByOtherErc"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="reviewedByOtherErc[{$eng|escape}]" id="reviewedByOtherErc" value="Yes" {if  $reviewedByOtherErc[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="reviewedByOtherErc[{$eng|escape}]" id="reviewedByOtherErc" value="No" {if  $reviewedByOtherErc[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}
                </td>
            </tr>

            <tr valign="top" id="otherErcDecisionField">
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span style="font-style: italic;">{fieldLabel name="otherErcDecision" required="false" key="proposal.otherErcDecision"}</span>&nbsp;&nbsp;
                    <select name="otherErcDecision[{$eng|escape}]" id="otherErcDecision" class="selectMenu">
                        <option value="NA"></option>
                        <option value="Under Review" {if  $otherErcDecision[$eng] == "Under Review" } selected="selected"{/if} >{translate key="proposal.otherErcDecisionUnderReview"}</option>
                        <option value="Final Decision Available" {if  $otherErcDecision[$eng] == "Final Decision Available" } selected="selected"{/if} >{translate key="proposal.otherErcDecisionFinalAvailable"}</option>
                    </select>
                </td>
            </tr>
        </table>
    </div>

    <div class="separator"></div>
<!--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////             Source of Monetary              ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
-->
    <div id="sourcesOfGrant">
        <h3>{translate key="proposal.sourceOfMonetary"}</h3>
        <table width="100%" class="data">
        
            <tr><td><br/></td></tr>
            <tr valign="top" id="fundsRequiredField">
                <td width="40%" class="label">{fieldLabel name="fundsRequired" required="true" key="proposal.fundsRequired"}</td>
                <td width="80%" class="value"><input type="text" class="textField" name="fundsRequired[{$eng|escape}]" id="fundsRequired" value="{$fundsRequired[$eng]|escape}" size="20" maxlength="255" /></td>
            </tr>
            <tr valign="top" id="fundsRequiredInstructField">
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value"><span><i>{translate key="proposal.fundsRequiredInstruct"}</i></span></td>
            </tr>
        	<tr valign="top" id="fundsRequiredCurrencyField">
                <td width="20%" class="label"></td>
                <td width="80%" class="value">
                	<input type="radio" name="selectedCurrency[{$eng|escape}]" value="US Dollar(s)" {if  $selectedCurrency[$eng] == "US Dollar(s)" } checked="checked"{/if}  />{translate key="proposal.fundsRequiredUSD"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="selectedCurrency[{$eng|escape}]" value="Euro(s)" {if  $selectedCurrency[$eng] == "Euro(s)" } checked="checked"{/if} />{translate key="proposal.fundsRequiredEUR"}
                </td>
            </tr>
            <tr><td><br/></td></tr>
            
        	<tr valign="top" id="industryGrantField">
                <td width="20%" class="label">{fieldLabel name="industryGrant" required="true" key="proposal.industryGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="industryGrant[{$eng|escape}]" id="industryGrant" value="Yes" {if  $industryGrant[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="industryGrant[{$eng|escape}]" id="industryGrant" value="No" {if  $industryGrant[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}
                </td>
            </tr>
            <tr valign="top" id="nameOfIndustryField"  style="display: none;">
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                    <span style="font-style: italic;">{fieldLabel name="nameOfIndustry" required="true" key="proposal.nameOfIndustry"}</span>&nbsp;&nbsp;
                    <input type="text" name="nameOfIndustry[{$eng|escape}]" id="nameOfIndustry" size="20" value="{$nameOfIndustry[$eng]|escape}" />
                </td>
            </tr>
        	<tr valign="top" id="internationalGrantField">
                <td width="20%" class="label">{fieldLabel name="internationalGrant" required="true" key="proposal.internationalGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="internationalGrant[{$eng|escape}]" id="internationalGrant" value="Yes" {if  $internationalGrant[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="internationalGrant[{$eng|escape}]" id="internationalGrant" value="No" {if  $internationalGrant[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}
                </td>
            </tr>
            
{assign var="isOtherInternationalGrantNameSelected" value=false}
{foreach from=$internationalGrantName[$eng] key=i item=type}
            <tr valign="top" {if $i == 0}id="firstInternationalGrantName" class="internationalGrantName"{else}id="internationalGrantNameField" class="internationalGrantNameSupp"{/if}>
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                	<span style="font-style: italic;" class="internationalGrantNameTitle">{if $i == 0}{fieldLabel name="internationalGrantName" required="true" key="proposal.internationalGrantName"}{/if}</span>&nbsp;&nbsp;
                    <select name="internationalGrantName[{$eng|escape}][]" id="internationalGrantName" class="selectMenu" onchange="showOrHideOtherInternationalGrantName(this.value);">
                        <option value=""></option>
                        {foreach from=$agencies key=id item=igName}
                            {if $igName.code != "NA"}
                                {assign var="isSelected" value=false}
                                {foreach from=$internationalGrantName[$eng] key=id item=selectedTypes}
                                    {if $internationalGrantName[$eng][$i] == $igName.code}
                                        {assign var="isSelected" value=true}
                                    {/if}
                                    {if $internationalGrantName[$eng][$i] == "OTHER"}{assign var="isOtherInternationalGrantNameSelected" value=true}{/if}
                                {/foreach}
                                <option value="{$igName.code}" {if $isSelected==true}selected="selected"{/if} >{$igName.name}</option>
                            {/if}
                        {/foreach}
                    </select>
                    <a href="" class="removeInternationalGrantName" {if $i == 0} style="display:none"{/if}>{translate key="common.remove"}</a>
                </td>
            </tr>
{/foreach} 
            <tr id="addAnotherInternationalGrantName">
                <td width="20%">&nbsp;</td>
                <td width="40%"><a href="#" id="addAnotherInternationalGrantName">{translate key="proposal.addAnotherAgency"}</a></td>
            </tr>
            <tr valign="top" id="otherInternationalGrantNameField" {if $isOtherInternationalGrantNameSelected == false}style="display: none;"{/if}>
                <td width="20%" class="label"></td>
                <td width="80%" class="value">
                <span style="font-style: italic;">{fieldLabel name="otherPrimarySponsor" required="true" key="proposal.otherInternationalGrantName"}</span>&nbsp;&nbsp;
                <input type="text" class="textField" name="otherInternationalGrantName[{$eng|escape}]" id="otherInternationalGrantName" value="{if $isOtherInternationalGrantNameSelected == false}NA{else}{$otherInternationalGrantName[$eng]|escape}{/if}" size="20" maxlength="255" />
                </td>
            </tr>       
        	<tr valign="top" id="mohGrantField">
                <td width="20%" class="label">{fieldLabel name="mohGrant" required="true" key="proposal.mohGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="mohGrant[{$eng|escape}]" id="mohGrant" value="Yes" {if  $mohGrant[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="mohGrant[{$eng|escape}]" id="mohGrant" value="No" {if  $mohGrant[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}
                </td>
            </tr>
        	<tr valign="top" id="governmentGrantField">
                <td width="20%" class="label">{fieldLabel name="governmentGrant" required="true" key="proposal.governmentGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="governmentGrant[{$eng|escape}]" id="governmentGrantY" value="Yes" {if  $governmentGrant[$eng] == "Yes"} checked="checked"{/if}  onclick="showOrHideGovernmentGrant('Yes')"/>{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="governmentGrant[{$eng|escape}]" id="governmentGrant" value="No" {if  $governmentGrant[$eng] == "No" } checked="checked"{/if} onclick="showOrHideGovernmentGrant('No')"/>{translate key="common.no"}
                </td>
            </tr>
            <tr valign="top" id="governmentGrantNameField" style="display: none;">
                <td width="20%" class="label">&nbsp;</td>
                <td width="80%" class="value">
                    <span style="font-style: italic;">{fieldLabel name="governmentGrantName" required="true" key="proposal.governmentGrantName"}</span>&nbsp;&nbsp;
                    <input type="text" name="governmentGrantName[{$eng|escape}]" id="governmentGrantName" size="20" value="{$governmentGrantName[$eng]|escape}" />
                </td>
            </tr>
        	<tr valign="top" id="universityGrantField">
                <td width="20%" class="label">{fieldLabel name="universityGrant" required="true" key="proposal.universityGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="universityGrant[{$eng|escape}]" id="universityGrant" value="Yes" {if  $universityGrant[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="universityGrant[{$eng|escape}]" id="universityGrant" value="No" {if  $universityGrant[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}
                </td>
            </tr>
        	<tr valign="top" id="selfFundingField">
                <td width="20%" class="label">{fieldLabel name="selfFunding" required="true" key="proposal.selfFunding"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="selfFunding[{$eng|escape}]" id="selfFunding" value="Yes" {if  $selfFunding[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="selfFunding[{$eng|escape}]" id="selfFunding" value="No" {if  $selfFunding[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}
                </td>
            </tr>
        	<tr valign="top" id="otherGrantField">
                <td width="20%" class="label">{fieldLabel name="otherGrant" required="true" key="proposal.otherGrant"}</td>
                <td width="80%" class="value">
                    <input type="radio" name="otherGrant[{$eng|escape}]" id="otherGrant" value="Yes" {if  $otherGrant[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="otherGrant[{$eng|escape}]" id="otherGrant" value="No" {if  $otherGrant[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}
                </td>
            </tr>
            <tr valign="top" id="specifyOtherGrantField"  style="display: none;">
            	<td width="20%" class="label">&nbsp;</td>
            	<td width="80%" class="value">
					<span style="font-style: italic;">{fieldLabel name="specifyOtherGrant" required="true" key="proposal.specifyOtherGrantField"}</span>&nbsp;&nbsp;
                    <input type="text" name="specifyOtherGrant[{$eng|escape}]" id="specifyOtherGrant" size="20" value="{$specifyOtherGrant[$eng]|escape}" />
            	</td>
            </tr>
            
        </table>
    </div>
    
    <div class="separator"></div>

<!--
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////               Risk Assessment               ///////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
-->
	<div id="riskAssessment">
		<h3>{translate key="proposal.riskAssessment"}</h3>
        <table width="100%" class="data">
        	<tr valign="top"><td colspan="2">&nbsp;</td></tr>
        	<tr valign="top"><td colspan="2"><b>{translate key="proposal.researchIncludesHumanSubject"}</b></td></tr>
        	<tr valign="top"><td colapse="2">&nbsp;</td></tr>
        	<tr valign="top" id="identityRevealedField">
        		<td width="40%" class="label">{fieldLabel name="identityRevealed" required="true" key="proposal.identityRevealed"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="identityRevealed[{$eng|escape}]" value="Yes" {if  $identityRevealed[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="identityRevealed[{$eng|escape}]" value="No" {if  $identityRevealed[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}       		
        		</td>
        	</tr>
        	<tr valign="top" id="unableToConsentField">
        		<td width="40%" class="label">{fieldLabel name="unableToConsent" required="true" key="proposal.unableToConsent"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="unableToConsent[{$eng|escape}]" value="Yes" {if  $unableToConsent[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="unableToConsent[{$eng|escape}]" value="No" {if  $unableToConsent[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="under18Field">
        		<td width="40%" class="label">{fieldLabel name="under18" required="true" key="proposal.under18"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="under18[{$eng|escape}]" value="Yes" {if  $under18[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="under18[{$eng|escape}]" value="No" {if  $under18[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="dependentRelationshipField">
        		<td width="40%" class="label">{fieldLabel name="dependentRelationship" required="true" key="proposal.dependentRelationship"}<br/><i>{translate key="proposal.dependentRelationshipInstruct"}</i></td>
        		<td width="60%" class="value">
                	<input type="radio" name="dependentRelationship[{$eng|escape}]" value="Yes" {if  $dependentRelationship[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="dependentRelationship[{$eng|escape}]" value="No" {if  $dependentRelationship[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="ethnicMinorityField">
        		<td width="40%" class="label">{fieldLabel name="ethnicMinority" required="true" key="proposal.ethnicMinority"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="ethnicMinority[{$eng|escape}]" value="Yes" {if  $ethnicMinority[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="ethnicMinority[{$eng|escape}]" value="No" {if  $ethnicMinority[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="impairmentField">
        		<td width="40%" class="label">{fieldLabel name="impairment" required="true" key="proposal.impairment"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="impairment[{$eng|escape}]" value="Yes" {if  $impairment[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="impairment[{$eng|escape}]" value="No" {if  $impairment[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="pregnantField">
        		<td width="40%" class="label">{fieldLabel name="pregnant" required="true" key="proposal.pregnant"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="pregnant[{$eng|escape}]" value="Yes" {if  $pregnant[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="pregnant[{$eng|escape}]" value="No" {if  $pregnant[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top"><td colspan="2">&nbsp;</td></tr>
        </table>
        <table width="100%" class="data">
        	<tr valign="top"><td colspan="2"><b>{translate key="proposal.researchIncludes"}</b></td></tr>
        	<tr valign="top"><td colapse="2">&nbsp;</td></tr>
        	<tr valign="top" id="newTreatmentField">
        		<td width="40%" class="label">{fieldLabel name="newTreatment" required="true" key="proposal.newTreatment"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="newTreatment[{$eng|escape}]" value="Yes" {if  $newTreatment[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="newTreatment[{$eng|escape}]" value="No" {if  $newTreatment[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="bioSamplesField">
        		<td width="40%" class="label">{fieldLabel name="bioSamples" required="true" key="proposal.bioSamples"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="bioSamples[{$eng|escape}]" value="Yes" {if  $bioSamples[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="bioSamples[{$eng|escape}]" value="No" {if  $bioSamples[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="radiationField">
        		<td width="40%" class="label">{fieldLabel name="radiation" required="true" key="proposal.radiation"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="radiation[{$eng|escape}]" value="Yes" {if  $radiation[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="radiation[{$eng|escape}]" value="No" {if  $radiation[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="distressField">
        		<td width="40%" class="label">{fieldLabel name="distress" required="true" key="proposal.distress"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="distress[{$eng|escape}]" value="Yes" {if  $distress[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="distress[{$eng|escape}]" value="No" {if  $distress[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="inducementsField">
        		<td width="40%" class="label">{fieldLabel name="inducements" required="true" key="proposal.inducements"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="inducements[{$eng|escape}]" value="Yes" {if  $inducements[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="inducements[{$eng|escape}]" value="No" {if  $inducements[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="sensitiveInfoField">
        		<td width="40%" class="label">{fieldLabel name="sensitiveInfo" required="true" key="proposal.sensitiveInfo"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="sensitiveInfo[{$eng|escape}]" value="Yes" {if  $sensitiveInfo[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="sensitiveInfo[{$eng|escape}]" value="No" {if  $sensitiveInfo[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="deceptionField">
        		<td width="40%" class="label">{fieldLabel name="deception" required="true" key="proposal.deception"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="deception[{$eng|escape}]" value="Yes" {if  $deception[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="deception[{$eng|escape}]" value="No" {if  $deception[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="reproTechnologyField">
        		<td width="40%" class="label">{fieldLabel name="reproTechnology" required="true" key="proposal.reproTechnology"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="reproTechnology[{$eng|escape}]" value="Yes" {if  $reproTechnology[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="reproTechnology[{$eng|escape}]" value="No" {if  $reproTechnology[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="geneticsField">
        		<td width="40%" class="label">{fieldLabel name="genetics" required="true" key="proposal.genetics"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="genetics[{$eng|escape}]" value="Yes" {if  $genetics[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="genetics[{$eng|escape}]" value="No" {if  $genetics[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="stemCellField">
        		<td width="40%" class="label">{fieldLabel name="stemCell" required="true" key="proposal.stemCell"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="stemCell[{$eng|escape}]" value="Yes" {if  $stemCell[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="stemCell[{$eng|escape}]" value="No" {if  $stemCell[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="biosafetyField">
        		<td width="40%" class="label">{fieldLabel name="biosafety" required="true" key="proposal.biosafety"}</td>
        		<td width="60%" class="value">
                	<input type="radio" name="biosafety[{$eng|escape}]" value="Yes" {if  $biosafety[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="biosafety[{$eng|escape}]" value="No" {if  $biosafety[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="exportField">
        		<td width="40%" class="label"><br/><b>{fieldLabel name="export" required="true" key="proposal.export"}</b></td>
        		<td width="60%" class="value">
        			<br/>
                	<input type="radio" name="export[{$eng|escape}]" value="Yes" {if  $export[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="export[{$eng|escape}]" value="No" {if  $export[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top"><td colspan="2">&nbsp;</td></tr>
        </table>
        <table width="100%" class="data">
        	<tr valign="top"><td colspan="2"><b>{translate key="proposal.potentialRisk"}</b></td></tr>
        	<tr valign="top"><td colapse="2">&nbsp;</td></tr>
        	<tr valign="top" id="riskLevelField">
        		<td title="Minimal risk means that the probability and magnitude of harm or discomfort anticipated in the research are not greater in and of themselves than those ordinarily encountered in daily life or during the performance of routine physical or psychological examination or tests." width="30%" class="label">[?] {fieldLabel name="riskLevel" required="true" key="proposal.riskLevel"}</td>
        		<td width="70%" class="value">
            		<select name="riskLevel[{$eng|escape}]" class="selectMenu" id="riskLevel">
            			<option value=""></option>
            			<option value="No more than minimal risk" {if  $riskLevel[$eng] == "No more than minimal risk" } selected="selected"{/if}>{translate key="proposal.riskLevelNoMore"}</option>
            			<option value="Minor increase over minimal risk" {if  $riskLevel[$eng] == "Minor increase over minimal risk" } selected="selected"{/if}>{translate key="proposal.riskLevelMinore"}</option>
            			<option value="More than minor increase over minimal risk" {if  $riskLevel[$eng] == "More than minor increase over minimal risk" } selected="selected"{/if}>{translate key="proposal.riskLevelMore"}</option>
					</select>
				</td>
        	</tr>
        	<tr valign="top" id="listRisksField">
                <td width="30%" class="label">{fieldLabel name="listRisks" required="true" key="proposal.listRisks"}</td>
                <td width="70%" class="value">
                    <textarea name="listRisks[{$eng|escape}]" class="textArea" id="listRisks" rows="5" cols="40">{$listRisks[$eng]|escape}</textarea><br/>
                </td>
            </tr>
            <tr valign="top" id="howRisksMinimizedField">
                <td width="30%" class="label">{fieldLabel name="howRisksMinimized" required="true" key="proposal.howRisksMinimized"}</td>
                <td width="70%" class="value">
                    <textarea name="howRisksMinimized[{$eng|escape}]" class="textArea" id="howRisksMinimized" rows="5" cols="40">{$howRisksMinimized[$eng]|escape}</textarea><br/>
                </td>
            </tr>
            <tr valign="top" id="riskApplyToField">
                <td width="30%" class="label">{fieldLabel name="riskApplyTo" key="proposal.riskApplyTo"}</td>
                <td width="70%" class="value">
                	<input type="hidden" name="riskApplyTo[{$eng|escape}][0]" value="0"/><input type="checkbox" name="riskApplyTo[{$eng|escape}][0]" value="1" {if $riskApplyTo[$eng][0] == '1'}checked="checked"{/if}/>{translate key="proposal.researchTeam"}<br/>
                	<input type="hidden" name="riskApplyTo[{$eng|escape}][1]" value="0"/><input type="checkbox" name="riskApplyTo[{$eng|escape}][1]" value="1" {if $riskApplyTo[$eng][1] == '1'}checked="checked"{/if}/>{translate key="proposal.researchSubjects"}<br/>
                	<input type="hidden" name="riskApplyTo[{$eng|escape}][2]" value="0"/><input type="checkbox" name="riskApplyTo[{$eng|escape}][2]" value="1" {if $riskApplyTo[$eng][2] == '1'}checked="checked"{/if}/>{translate key="proposal.widerCommunity"}
                </td>
            </tr>
        	<tr valign="top"><td colapse="2">&nbsp;</td></tr>
        </table>
        <table width="100%" class="data">
        	<tr valign="top"><td colspan="2"><b>{translate key="proposal.potentialBenefits"}</b></td></tr>
        	<tr valign="top"><td colapse="2">&nbsp;</td></tr>
           	<tr valign="top" id="benefitsFromTheProjectField">
                <td width="30%" class="label">{fieldLabel name="benefitsFromTheProject" key="proposal.benefitsFromTheProject"}</td>
                <td width="70%" class="value">
                	<input type="hidden" name="benefitsFromTheProject[{$eng|escape}][0]" value="0"/><input type="checkbox" name="benefitsFromTheProject[{$eng|escape}][0]" value="1" {if $benefitsFromTheProject[$eng][0] == '1'}checked="checked"{/if}/>{translate key="proposal.directBenefits"}<br/>
                	<input type="hidden" name="benefitsFromTheProject[{$eng|escape}][1]" value="0"/><input type="checkbox" name="benefitsFromTheProject[{$eng|escape}][1]" value="1" {if $benefitsFromTheProject[$eng][1] == '1'}checked="checked"{/if}/>{translate key="proposal.participantCondition"}<br/>
                	<input type="hidden" name="benefitsFromTheProject[{$eng|escape}][2]" value="0"/><input type="checkbox" name="benefitsFromTheProject[{$eng|escape}][2]" value="1" {if $benefitsFromTheProject[$eng][2] == '1'}checked="checked"{/if}/>{translate key="proposal.diseaseOrCondition"}
                </td>
            </tr>
        	<tr valign="top" id="multiInstitutionsField">
        		<td width="30%" class="label">{fieldLabel name="multiInstitutions" required="true" key="proposal.multiInstitutions"}</td>
        		<td width="70%" class="value">
                	<input type="radio" name="multiInstitutions[{$eng|escape}]" value="Yes" {if  $multiInstitutions[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="multiInstitutions[{$eng|escape}]" value="No" {if  $multiInstitutions[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}        		
        		</td>
        	</tr>
        	<tr valign="top" id="conflictOfInterestField">
        		<td title="{translate key="proposal.conflictOfInterestInstruct"}" width="30%" class="label">{fieldLabel name="conflictOfInterest" required="true" key="proposal.conflictOfInterest"}</td>
        		<td width="70%" class="value">
                	<input type="radio" name="conflictOfInterest[{$eng|escape}]" value="Yes" {if  $conflictOfInterest[$eng] == "Yes" } checked="checked"{/if}  />{translate key="common.yes"}
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="conflictOfInterest[{$eng|escape}]" value="No" {if  $conflictOfInterest[$eng] == "No" } checked="checked"{/if} />{translate key="common.no"}  
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input type="radio" name="conflictOfInterest[{$eng|escape}]" value="Not sure" {if  $conflictOfInterest[$eng] == "Not sure" } checked="checked"{/if} />{translate key="common.notSure"}
        		</td>
        	</tr>
        </table>
	</div>

	<div class="separator"></div>
    
    <p><input type="submit" value="{translate key="common.saveAndContinue"}" class="button defaultButton"  onclick="return isNumeric(document.getElementById('fundsRequired'), 'The estimated budget should be numeric.')"/> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="confirmAction('{url page="author"}', '{translate|escape:"jsparam" key="author.submit.cancelSubmission"}')" /></p>

</form>

{if $scrollToAuthor}
	{literal}
<script type="text/javascript">
        var authors = document.getElementById('authors');
        authors.scrollIntoView(false);
</script>
	{/literal}
{/if}

{include file="common/footer.tpl"}

