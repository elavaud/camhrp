{**
 * metadata.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Subtemplate defining the submission metadata table. Non-form implementation.
 *}
{assign var="cam" value="kh_CA"}
{assign var="eng" value="en_US"}
{assign var="status" value=$submission->getSubmissionStatus()}
{assign var="decision" value=$submission->getMostRecentDecision()}

<div id="metadata">
{if $canEditMetadata && $isSectionEditor && $status!=PROPOSAL_STATUS_COMPLETED && $status!=PROPOSAL_STATUS_ARCHIVED && $decision!=SUBMISSION_EDITOR_DECISION_EXEMPTED && $decision!=SUBMISSION_EDITOR_DECISION_ACCEPT}
	<p><a href="{url op="viewMetadata" path=$submission->getId()}" class="action">{translate key="submission.editMetadata"}</a></p>
	{call_hook name="Templates::Submission::Metadata::Metadata::AdditionalEditItems"}
{/if}
<h3>{translate key="user.role.authors"}</h3>
<table class="listing" width="100%">
	<div id="proposalDetails">
{foreach name=authors from=$submission->getAuthors() item=author}
	<tr valign="top" id="authorFields">
        <td class="label" width="40%">{if $author->getPrimaryContact()}{translate key="user.role.author"}{else}{translate key="user.role.coinvestigator"}{/if}</td>
        <td class="value">
			{$author->getFullName()|escape}<br />
			{$author->getEmail()|escape}<br />
			{if ($author->getLocalizedAffiliation()) != ""}{$author->getLocalizedAffiliation()|escape}<br/>{/if}
			{if $author->getPrimaryContact()}{$submission->getLocalizedAuthorPhoneNumber()}
			{else}
			{if ($author->getUrl()) != ""}{$author->getUrl()|escape}{/if}
			{/if}
        </td>
    </tr>
{/foreach}
	<tr valign="top"><td colspan="2"><h4>{translate key="submission.titleAndAbstract"}</h4></td></tr>	
    <tr valign="top" id="engScientificTitleField">
        <td class="label" width="20%">{translate key="proposal.engScientificTitle"}</td>
        <td class="value">{$submission->getScientificTitle($eng)}</td>
    </tr>
    <tr valign="top" id="camScientificTitleField">
        <td class="label" width="20%">{translate key="proposal.camScientificTitle"}</td>
        <td class="value">{$submission->getScientificTitle($cam)}</td>
    </tr>
    <tr valign="top" id="engPublicTitleField">
        <td class="label" width="20%">{translate key="proposal.engPublicTitle"}</td>
        <td class="value">{$submission->getPublicTitle($eng)}</td>
    </tr>
    <tr valign="top" id="camPublicTitleField">
        <td class="label" width="20%">{translate key="proposal.camPublicTitle"}</td>
        <td class="value">{$submission->getPublicTitle($cam)}</td>
    </tr>
    <tr valign="top" id="engAbstractField">
        <td class="label" width="20%">{translate key="proposal.engAbstract"}</td>
        <td class="value">
        	{translate key="proposal.background"}<br/>{$submission->getBackground($eng)}<br/><br/>
        	{translate key="proposal.objectives"}<br/>{$submission->getObjectives($eng)}<br/><br/>
        	{translate key="proposal.studyMatters"}<br/>{$submission->getStudyMatters($eng)}<br/><br/>
        	{translate key="proposal.expectedOutcomes"}<br/>{$submission->getExpectedOutcomes($eng)}<br/><br/>
        </td>
    </tr>
    <tr valign="top" id="camAbstractField">
        <td class="label" width="20%">{translate key="proposal.camAbstract"}</td>
        <td class="value">
        	{translate key="proposal.background"}<br/>{$submission->getBackground($cam)}<br/><br/>
        	{translate key="proposal.objectives"}<br/>{$submission->getObjectives($cam)}<br/><br/>
        	{translate key="proposal.studyMatters"}<br/>{$submission->getStudyMatters($cam)}<br/><br/>
        	{translate key="proposal.expectedOutcomes"}<br/>{$submission->getExpectedOutcomes($cam)}<br/><br/>
        </td>
    </tr>
    <tr valign="top" id="engKeywords">
        <td class="label" width="20%">{translate key="proposal.engKeywords"}</td>
        <td class="value">{$submission->getKeywords($eng)}</td>
    </tr>
    <tr valign="top" id="camKeywords">
        <td class="label" width="20%">{translate key="proposal.camKeywords"}</td>
        <td class="value">{$submission->getKeywords($cam)}</td>
    </tr>
	<tr valign="top"><td colspan="2"><h4>{translate key="submission.proposalDetails"}</h4></td></tr>
	<tr valign="top" id="studentInitiatedResearchField">
        <td class="label" width="20%">{translate key="proposal.studentInitiatedResearch"}</td>
        <td class="value">{if $submission->getStudentInitiatedResearch($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($submission->getStudentInitiatedResearch($eng)) == "Yes"}
    <tr valign="top" id="studentInstitutionField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.studentInstitution"}: {$submission->getStudentInstitution($eng)}</td>
    </tr>
    <tr valign="top" id="academicDegreeField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.academicDegree"} 
        	{if $submission->getAcademicDegree($eng) == "Undergraduate"}{translate key="proposal.undergraduate"}
        	{elseif $submission->getAcademicDegree($eng) == "Master"}{translate key="proposal.master"}
        	{elseif $submission->getAcademicDegree($eng) == "Post-Doc"}{translate key="proposal.postDoc"}
        	{elseif $submission->getAcademicDegree($eng) == "Ph.D"}{translate key="proposal.phd"}
        	{elseif $submission->getAcademicDegree($eng) == "Other"}{translate key="common.other"}
        	{/if}
        </td>
    </tr>
    <tr valign="top" id="supervisorField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.supervisor"}:</td>
    </tr>
    <tr valign="top" id="supervisorFullNameField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="proposal.supervisorFullName"}: {$submission->getSupervisorFullName($eng)}</td>
    </tr>
    <tr valign="top" id="supervisorEmailField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="user.email"}: {$submission->getSupervisorEmail($eng)}</td>
    </tr>
    <tr valign="top" id="supervisorPhoneField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="user.phone"}: {$submission->getSupervisorPhone($eng)}</td>
    </tr>
    <tr valign="top" id="supervisorAffiliationField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{translate key="user.affiliation"}: {$submission->getSupervisorAffiliation($eng)}</td>
    </tr>
    {/if}
    <tr valign="top" id="startDateField">
        <td class="label" width="20%">{translate key="proposal.startDate"}</td>
        <td class="value">{$submission->getStartDate($eng)}</td>
    </tr>
    <tr valign="top" id="endDateField">
        <td class="label" width="20%">{translate key="proposal.endDate"}</td>
        <td class="value">{$submission->getEndDate($eng)}</td>
    </tr>
    <tr valign="top" id="primarySponsorField">
        <td class="label" width="20%">{translate key="proposal.primarySponsor"}</td>
        <td class="value">
        	{if $submission->getLocalizedPrimarySponsor()}
        		{$submission->getLocalizedPrimarySponsorText()}
        	{/if}
    	</td>
    </tr>    
    {if $submission->getLocalizedSecondarySponsors()}
    <tr valign="top" id="secondarySponsorsField">
        <td class="label" width="20%">{translate key="proposal.secondarySponsors"}</td>
        <td class="value">
        	{if $submission->getLocalizedSecondarySponsors()}
        		{$submission->getLocalizedSecondarySponsorText()}
        	{/if} 
        </td>
    </tr>
    {/if}
    <tr valign="top" id="multiCountryResearchField">
        <td class="label" width="20%">{translate key="proposal.multiCountryResearch"}</td>
        <td class="value">{if $submission->getMultiCountryResearch($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
	{if ($submission->getMultiCountryResearch($eng)) == "Yes"}
	<tr valign="top" id="multiCountryTextField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$submission->getLocalizedMultiCountryText()}</td>
    </tr>
	{/if}
    <tr valign="top" id="nationwideField">
        <td class="label" width="20%">{translate key="proposal.nationwide"}</td>
        <td class="value">{$submission->getNationwide($eng)}</td>
    </tr>	
    <tr valign="top" id="proposalCountryField">
        <td class="label" width="20%">{translate key="proposal.proposalCountry"}</td>
        <td class="value">{$submission->getLocalizedProposalCountryText()}</td>
    </tr>
    <tr valign="top" id="researchFieldField">
        <td class="label" width="20%">{translate key="proposal.researchField"}</td>
        <td class="value">
        	{if $submission->getLocalizedResearchField()}
        		{$submission->getLocalizedResearchFieldText()}
        	{/if}
        </td>
    </tr>
    <tr valign="top" id="withHumanSubjectsField">
        <td class="label" width="20%">{translate key="proposal.withHumanSubjects"}</td>
        <td class="value">{if $submission->getWithHumanSubjects($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($submission->getWithHumanSubjects($eng)) == "Yes"}
    <tr valign="top" id="proposalTypeField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">
        	{if ($submission->getLocalizedProposalType())}
        		{$submission->getLocalizedProposalTypeText()}
        	{/if}      
        </td>
    </tr>
    {/if}    
     <tr valign="top" id="dataCollectionField">
        <td class="label" width="20%">{translate key="proposal.dataCollection"}</td>
        <td class="value">
        	{if $submission->getDataCollection($eng) == "Primary"}{translate key="proposal.primaryDataCollection"}
        	{elseif $submission->getDataCollection($eng) == "Secondary"}{translate key="proposal.secondaryDataCollection"}
        	{elseif $submission->getDataCollection($eng) == "Both"}{translate key="proposal.bothDataCollection"}
        	{/if}
        </td>
    </tr>   
    <tr valign="top" id="reviewedByOtherErcField">
        <td class="label" width="20%">{translate key="proposal.reviewedByOtherErc"}</td>
        <td class="value">
        	{if $submission->getReviewedByOtherErc($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}        
        	{if $submission->getOtherErcDecision($eng) == 'Under Review'}({translate key="proposal.otherErcDecisionUnderReview"})
        	{elseif $submission->getOtherErcDecision($eng) == 'Final Decision Available'}({translate key="proposal.otherErcDecisionFinalAvailable"})
        	{/if}
        </td>
    </tr>
    </div>
	<div id="sourceOfMonetary">
	<tr valign="top"><td colspan="2"><h4>{translate key="proposal.sourceOfMonetary"}</h4></td></tr>
    <tr valign="top" id="fundsRequiredField">
        <td class="label" width="20%">{translate key="proposal.fundsRequired"}</td>
        <td class="value">{$submission->getFundsRequired($eng)} {if $submission->getSelectedCurrency($eng) == "US Dollar(s)"}{translate key="proposal.fundsRequiredUSD"}{else}{translate key="proposal.fundsRequiredEUR"}{/if}</td>
    </tr>
    <tr valign="top" id="industryGrantField">
        <td class="label" width="20%">{translate key="proposal.industryGrant"}</td>
        <td class="value">{if $submission->getIndustryGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($submission->getIndustryGrant($eng)) == "Yes"}
     <tr valign="top" id="nameOfIndustryField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$submission->getNameOfIndustry($eng)}</td>
    </tr>   
    {/if}
    <tr valign="top" id="internationalGrantField">
        <td class="label" width="20%">{translate key="proposal.internationalGrant"}</td>
        <td class="value">{if $submission->getInternationalGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($submission->getInternationalGrant($eng)) == "Yes"}
     <tr valign="top" id="internationalGrantNameField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">
        	{if $submission->getLocalizedInternationalGrantName()}
        		{$submission->getLocalizedInternationalGrantNameText()} 
        	{/if}        
        </td>
    </tr>     
    {/if}
    <tr valign="top" id="mohGrantField">
        <td class="label" width="20%">{translate key="proposal.mohGrant"}</td>
        <td class="value">{if $submission->getMohGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="governmentGrantField">
        <td class="label" width="20%">{translate key="proposal.governmentGrant"}</td>
        <td class="value">{if $submission->getGovernmentGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($submission->getGovernmentGrant($eng)) == "Yes"}
     <tr valign="top" id="governmentGrantNameField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$submission->getGovernmentGrantName($eng)}</td>
    </tr>     
    {/if}
    <tr valign="top" id="universityGrantField">
        <td class="label" width="20%">{translate key="proposal.universityGrant"}</td>
        <td class="value">{if $submission->getUniversityGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="selfFundingField">
        <td class="label" width="20%">{translate key="proposal.selfFunding"}</td>
        <td class="value">{if $submission->getSelfFunding($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="otherGrantField">
        <td class="label" width="20%">{translate key="proposal.otherGrant"}</td>
        <td class="value">{if $submission->getOtherGrant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    {if ($submission->getOtherGrant($eng)) == "Yes"}
     <tr valign="top" id="specifyOtherGrantField">
        <td class="label" width="20%">&nbsp;</td>
        <td class="value">{$submission->getSpecifyOtherGrant($eng)}</td>
    </tr>    
    {/if}
    </div>
    <div id=riskAssessments>
    <tr><td colspan="2"><h4>{translate key="proposal.riskAssessment"}</h4></td></tr>
    <tr valign="top"><td colspan="2"><b>{translate key="proposal.researchIncludesHumanSubject"}</b></td></tr>
    <tr valign="top" id="identityRevealedField">
        <td class="label" width="20%">{translate key="proposal.identityRevealed"}</td>
        <td class="value">{if $submission->getIdentityRevealed($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="unableToConsentField">
        <td class="label" width="20%">{translate key="proposal.unableToConsent"}</td>
        <td class="value">{if $submission->getUnableToConsent($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="under18Field">
        <td class="label" width="20%">{translate key="proposal.under18"}</td>
        <td class="value">{if $submission->getUnder18($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="dependentRelationshipField">
        <td class="label" width="20%">{translate key="proposal.dependentRelationship"}</td>
        <td class="value">{if $submission->getDependentRelationship($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="ethnicMinorityField">
        <td class="label" width="20%">{translate key="proposal.ethnicMinority"}</td>
        <td class="value">{if $submission->getEthnicMinority($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="impairmentField">
        <td class="label" width="20%">{translate key="proposal.impairment"}</td>
        <td class="value">{if $submission->getImpairment($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="pregnantField">
        <td class="label" width="20%">{translate key="proposal.pregnant"}</td>
        <td class="value">{if $submission->getPregnant($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.researchIncludes"}</b></td></tr>
    <tr valign="top" id="newTreatmentField">
        <td class="label" width="20%">{translate key="proposal.newTreatment"}</td>
        <td class="value">{if $submission->getNewTreatment($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="bioSamplesField">
        <td class="label" width="20%">{translate key="proposal.bioSamples"}</td>
        <td class="value">{if $submission->getBioSamples($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="radiationField">
        <td class="label" width="20%">{translate key="proposal.radiation"}</td>
        <td class="value">{if $submission->getRadiation($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="distressField">
        <td class="label" width="20%">{translate key="proposal.distress"}</td>
        <td class="value">{if $submission->getDistress($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="inducementsField">
        <td class="label" width="20%">{translate key="proposal.inducements"}</td>
        <td class="value">{if $submission->getInducements($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="sensitiveInfoField">
        <td class="label" width="20%">{translate key="proposal.sensitiveInfo"}</td>
        <td class="value">{if $submission->getSensitiveInfo($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="deceptionField">
        <td class="label" width="20%">{translate key="proposal.deception"}</td>
        <td class="value">{if $submission->getDeception($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="reproTechnologyField">
        <td class="label" width="20%">{translate key="proposal.reproTechnology"}</td>
        <td class="value">{if $submission->getReproTechnology($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="geneticsField">
        <td class="label" width="20%">{translate key="proposal.genetics"}</td>
        <td class="value">{if $submission->getGenetics($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="stemCellField">
        <td class="label" width="20%">{translate key="proposal.stemCell"}</td>
        <td class="value">{if $submission->getStemCell($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="biosafetyField">
        <td class="label" width="20%">{translate key="proposal.biosafety"}</td>
        <td class="value">{if $submission->getBiosafety($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="exportField">
        <td class="label" width="20%">{translate key="proposal.export"}</td>
        <td class="value">{if $submission->getExport($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>    
    <tr valign="top"><td colspan="2"><b><br/>{translate key="proposal.researchIncludes"}</b></td></tr>
    <tr valign="top" id="riskLevelField">
        <td class="label" width="20%">{translate key="proposal.riskLevel"}</td>
        <td class="value">
        {if $submission->getRiskLevel($eng) == "No more than minimal risk"}{translate key="proposal.riskLevelNoMore"}
        {elseif $submission->getRiskLevel($eng) == "Minor increase over minimal risk"}{translate key="proposal.riskLevelMinore"}
        {elseif $submission->getRiskLevel($eng) == "More than minor increase over minimal risk"}{translate key="proposal.riskLevelMore"}
        {/if}
        </td>
    </tr>
    {if $submission->getRiskLevel($eng) != 'No more than minimal risk'}
    <tr valign="top" id="listRisksField">
        <td class="label" width="20%">{translate key="proposal.listRisks"}</td>
        <td class="value">{$submission->getListRisks($eng)}</td>
    </tr>
    <tr valign="top" id="howRisksMinimizedField">
        <td class="label" width="20%">{translate key="proposal.howRisksMinimized"}</td>
        <td class="value">{$submission->getHowRisksMinimized($eng)}</td>
    </tr>
    {/if}
    <tr valign="top" id="riskApplyToField">
        <td class="label" width="20%">{translate key="proposal.riskApplyTo"}</td>
        <td class="value">
        {assign var="riskApplyTo" value=$submission->getRiskApplyTo()}
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
        {assign var="benefitsFrom" value=$submission->getBenefitsFromTheProject()}
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
        <td class="value">{if $submission->getMultiInstitutions($eng) == "Yes"}{translate key="common.yes"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    <tr valign="top" id="conflictOfInterestField">
        <td class="label" width="20%">{translate key="proposal.conflictOfInterest"}</td>
        <td class="value">{if $submission->getConflictOfInterest($eng) == "Yes"}{translate key="common.yes"}{elseif $submission->getConflictOfInterest($eng) == "Not sure"}{translate key="common.notSure"}{else}{translate key="common.no"}{/if}</td>
    </tr>
    </div>
</table>
</div>

