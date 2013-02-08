{**
 * complete.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * The submission process has been completed; notify the author.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="author.track"}
{include file="common/header.tpl"}
{/strip}

{assign var="cam" value="kh_CA"}
{assign var="eng" value="en_US"}

<p style="font-size: larger;">{translate key="author.submit.submissionComplete" journalTitle=$journal->getLocalizedTitle()}</p>

<h3>{translate key="article.metadata"}</h3>
<table class="listing" width="100%">
	<div id="proposalDetails">
    <tr valign="top">
        <td colspan="5" class="headseparator">&nbsp;</td>
    </tr>
{foreach name=authors from=$article->getAuthors() item=author}
	<tr valign="top" id="authorFields">
        <td class="label" width="40%">{if $author->getPrimaryContact()}{translate key="user.role.author"}{else}{translate key="user.role.coinvestigator"}{/if}</td>
        <td class="value">
			{$author->getFullName()|escape}<br />
			{$author->getEmail()|escape}<br />
			{if ($author->getLocalizedAffiliation()) != ""}{$author->getLocalizedAffiliation()|escape}<br/>{/if}
			{if $author->getPrimaryContact()}{$article->getLocalizedAuthorPhoneNumber()}
			{else}
			{if ($author->getUrl()) != ""}{$author->getUrl()|escape}{/if}
			{/if}
        </td>
    </tr>
{/foreach}
	<tr valign="top"><td colspan="2"><h4>{translate key="submission.titleAndAbstract"}</h4></td></tr>	
    <tr valign="top" id="engScientificTitleField">
        <td class="label" width="20%">{translate key="proposal.engScientificTitle"}</td>
        <td class="value">{$article->getScientificTitle($eng)}</td>
    </tr>
    <tr valign="top" id="camScientificTitleField">
        <td class="label" width="20%">{translate key="proposal.camScientificTitle"}</td>
        <td class="value">{$article->getScientificTitle($cam)}</td>
    </tr>
    <!--<tr valign="top" id="engPublicTitleField">
        <td class="label" width="20%">{translate key="proposal.engPublicTitle"}</td>
        <td class="value">{$article->getPublicTitle($eng)}</td>
    </tr>
    <tr valign="top" id="camPublicTitleField">
        <td class="label" width="20%">{translate key="proposal.camPublicTitle"}</td>
        <td class="value">{$article->getPublicTitle($cam)}</td>
    </tr>-->
    <tr valign="top" id="engAbstractField">
        <td class="label" width="20%">{translate key="proposal.engAbstract"}</td>
        <td class="value">
        	{translate key="proposal.background"}<br/>{$article->getBackground($eng)}<br/><br/>
        	{translate key="proposal.objectives"}<br/>{$article->getObjectives($eng)}<br/><br/>
        	{translate key="proposal.studyMatters"}<br/>{$article->getStudyMatters($eng)}<br/><br/>
        	{translate key="proposal.expectedOutcomes"}<br/>{$article->getExpectedOutcomes($eng)}<br/><br/>
        </td>
    </tr>
    <tr valign="top" id="camAbstractField">
        <td class="label" width="20%">{translate key="proposal.camAbstract"}</td>
        <td class="value">
        	{translate key="proposal.background"}<br/>{$article->getBackground($cam)}<br/><br/>
        	{translate key="proposal.objectives"}<br/>{$article->getObjectives($cam)}<br/><br/>
        	{translate key="proposal.studyMatters"}<br/>{$article->getStudyMatters($cam)}<br/><br/>
        	{translate key="proposal.expectedOutcomes"}<br/>{$article->getExpectedOutcomes($cam)}<br/><br/>
        </td>
    </tr>
    <tr valign="top" id="engKeywords">
        <td class="label" width="20%">{translate key="proposal.engKeywords"}</td>
        <td class="value">{$article->getKeywords($eng)}</td>
    </tr>
    <tr valign="top" id="camKeywords">
        <td class="label" width="20%">{translate key="proposal.camKeywords"}</td>
        <td class="value">{$article->getKeywords($cam)}</td>
    </tr>
	<tr valign="top"><td colspan="2"><h4>{translate key="submission.proposalDetails"}</h4></td></tr>
	<tr valign="top" id="studentInitiatedResearchField">
        <td class="label" width="20%">{translate key="proposal.studentInitiatedResearch"}</td>
        <td class="value">{if $article->getStudentInitiatedResearch($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($article->getStudentInitiatedResearch($eng)) == "Yes"}
    <tr valign="top" id="studentInstitutionField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.studentInstitution"}: {$article->getStudentInstitution($eng)}</td>
    </tr>
    <tr valign="top" id="academicDegreeField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.academicDegree"} 
        	{if $article->getAcademicDegree($eng) == "Undergraduate"}{translate key="proposal.undergraduate"}
        	{elseif $article->getAcademicDegree($eng) == "Master"}{translate key="proposal.master"}
        	{elseif $article->getAcademicDegree($eng) == "Post-Doc"}{translate key="proposal.postDoc"}
        	{elseif $article->getAcademicDegree($eng) == "Ph.D"}{translate key="proposal.phd"}
        	{elseif $article->getAcademicDegree($eng) == "Other"}{translate key="common.other"}
        	{/if}
        </td>
    </tr>
    <tr valign="top" id="supervisorField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.supervisor"}:</td>
    </tr>
    <tr valign="top" id="supervisorFullNameField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.supervisorFullName"}: {$article->getSupervisorFullName($eng)}</td>
    </tr>
    <tr valign="top" id="supervisorEmailField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="user.email"}: {$article->getSupervisorEmail($eng)}</td>
    </tr>
    <tr valign="top" id="supervisorPhoneField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="user.phone"}: {$article->getSupervisorPhone($eng)}</td>
    </tr>
    <tr valign="top" id="supervisorAffiliationField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="user.affiliation"}: {$article->getSupervisorAffiliation($eng)}</td>
    </tr>
    {/if}
    <tr valign="top" id="startDateField">
        <td class="label" width="20%">{translate key="proposal.startDate"}</td>
        <td class="value">{$article->getStartDate($eng)}</td>
    </tr>
    <tr valign="top" id="endDateField">
        <td class="label" width="20%">{translate key="proposal.endDate"}</td>
        <td class="value">{$article->getEndDate($eng)}</td>
    </tr>
    <tr valign="top" id="primarySponsorField">
        <td class="label" width="20%">{translate key="proposal.primarySponsor"}</td>
        <td class="value">
        	{if $article->getLocalizedPrimarySponsor()}
        		{$article->getLocalizedPrimarySponsorText()}
        	{/if}
    	</td>
    </tr>    
    {if $article->getLocalizedSecondarySponsors()}
    <tr valign="top" id="secondarySponsorsField">
        <td class="label" width="20%">{translate key="proposal.secondarySponsors"}</td>
        <td class="value">
        	{if $article->getLocalizedSecondarySponsors()}
        		{$article->getLocalizedSecondarySponsorText()}
        	{/if} 
        </td>
    </tr>
    {/if}
    <tr valign="top" id="multiCountryResearchField">
        <td class="label" width="20%">{translate key="proposal.multiCountryResearch"}</td>
        <td class="value">{if $article->getMultiCountryResearch($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
	{if ($article->getMultiCountryResearch($eng)) == "Yes"}
	<tr valign="top" id="multiCountryTextField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getLocalizedMultiCountryText()}</td>
    </tr>
	{/if}
    <tr valign="top" id="nationwideField">
        <td class="label" width="20%">{translate key="proposal.nationwide"}</td>
        <td class="value">{$article->getNationwide($eng)}</td>
    </tr>
    <tr valign="top" id="proposalCountryField">
        <td class="label" width="20%">{translate key="proposal.proposalCountry"}</td>
        <td class="value">{$article->getLocalizedProposalCountryText()}</td>
    </tr>
    <tr valign="top" id="researchFieldField">
        <td class="label" width="20%">{translate key="proposal.researchField"}</td>
        <td class="value">
        	{if $article->getLocalizedResearchField()}
        		{$article->getLocalizedResearchFieldText()}
        	{/if}
        </td>
    </tr>
    <tr valign="top" id="withHumanSubjectsField">
        <td class="label" width="20%">{translate key="proposal.withHumanSubjects"}</td>
        <td class="value">{if $article->getWithHumanSubjects($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($article->getWithHumanSubjects($eng)) == "Yes"}
    <tr valign="top" id="proposalTypeField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">
        	{if ($article->getLocalizedProposalType())}
        		{$article->getLocalizedProposalTypeText()}
        	{/if}      
        </td>
    </tr>
    {/if}    
     <tr valign="top" id="dataCollectionField">
        <td class="label" width="20%">{translate key="proposal.dataCollection"}</td>
        <td class="value">
        	{if $article->getDataCollection($eng) == "Primary"}{translate key="proposal.primaryDataCollection"}
        	{elseif $article->getDataCollection($eng) == "Secondary"}{translate key="proposal.secondaryDataCollection"}
        	{elseif $article->getDataCollection($eng) == "Both"}{translate key="proposal.bothDataCollection"}
        	{/if}
        </td>
    </tr>   
    <tr valign="top" id="reviewedByOtherErcField">
        <td class="label" width="20%">{translate key="proposal.reviewedByOtherErc"}</td>
        <td class="value">
        	{if $article->getReviewedByOtherErc($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}        
        	{if $article->getOtherErcDecision($eng) == 'Under Review'}({translate key="proposal.otherErcDecisionUnderReview"})
        	{elseif $article->getOtherErcDecision($eng) == 'Final Decision Available'}({translate key="proposal.otherErcDecisionFinalAvailable"})
        	{/if}
        </td>
    </tr>
    </div>
	<div id="sourceOfMonetary">
	<tr valign="top"><td colspan="2"><h4>{translate key="proposal.sourceOfMonetary"}</h4></td></tr>
    <tr valign="top" id="fundsRequiredField">
        <td class="label" width="20%">{translate key="proposal.fundsRequired"}</td>
        <td class="value">{$article->getFundsRequired($eng)} {if $article->getSelectedCurrency($eng) == "US Dollar(s)"}{translate key="proposal.fundsRequiredUSD"}{else}{translate key="proposal.fundsRequiredEUR"}{/if}</td>
    </tr>
    <tr valign="top" id="industryGrantField">
        <td class="label" width="20%">{translate key="proposal.industryGrant"}</td>
        <td class="value">{if $article->getIndustryGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($article->getIndustryGrant($eng)) == "Yes"}
     <tr valign="top" id="nameOfIndustryField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getNameOfIndustry($eng)}</td>
    </tr>   
    {/if}
    <tr valign="top" id="internationalGrantField">
        <td class="label" width="20%">{translate key="proposal.internationalGrant"}</td>
        <td class="value">{if $article->getInternationalGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($article->getInternationalGrant($eng)) == "Yes"}
     <tr valign="top" id="internationalGrantNameField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">
        	{if $article->getLocalizedInternationalGrantName()}
        		{$article->getLocalizedInternationalGrantNameText()} 
        	{/if}        
        </td>
    </tr>     
    {/if}
    <tr valign="top" id="mohGrantField">
        <td class="label" width="20%">{translate key="proposal.mohGrant"}</td>
        <td class="value">{if $article->getMohGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="governmentGrantField">
        <td class="label" width="20%">{translate key="proposal.governmentGrant"}</td>
        <td class="value">{if $article->getGovernmentGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($article->getGovernmentGrant($eng)) == "Yes"}
     <tr valign="top" id="governmentGrantNameField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getGovernmentGrantName($eng)}</td>
    </tr>     
    {/if}
    <tr valign="top" id="universityGrantField">
        <td class="label" width="20%">{translate key="proposal.universityGrant"}</td>
        <td class="value">{if $article->getUniversityGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="selfFundingField">
        <td class="label" width="20%">{translate key="proposal.selfFunding"}</td>
        <td class="value">{if $article->getSelfFunding($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="otherGrantField">
        <td class="label" width="20%">{translate key="proposal.otherGrant"}</td>
        <td class="value">{if $article->getOtherGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($article->getOtherGrant($eng)) == "Yes"}
     <tr valign="top" id="specifyOtherGrantField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$article->getSpecifyOtherGrant($eng)}</td>
    </tr>    
    {/if}
    </div>
    <div id=riskAssessments>
    <tr><td colspan="2"><h4>{translate key="proposal.riskAssessment"}</h4></td></tr>
    <tr valign="top"><td colspan="2"><b>{translate key="proposal.researchIncludesHumanSubject"}</b></td></tr>
    <tr valign="top" id="identityRevealedField">
        <td class="label" width="20%">{translate key="proposal.identityRevealed"}</td>
        <td class="value">{if $article->getIdentityRevealed($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="unableToConsentField">
        <td class="label" width="20%">{translate key="proposal.unableToConsent"}</td>
        <td class="value">{if $article->getUnableToConsent($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="under18Field">
        <td class="label" width="20%">{translate key="proposal.under18"}</td>
        <td class="value">{if $article->getUnder18($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="dependentRelationshipField">
        <td class="label" width="20%">{translate key="proposal.dependentRelationship"}</td>
        <td class="value">{if $article->getDependentRelationship($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="ethnicMinorityField">
        <td class="label" width="20%">{translate key="proposal.ethnicMinority"}</td>
        <td class="value">{if $article->getEthnicMinority($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="impairmentField">
        <td class="label" width="20%">{translate key="proposal.impairment"}</td>
        <td class="value">{if $article->getImpairment($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="pregnantField">
        <td class="label" width="20%">{translate key="proposal.pregnant"}</td>
        <td class="value">{if $article->getPregnant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.researchIncludes"}</b></td></tr>
    <tr valign="top" id="newTreatmentField">
        <td class="label" width="20%">{translate key="proposal.newTreatment"}</td>
        <td class="value">{if $article->getNewTreatment($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="bioSamplesField">
        <td class="label" width="20%">{translate key="proposal.bioSamples"}</td>
        <td class="value">{if $article->getBioSamples($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="radiationField">
        <td class="label" width="20%">{translate key="proposal.radiation"}</td>
        <td class="value">{if $article->getRadiation($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="distressField">
        <td class="label" width="20%">{translate key="proposal.distress"}</td>
        <td class="value">{if $article->getDistress($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="inducementsField">
        <td class="label" width="20%">{translate key="proposal.inducements"}</td>
        <td class="value">{if $article->getInducements($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="sensitiveInfoField">
        <td class="label" width="20%">{translate key="proposal.sensitiveInfo"}</td>
        <td class="value">{if $article->getSensitiveInfo($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="deceptionField">
        <td class="label" width="20%">{translate key="proposal.deception"}</td>
        <td class="value">{if $article->getDeception($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="reproTechnologyField">
        <td class="label" width="20%">{translate key="proposal.reproTechnology"}</td>
        <td class="value">{if $article->getReproTechnology($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="geneticsField">
        <td class="label" width="20%">{translate key="proposal.genetics"}</td>
        <td class="value">{if $article->getGenetics($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="stemCellField">
        <td class="label" width="20%">{translate key="proposal.stemCell"}</td>
        <td class="value">{if $article->getStemCell($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="biosafetyField">
        <td class="label" width="20%">{translate key="proposal.biosafety"}</td>
        <td class="value">{if $article->getBiosafety($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="exportField">
        <td class="label" width="20%">{translate key="proposal.export"}</td>
        <td class="value">{if $article->getExport($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.researchIncludes"}</b></td></tr>
    <tr valign="top" id="riskLevelField">
        <td class="label" width="20%">{translate key="proposal.riskLevel"}</td>
        <td class="value">
        {if $article->getRiskLevel($eng) == "No more than minimal risk"}{translate key="proposal.riskLevelNoMore"}
        {elseif $article->getRiskLevel($eng) == "Minor increase over minimal risk"}{translate key="proposal.riskLevelMinore"}
        {elseif $article->getRiskLevel($eng) == "More than minor increase over minimal risk"}{translate key="proposal.riskLevelMore"}
        {/if}
        </td>
    </tr>
    {if $article->getRiskLevel($eng) != 'No more than minimal risk'}
    <tr valign="top" id="listRisksField">
        <td class="label" width="20%">{translate key="proposal.listRisks"}</td>
        <td class="value">{$article->getListRisks($eng)}</td>
    </tr>
    <tr valign="top" id="howRisksMinimizedField">
        <td class="label" width="20%">{translate key="proposal.howRisksMinimized"}</td>
        <td class="value">{$article->getHowRisksMinimized($eng)}</td>
    </tr>
    {/if}
    <tr valign="top" id="riskApplyToField">
        <td class="label" width="20%">{translate key="proposal.riskApplyTo"}</td>
        <td class="value">
        {assign var="riskApplyTo" value=$article->getRiskApplyTo()}
        {assign var="firstRisk" value="0"}
        {if $riskApplyTo[$eng][0] == '1'}
        	{if $firstRisk == '1'} & {/if}{translate key="proposal.researchTeam"}
        	{assign var="firstRisk" value="1"}	
        {/if}
        {if $riskApplyTo[$eng][1] == '1'}
        	{if $firstRisk == '1'} & {/if}{translate key="proposal.researchSubjects"}
        	{assign var="firstRisk" value="1"}
        {/if}
        {if $riskApplyTo[$eng][2] == '1'}
        	{if $firstRisk == '1'} & {/if}{translate key="proposal.widerCommunity"}
        	{assign var="firstRisk" value="1"}
        {/if}
        {if $riskApplyTo[$eng][0] != '1' && $riskApplyTo[$eng][1] != '1' && $riskApplyTo[$eng][2] != '1'}
        	{translate key="proposal.nobody"}
        {/if}
        </td>
    </tr>
    <tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.potentialBenefits"}</b></td></tr>
    <tr valign="top" id="benefitsFromTheProjectField">
        <td class="label" width="20%">{translate key="proposal.benefitsFromTheProject"}</td>
        <td class="value">
        {assign var="benefitsFrom" value=$article->getBenefitsFromTheProject()}
        {assign var="firstBenefits" value="0"}
        {if $benefitsFrom[$eng][0] == '1'}
        	{if $firstBenefits == '1'} & {/if}{translate key="proposal.directBenefits"}
        	{assign var="firstBenefits" value="1"}
        {/if}
        {if $benefitsFrom[$eng][1] == '1'}
        	{if $firstBenefits == '1'} & {/if}{translate key="proposal.participantCondition"}
        	{assign var="firstBenefits" value="1"}
        {/if}
        {if $benefitsFrom[$eng][2] == '1'}
        	{if $firstBenefits == '1'} & {/if}{translate key="proposal.diseaseOrCondition"}
        	{assign var="firstBenefits" value="1"}
        {/if}
        {if $benefitsFrom[$eng][0] != '1' && $benefitsFrom[$eng][1] != '1' && $benefitsFrom[$eng][2] != '1'}
        	{translate key="proposal.noBenefits"}
        {/if}
        </td>
    </tr>
    <tr valign="top" id="multiInstitutionsField">
        <td class="label" width="20%">{translate key="proposal.multiInstitutions"}</td>
        <td class="value">{if $article->getMultiInstitutions($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="conflictOfInterestField">
        <td class="label" width="20%">{translate key="proposal.conflictOfInterest"}</td>
        <td class="value">{if $article->getConflictOfInterest($eng) == "Yes"}{translate key="common.yes"}{elseif $article->getConflictOfInterest($eng) == "Not sure"}{translate key="common.notSure"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    </div>
</table>
<div class="separator"></div>

<br />

<h3>{translate key="author.submit.filesSummary"}</h3>
<table class="listing" width="100%">
<tr>
	<td colspan="5" class="headseparator">&nbsp;</td>
</tr>
<tr class="heading" valign="bottom">
	<td width="10%">{translate key="common.id"}</td>
	<td width="35%">{translate key="common.originalFileName"}</td>
	<td width="25%">{translate key="common.type"}</td>
	<td width="20%" class="nowrap">{translate key="common.fileSize"}</td>
	<td width="10%" class="nowrap">{translate key="common.dateUploaded"}</td>
</tr>
<tr>
	<td colspan="5" class="headseparator">&nbsp;</td>
</tr>
{foreach from=$files item=file}
{if ($file->getType() == 'supp' || $file->getType() == 'submission/original')}
<tr valign="top">
	<td>{$file->getFileId()}</td>
	<td><a class="file" href="{url op="download" path=$articleId|to_array:$file->getFileId()}">{$file->getOriginalFileName()|escape}</a></td>
	<td>{if ($file->getType() == 'supp')}{translate key="article.suppFile"}{else}{translate key="author.submit.submissionFile"}{/if}</td>
	<td>{$file->getNiceFileSize()}</td>
	<td>{$file->getDateUploaded()|date_format:$dateFormatTrunc}</td>
</tr>
{/if}
{foreachelse}
<tr valign="top">
<td colspan="5" class="nodata">{translate key="author.submit.noFiles"}</td>
</tr>
{/foreach}
</table>

<div class="separator"></div>

<br />
<!--
{if $canExpedite}
	{url|assign:"expediteUrl" op="expediteSubmission" articleId=$articleId}
	{translate key="author.submit.expedite" expediteUrl=$expediteUrl}
{/if}
{if $paymentButtonsTemplate }
	{include file=$paymentButtonsTemplate orientation="vertical"}
{/if}
-->

<p>&#187; <a href="{url op="index"}">{translate key="author.track"}</a></p>

{include file="common/footer.tpl"}

