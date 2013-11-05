<?php

/**
 * @file classes/submission/form/MetadataForm.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class MetadataForm
 * @ingroup submission_form
 *
 * @brief Form to change metadata information for a submission.
 */


import('lib.pkp.classes.form.Form');

class MetadataForm extends Form {
	/** @var Article current article */
	var $article;

	/** @var boolean can edit metadata */
	var $canEdit;

	/** @var boolean can view authors */
	var $canViewAuthors;

	/** @var boolean is an Editor, can edit all metadata */
	var $isEditor;

	/**
	 * Constructor.
	 */
	function MetadataForm($article, $journal) {
                
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$signoffDao =& DAORegistry::getDAO('SignoffDAO');

		$user =& Request::getUser();
		$roleId = $roleDao->getRoleIdFromPath(Request::getRequestedPage());
                /*
		// If the user is an editor of this article, make the entire form editable.
		$this->canEdit = false;
		$this->isEditor = false;
		if ($roleId != null && ($roleId == ROLE_ID_EDITOR || $roleId == ROLE_ID_SECTION_EDITOR)) {
			$this->canEdit = true;
			$this->isEditor = true;
		}

		$copyeditInitialSignoff = $signoffDao->getBySymbolic('SIGNOFF_COPYEDITING_INITIAL', ASSOC_TYPE_ARTICLE, $article->getId());
		// If the user is an author and the article hasn't passed the Copyediting stage, make the form editable.
		if ($roleId == ROLE_ID_AUTHOR) {
			if ($article->getStatus() != STATUS_PUBLISHED && ($copyeditInitialSignoff == null || $copyeditInitialSignoff->getDateCompleted() == null)) {
				$this->canEdit = true;
			}
		}

		// Copy editors are also allowed to edit metadata, but only if they have
		// a current assignment to the article.
		if ($roleId != null && ($roleId == ROLE_ID_COPYEDITOR)) {
			$copyeditFinalSignoff = $signoffDao->build('SIGNOFF_COPYEDITING_FINAL', ASSOC_TYPE_ARTICLE, $article->getId());
			if ($copyeditFinalSignoff != null && $article->getStatus() != STATUS_PUBLISHED) {
				if ($copyeditInitialSignoff->getDateNotified() != null && $copyeditFinalSignoff->getDateCompleted() == null) {
					$this->canEdit = true;
				}
			}
		}
                */
                //Added by AIM Feb 16 2012
                if ($roleId == ROLE_ID_AUTHOR || $roleId == ROLE_ID_SECTION_EDITOR) {
                    $this->canEdit = true;
                } else {
                    $this->canEdit = false;
                }
                
		if ($this->canEdit) {
			$supportedSubmissionLocales = $journal->getSetting('supportedSubmissionLocales');
			if (empty($supportedSubmissionLocales)) $supportedSubmissionLocales = array($journal->getPrimaryLocale());

			parent::Form(
				'submission/metadata/metadataEdit.tpl',
				true,
				$article->getLocale(),
				array_flip(array_intersect(
					array_flip(Locale::getAllLocales()),
					$supportedSubmissionLocales
				))
			);
		$this->addCheck(new FormValidatorCustom($this, 'authors', 'required', 'author.submit.form.authorRequired', create_function('$authors', 'return count($authors) > 0;')));
		$this->addCheck(new FormValidatorArray($this, 'authors', 'required', 'author.submit.form.authorRequiredFields', array('firstName', 'lastName')));
		$this->addCheck(new FormValidatorArrayCustom($this, 'authors', 'required', 'user.profile.form.urlInvalid', create_function('$url, $regExp', 'return empty($url) ? true : String::regexp_match($regExp, $url);'), array(ValidatorUrl::getRegexp()), false, array('url')));
		$this->addCheck(new FormValidatorLocale($this, 'authorPhoneNumber', 'required', 'author.submit.form.authorPhoneNumber', 'en_US'));
		$this->addCheck(new FormValidatorLocale($this, 'scientificTitle', 'required', 'author.submit.form.engScientificTitleRequired', 'en_US'));
		$this->addCheck(new FormValidatorLocale($this, 'scientificTitle', 'required', 'author.submit.form.camScientificTitleRequired', 'kh_CA'));
		//$this->addCheck(new FormValidatorLocale($this, 'publicTitle', 'required', 'author.submit.form.engPublicTitleRequired', 'en_US'));
		//$this->addCheck(new FormValidatorLocale($this, 'publicTitle', 'required', 'author.submit.form.camPublicTitleRequired', 'kh_CA'));
		$this->addCheck(new FormValidatorLocale($this, 'studentInitiatedResearch', 'required', 'author.submit.form.studentInitiatedResearch', 'en_US'));
		$this->addCheck(new FormValidatorLocale($this, 'studentInstitution', 'required', 'author.submit.form.studentInstitution', 'en_US'));
		$this->addCheck(new FormValidatorLocale($this, 'supervisorFullName', 'required', 'author.submit.form.supervisorFullNameRequired', 'en_US'));
		$this->addCheck(new FormValidatorLocale($this, 'supervisorEmail', 'required', 'author.submit.form.supervisorEmailRequired', 'en_US'));
		$this->addCheck(new FormValidatorLocale($this, 'supervisorPhone', 'required', 'author.submit.form.supervisorPhoneRequired', 'en_US'));
		$this->addCheck(new FormValidatorLocale($this, 'supervisorAffiliation', 'required', 'author.submit.form.supervisorAffiliationRequired', 'en_US'));		
		$this->addCheck(new FormValidatorLocale($this, 'academicDegree', 'required', 'author.submit.form.academicDegree', 'en_US'));
		
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$section = $sectionDao->getSection($article->getSectionId());
		$abstractWordCount = $section->getAbstractWordCount();
		
		if (isset($abstractWordCount) && $abstractWordCount > 0) {
			$this->addCheck(new FormValidatorCustom($this, 'abstract', 'required', 'author.submit.form.wordCountAlert', create_function('$abstract, $wordCount', 'foreach ($abstract as $localizedAbstract) {return count(explode(" ",$localizedAbstract)) < $wordCount; }'), array($abstractWordCount)));
		}
			
        $this->addCheck(new FormValidatorLocale($this, 'keywords', 'required', 'author.submit.form.engKeywordsRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'keywords', 'required', 'author.submit.form.camKeywordsRequired', 'kh_CA'));
        $this->addCheck(new FormValidatorLocale($this, 'startDate', 'required', 'author.submit.form.startDateRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'endDate', 'required', 'author.submit.form.endDateRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'fundsRequired', 'required', 'author.submit.form.fundsRequiredRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'selectedCurrency', 'required', 'author.submit.form.selectedCurrency', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'primarySponsor', 'required', 'author.submit.form.primarySponsor', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'otherPrimarySponsor', 'required', 'author.submit.form.otherPrimarySponsor', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'otherSecondarySponsor', 'required', 'author.submit.form.otherSecondarySponsor', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'multiCountryResearch', 'required', 'author.submit.form.multiCountry', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'multiCountry', 'required', 'author.submit.form.country', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'nationwide', 'required', 'author.submit.form.nationwideRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'proposalCountry', 'required', 'author.submit.form.proposalCountryRequired', 'en_US'));
        
        $this->addCheck(new FormValidatorLocale($this, 'researchField', 'required', 'author.submit.form.researchField', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'otherResearchField', 'required', 'author.submit.form.otherResearchField', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'withHumanSubjects', 'required', 'author.submit.form.withHumanSubjectsRequired', 'en_US'));	        
        $this->addCheck(new FormValidatorLocale($this, 'proposalType', 'required', 'author.submit.form.proposalTypeRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'otherProposalType', 'required', 'author.submit.form.otherProposalTypeRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'dataCollection', 'required', 'author.submit.form.dataCollection', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'reviewedByOtherErc', 'required', 'author.submit.form.reviewedByOtherErcRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'otherErcDecision', 'required', 'author.submit.form.otherErcDecisionRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'industryGrant', 'required', 'author.submit.form.industryGrant', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'nameOfIndustry', 'required', 'author.submit.form.nameOfIndustry', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'internationalGrant', 'required', 'author.submit.form.internationalGrant', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'internationalGrantName', 'required', 'author.submit.form.internationalGrantName', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'otherInternationalGrantName', 'required', 'author.submit.form.otherInternationalGrantName', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'mohGrant', 'required', 'author.submit.form.mohGrant', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'governmentGrant', 'required', 'author.submit.form.governmentGrant', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'governmentGrantName', 'required', 'author.submit.form.governmentGrantName', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'universityGrant', 'required', 'author.submit.form.universityGrant', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'selfFunding', 'required', 'author.submit.form.selfFunding', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'otherGrant', 'required', 'author.submit.form.otherGrant', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'specifyOtherGrant', 'required', 'author.submit.form.specifyOtherGrantField', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'identityRevealed', 'required', 'author.submit.form.identityRevealedRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'unableToConsent', 'required', 'author.submit.form.unableToConsentRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'under18', 'required', 'author.submit.form.under18Required', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'dependentRelationship', 'required', 'author.submit.form.dependentRelationshipRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'ethnicMinority', 'required', 'author.submit.form.ethnicMinorityRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'impairment', 'required', 'author.submit.form.impairmentRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'pregnant', 'required', 'author.submit.form.pregnantRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'newTreatment', 'required', 'author.submit.form.newTreatmentRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'bioSamples', 'required', 'author.submit.form.bioSamplesRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'radiation', 'required', 'author.submit.form.radiationRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'distress', 'required', 'author.submit.form.distressRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'inducements', 'required', 'author.submit.form.inducementsRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'sensitiveInfo', 'required', 'author.submit.form.sensitiveInfoRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'deception', 'required', 'author.submit.form.deceptionRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'reproTechnology', 'required', 'author.submit.form.reproTechnologyRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'genetics', 'required', 'author.submit.form.geneticsRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'stemCell', 'required', 'author.submit.form.stemCellRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'biosafety', 'required', 'author.submit.form.biosafetyRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'export', 'required', 'author.submit.form.exportRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'riskLevel', 'required', 'author.submit.form.riskLevelRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'listRisks', 'required', 'author.submit.form.listRisksRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'howRisksMinimized', 'required', 'author.submit.form.howRisksMinimizedRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'multiInstitutions', 'required', 'author.submit.form.multiInstitutionsRequired', 'en_US'));
        $this->addCheck(new FormValidatorLocale($this, 'conflictOfInterest', 'required', 'author.submit.form.conflictOfInterestRequired', 'en_US'));
                } else {
			parent::Form('submission/metadata/metadataView.tpl');
		}
                /*
		// If the user is a reviewer of this article, do not show authors.
		$this->canViewAuthors = true;
		if ($roleId != null && $roleId == ROLE_ID_REVIEWER) {
			$this->canViewAuthors = false;
		}
                */
		$this->article = $article;
                
		$this->addCheck(new FormValidatorPost($this));
	}

	/**
	 * Get the default form locale.
	 * @return string
	 */
	function getDefaultFormLocale() {
		if ($this->article) return $this->article->getLocale();
		return parent::getDefaultFormLocale();
	}

	/**
	 * Initialize form data from current article.
	 */
	function initData() {
		$sectionDao =& DAORegistry::getDAO('SectionDAO');

		if (isset($this->article)) {
			$article =& $this->article;

            $proposalCountryArray = $article->getProposalCountry(null);
            $proposalCountry['en_US'] = explode(",", $proposalCountryArray['en_US']);
						
			$multiCountryArray = $article->getMultiCountry(null);
			$multiCountry['en_US'] = explode(",", $multiCountryArray['en_US']);
            
            $researchFieldArray = $article->getResearchField(null);
            $researchField['en_US'] = explode("+", $researchFieldArray['en_US']);
			$i = 0;
            foreach ($researchField['en_US'] as $field){
            	if (preg_match('#^Other\s\(.+\)$#', $field)){
                	$tempField = $field;
                    $field = preg_replace('#^Other\s\(.+\)$#','OTHER', $field);
                    $tempField = preg_replace('#^Other\s\(#','', $tempField);
                    $tempField = preg_replace('#\)$#','', $tempField);
                    $article->setOtherResearchField($tempField, 'en_US');
                }
                $test = array($i => $field);
                foreach ($test as $key => $value) {
                	$researchField['en_US'][$key] = $value;
                }
                $i++;
                unset ($field);
            }
            
            $proposalTypeArray = $article->getProposalType(null);
            $proposalType['en_US'] = explode("+", $proposalTypeArray['en_US']);
			$f = 0;
            foreach ($proposalType['en_US'] as $type){
            	if (preg_match('#^Other\s\(.+\)$#', $type)){
                	$tempType = $type;
                    $type = preg_replace('#^Other\s\(.+\)$#','OTHER', $type);
                    $tempType = preg_replace('#^Other\s\(#','', $tempType);
                    $tempType = preg_replace('#\)$#','', $tempType);
                    $article->setOtherProposalType($tempType, 'en_US');
                }
                $test2 = array($f => $type);
                foreach ($test2 as $key => $value) {
                	$proposalType['en_US'][$key] = $value;
                }
                $f++;
                unset ($type);
            }

            $internationalGrantNameArray = $article->getInternationalGrantName(null);
            $internationalGrantName['en_US'] = explode("+", $internationalGrantNameArray['en_US']);
			$g = 0;
            foreach ($internationalGrantName['en_US'] as $grant){
            	if (preg_match('#^Other\s\(.+\)$#', $grant)){
                	$tempGrant = $grant;
                    $grant = preg_replace('#^Other\s\(.+\)$#','OTHER', $grant);
                    $tempGrant = preg_replace('#^Other\s\(#','', $tempGrant);
                    $tempGrant = preg_replace('#\)$#','', $tempGrant);
                    $article->setOtherInternationalGrantName($tempGrant, 'en_US');
                }
                $test3 = array($g => $grant);
                foreach ($test3 as $key => $value) {
                	$internationalGrantName['en_US'][$key] = $value;
                }
                $g++;
                unset ($grant);
            }
            
            $secondarySponsorArray = $article->getSecondarySponsors(null);
            $secondarySponsors['en_US'] = explode("+", $secondarySponsorArray['en_US']);
			$h = 0;
            foreach ($secondarySponsors['en_US'] as $sponsor){
            	if (preg_match('#^Other\s\(.+\)$#', $sponsor)){
                	$tempSponsor = $sponsor;
                    $sponsor = preg_replace('#^Other\s\(.+\)$#','OTHER', $sponsor);
                    $tempSponsor = preg_replace('#^Other\s\(#','', $tempSponsor);
                    $tempSponsor = preg_replace('#\)$#','', $tempSponsor);
                    $article->setOtherSecondarySponsor($tempSponsor, 'en_US');
                }
                $test4 = array($h => $sponsor);
                foreach ($test4 as $key => $value) {
                	$secondarySponsors['en_US'][$key] = $value;
                }
                $h++;
                unset ($sponsor);
            }
            
            $primarySponsorArray = $article->getPrimarySponsor(null);
            $primarySponsor['en_US'] = explode("+", $primarySponsorArray['en_US']);
			$j = 0;
            foreach ($primarySponsor['en_US'] as $sponsor){
            	if (preg_match('#^Other\s\(.+\)$#', $sponsor)){
                	$tempSponsor = $sponsor;
                    $sponsor = preg_replace('#^Other\s\(.+\)$#','OTHER', $sponsor);
                    $tempSponsor = preg_replace('#^Other\s\(#','', $tempSponsor);
                    $tempSponsor = preg_replace('#\)$#','', $tempSponsor);
                    $article->setOtherPrimarySponsor($tempSponsor, 'en_US');
                }
                $test5 = array($j => $sponsor);
                foreach ($test5 as $key => $value) {
                	$primarySponsor['en_US'][$key] = $value;
                }
                $j++;
                unset ($sponsor);
            }
                                    
            $articleDao =& DAORegistry::getDAO('ArticleDAO');
						
			$this->_data = array(
				'submission' => $article,
				'authors' => array(),
				'authorPhoneNumber' => $article->getAuthorPhoneNumber(null),
				'scientificTitle' => $article->getScientificTitle(null), // Localized
				'publicTitle' => $article->getPublicTitle(null), // Localized
				'studentInitiatedResearch' => $article->getStudentInitiatedResearch(null),
				'studentInstitution' => $article->getStudentInstitution(null),
				'supervisorFullName' => $article->getSupervisorFullName(null),
				'supervisorEmail' => $article->getSupervisorEmail(null),
				'supervisorPhone' => $article->getSupervisorPhone(null),
				'supervisorAffiliation' => $article->getSupervisorAffiliation(null),
				'academicDegree' => $article->getAcademicDegree(null),
				'background' => $article->getBackground(null), 
				'objectives' => $article->getObjectives(null), 
				'studyMatters' => $article->getStudyMatters(null), 
				'expectedOutcomes' => $article->getExpectedOutcomes(null),				
				'section' => $sectionDao->getSection($article->getSectionId()),                                 
                'keywords' => $article->getKeywords(null),
                'startDate' => $article->getStartDate(null),
                'endDate' => $article->getEndDate(null),
                'fundsRequired' => $article->getFundsRequired(null),
                'selectedCurrency' => $article->getSelectedCurrency(null),
                'primarySponsor' => $primarySponsor,
                'otherPrimarySponsor' => $article->getOtherPrimarySponsor(null),
                'secondarySponsors' => $secondarySponsors,
                'otherSecondarySponsor' => $article->getOtherSecondarySponsor(null),
                'multiCountryResearch' => $article->getMultiCountryResearch(null),
                'multiCountry' => $multiCountry,
                'nationwide' => $article->getNationwide(null),
                'proposalCountry' => $proposalCountry,
                'researchField' => $researchField,
                'otherResearchField' => $article->getOtherResearchField(null),
                'technicalUnit' => $article->getTechnicalUnit(null),
                'withHumanSubjects' => $article->getWithHumanSubjects(null),
                'proposalType' => $proposalType,
                'otherProposalType' => $article->getOtherProposalType(null),
                'dataCollection' => $article->getDataCollection(null),
                'submittedAsPi' => $article->getSubmittedAsPi(null),
                'conflictOfInterest' => $article->getConflictOfInterest(null),
                'reviewedByOtherErc' => $article->getReviewedByOtherErc(null),
                'otherErcDecision' => $article->getOtherErcDecision(null),
                'rtoOffice' => $article->getRtoOffice(null),
                'industryGrant' => $article->getIndustryGrant(null),
                'nameOfIndustry' => $article->getNameOfIndustry(null),
                'internationalGrant' => $article->getInternationalGrant(null),
                'internationalGrantName' => $internationalGrantName,
                'otherInternationalGrantName' =>$article->getOtherInternationalGrantName(null),
                'mohGrant' => $article->getMohGrant(null),
                'governmentGrant' => $article->getGovernmentGrant(null),
                'governmentGrantName' => $article->getGovernmentGrantName(null),
                'universityGrant' => $article->getUniversityGrant(null),
                'selfFunding' => $article->getSelfFunding(null),
                'otherGrant' => $article->getOtherGrant(null),
                'specifyOtherGrant' => $article->getSpecifyOtherGrant(null),
                'identityRevealed' => $article->getIdentityRevealed(null),
                'unableToConsent' => $article->getUnableToConsent(null),
                'under18' => $article->getUnder18(null),
                'dependentRelationship' => $article->getDependentRelationship(null),
                'ethnicMinority' => $article->getEthnicMinority(null),
                'impairment' => $article->getImpairment(null),
                'pregnant' => $article->getPregnant(null),
                'newTreatment' => $article->getNewTreatment(null),
                'bioSamples' => $article->getBioSamples(null),
                'radiation' => $article->getRadiation(null),
                'distress' => $article->getDistress(null),
                'inducements' => $article->getInducements(null),
                'sensitiveInfo' => $article->getSensitiveInfo(null),
                'deception' => $article->getDeception(null),
                'reproTechnology' => $article->getReproTechnology(null),
                'genetics' => $article->getGenetics(null),
                'stemCell' => $article->getStemCell(null),
                'biosafety' => $article->getBiosafety(null),
                'export' => $article->getExport(null),
                'riskLevel' => $article->getRiskLevel(null),
                'listRisks' => $article->getListRisks(null),
                'howRisksMinimized' => $article->getHowRisksMinimized(null),
                'riskApplyTo' => $article->getRiskApplyTo(null),
                'benefitsFromTheProject' => $article->getBenefitsFromTheProject(null),
                'multiInstitutions' => $article->getMultiInstitutions(null)
			);
                       
			$authors =& $article->getAuthors();
			for ($i=0, $count=count($authors); $i < $count; $i++) {
				array_push(
					$this->_data['authors'],
					array(
						'authorId' => $authors[$i]->getId(),
						'firstName' => $authors[$i]->getFirstName(),
						'middleName' => $authors[$i]->getMiddleName(),
						'lastName' => $authors[$i]->getLastName(),
						'affiliation' => $authors[$i]->getAffiliation(null),
						'country' => $authors[$i]->getCountry(),
						'email' => $authors[$i]->getEmail(),
						'url' => $authors[$i]->getUrl(),
						'competingInterests' => $authors[$i]->getCompetingInterests(null),
						'biography' => $authors[$i]->getBiography(null)
					)
				);
				if ($authors[$i]->getPrimaryContact()) {
					$this->setData('primaryContact', $i);
				}
			}
		}
		return parent::initData();
	}

	/**
	 * Get the field names for which data can be localized
	 * @return array
	 */
	function getLocaleFieldNames() {
		return array('authorPhoneNumber', 'scientificTitle', 'publicTitle', 'studentInitiatedResearch', 'hsph', 'studentInstitution', 'supervisorFullName', 'supervisorEmail', 'supervisorPhone', 'supervisorAffiliation', 'academicDegree','background', 'objectives', 'studyMatters', 'expectedOutcomes', 'keywords', 'startDate', 'endDate', 'fundsRequired', 'selectedCurrency', 'primarySponsor', 'otherPrimarySponsor', 'secondarySponsors', 'otherSecondarySponsor', 'multiCountryResearch', 'multiCountry', 'nationwide', 'proposalCountry', 'researchField', 'otherResearchField', 'withHumanSubjects','proposalType', 'otherProposalType', 'dataCollection', 'submittedAsPi', 'conflictOfInterest', 'reviewedByOtherErc', 'otherErcDecision', 'rtoOffice', 'industryGrant', 'nameOfIndustry', 'internationalGrant', 'internationalGrantName', 'otherInternationalGrantName', 'mohGrant', 'governmentGrant', 'governmentGrantName', 'universityGrant', 'selfFunding', 'otherGrant', 'specifyOtherGrant', 'identityRevealed', 'unableToConsent', 'under18', 'dependentRelationship', 'ethnicMinority', 'impairment', 'pregnant', 'newTreatment', 'bioSamples', 'radiation', 'distress', 'inducements', 'sensitiveInfo', 'deception', 'reproTechnology', 'genetics', 'stemCell', 'biosafety', 'export', 'riskLevel', 'listRisks', 'howRisksMinimized', 'riskApplyTo', 'benefitsFromTheProject', 'multiInstitutions');
	}

	/**
	 * Display the form.
	 */
	function display() {
		$journal =& Request::getJournal();
		$settingsDao =& DAORegistry::getDAO('JournalSettingsDAO');
		$roleDao =& DAORegistry::getDAO('RoleDAO');
		$sectionDao =& DAORegistry::getDAO('SectionDAO');

		Locale::requireComponents(array(LOCALE_COMPONENT_OJS_EDITOR)); // editor.cover.xxx locale keys; FIXME?

		$templateMgr =& TemplateManager::getManager();
		$templateMgr->assign('articleId', isset($this->article)?$this->article->getId():null);
		$templateMgr->assign('journalSettings', $settingsDao->getJournalSettings($journal->getId()));
		$templateMgr->assign('rolePath', Request::getRequestedPage());
		$templateMgr->assign('canViewAuthors', $this->canViewAuthors);

		$countryDao =& DAORegistry::getDAO('CountryDAO');
		$templateMgr->assign('countries', $countryDao->getCountries());

		$templateMgr->assign('helpTopicId','submission.indexingAndMetadata');
		if ($this->article) {
			$templateMgr->assign_by_ref('section', $sectionDao->getSection($this->article->getSectionId()));
		}

		if ($this->isEditor) {
			import('classes.article.Article');
			$hideAuthorOptions = array(
				AUTHOR_TOC_DEFAULT => Locale::Translate('editor.article.hideTocAuthorDefault'),
				AUTHOR_TOC_HIDE => Locale::Translate('editor.article.hideTocAuthorHide'),
				AUTHOR_TOC_SHOW => Locale::Translate('editor.article.hideTocAuthorShow')
			);
			$templateMgr->assign('hideAuthorOptions', $hideAuthorOptions);
			$templateMgr->assign('isEditor', true);
		}
                
		if (Request::getUserVar('addAuthor') || Request::getUserVar('delAuthor')  || Request::getUserVar('moveAuthor')) {
			$templateMgr->assign('scrollToAuthor', true);
		}

        $articleDao =& DAORegistry::getDAO('ArticleDAO');

        // Get proposal types
        $proposalTypes = $articleDao->getProposalTypes();
        $templateMgr->assign('proposalTypes', $proposalTypes);

		//Get research fields
        $researchFields = $articleDao->getResearchFields();
        $templateMgr->assign('researchFields', $researchFields);
        
       	//Get list of agencies
        $agencies = $articleDao->getAgencies();
        $templateMgr->assign('agencies', $agencies);

		//Get list of divisions of Cambodia
        $provinceDAO =& DAORegistry::getDAO('ProvincesOfCambodiaDAO');
        $proposalCountries =& $provinceDAO->getProvincesOfCambodia();
        ksort($proposalCountries);
        $templateMgr->assign_by_ref('proposalCountries', $proposalCountries);

        parent::display();
	}


	/**
	 * Assign form data to user-submitted data.
	 */
	function readInputData() {
		$this->readUserVars(
			array(
				'authors',
				'deletedAuthors',
				'primaryContact',
				'authorPhoneNumber',
				'scientificTitle',
				'publicTitle',
				'studentInitiatedResearch',
				'hsph',
				'studentInstitution',
				'supervisorFullName',
				'supervisorEmail',
				'supervisorPhone',
				'supervisorAffiliation',
				'academicDegree',
				'background', 
				'objectives', 
				'studyMatters', 
				'expectedOutcomes',
				'language',
                'keywords',
                'startDate',
                'endDate',
                'fundsRequired',
                'selectedCurrency',
                'primarySponsor',
                'otherPrimarySponsor',
                'secondarySponsors',
                'otherSecondarySponsor',
                'multiCountryResearch',
                'multiCountry',
                'nationwide',
                'proposalCountry',
                'researchField',
                'otherResearchField',
                'technicalUnit',
                'withHumanSubjects',
                'proposalType',
                'otherProposalType',
                'dataCollection',
                'submittedAsPi',
                'conflictOfInterest',
                'reviewedByOtherErc',
                'otherErcDecision',
                'rtoOffice',
                'industryGrant',
                'nameOfIndustry',
                'internationalGrant',
                'internationalGrantName',
                'otherInternationalGrantName',
                'mohGrant',
                'governmentGrant',
                'governmentGrantName',
                'universityGrant',
                'selfFunding',
                'otherGrant',
                'specifyOtherGrant',
                'identityRevealed', 
                'unableToConsent', 
                'under18', 
                'dependentRelationship', 
                'ethnicMinority', 
                'impairment', 
                'pregnant', 
                'newTreatment', 
                'bioSamples', 
                'radiation', 
                'distress', 
                'inducements', 
                'sensitiveInfo', 
                'deception', 
                'reproTechnology', 
                'genetics', 
                'stemCell', 
                'biosafety',
                'export', 
                'riskLevel', 
                'listRisks', 
                'howRisksMinimized', 
                'riskApplyTo', 
                'benefitsFromTheProject', 
                'multiInstitutions'
			)
		);

		// Load the section. This is used in the step 2 form to
		// determine whether or not to display indexing options.
		$sectionDao =& DAORegistry::getDAO('SectionDAO');
		$this->_data['section'] =& $sectionDao->getSection($this->article->getSectionId());

		if ($this->_data['section']->getAbstractsNotRequired() == 0) {
			$this->addCheck(new FormValidatorLocale($this, 'background', 'required', 'author.submit.form.engBackgroundRequired', 'en_US'));
			$this->addCheck(new FormValidatorLocale($this, 'background', 'required', 'author.submit.form.camBackgroundRequired', 'kh_CA'));
			$this->addCheck(new FormValidatorLocale($this, 'objectives', 'required', 'author.submit.form.engObjectivesRequired', 'en_US'));
			$this->addCheck(new FormValidatorLocale($this, 'objectives', 'required', 'author.submit.form.camObjectivesRequired', 'kh_CA'));
			$this->addCheck(new FormValidatorLocale($this, 'studyMatters', 'required', 'author.submit.form.engStudyMattersRequired', 'en_US'));
			$this->addCheck(new FormValidatorLocale($this, 'studyMatters', 'required', 'author.submit.form.camStudyMattersRequired', 'kh_CA'));
			$this->addCheck(new FormValidatorLocale($this, 'expectedOutcomes', 'required', 'author.submit.form.engExpectedOutcomesRequired', 'en_US'));
			$this->addCheck(new FormValidatorLocale($this, 'expectedOutcomes', 'required', 'author.submit.form.camExpectedOutcomesRequired', 'kh_CA'));
		}
	}

	/**
	 * Save changes to article.
	 * @param $request PKPRequest
	 * @return int the article ID
	 */
	function execute(&$request) {
		
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$authorDao =& DAORegistry::getDAO('AuthorDAO');
		$article =& $this->article;
		// Retrieve the previous citation list for comparison.
		$previousRawCitationList = $article->getCitations();
		
		// Update article
		$article->setAuthorPhoneNumber($this->getData('authorPhoneNumber'), null);
		$article->setScientificTitle($this->getData('scientificTitle'), null); // Localized
		$article->setPublicTitle($this->getData('publicTitle'), null);// Localized
		//$studentResearchArray = $this->getData('studentInitiatedResearch');
		$article->setStudentInitiatedResearch($this->getData('studentInitiatedResearch'), null);
		
		//print_r($this->getData('studentInstitution'));
		$hsph = $this->getData('hsph');
		if ($hsph['en_US'] == "Yes") $article->setStudentInstitution(array('en_US' => 'Hanoi School of Public Health'), null);
		else $article->setStudentInstitution($this->getData('studentInstitution'), null);
		$article->setSupervisorFullName($this->getData('supervisorFullName'), null);
		$article->setSupervisorEmail($this->getData('supervisorEmail'), null);
		$article->setSupervisorPhone($this->getData('supervisorPhone'), null);
		$article->setSupervisorAffiliation($this->getData('supervisorAffiliation'), null);
		$article->setAcademicDegree($this->getData('academicDegree'), null);
		$article->setObjectives($this->getData('objectives'), null);
		$article->setBackground($this->getData('background'), null);
		$article->setStudyMatters($this->getData('studyMatters'), null);
		$article->setExpectedOutcomes($this->getData('expectedOutcomes'), null); // Localized
		$article->setLanguage($this->getData('language'));
               
        $article->setKeywords($this->getData('keywords'), null); // Localized
        $article->setStartDate($this->getData('startDate'), null); // Localized
        $article->setEndDate($this->getData('endDate'), null); // Localized
        $article->setFundsRequired($this->getData('fundsRequired'), null); // Localized
        $article->setSelectedCurrency($this->getData('selectedCurrency'), null);
        $article->setMultiCountryResearch($this->getData('multiCountryResearch'), null);
		$article->setNationwide($this->getData('nationwide'), null);
		
        //Convert multiple provinces to CSV string
        $proposalCountryArray = $this->getData('proposalCountry');
        $proposalCountry['en_US'] = implode(",", $proposalCountryArray['en_US']);
        $article->setProposalCountry($proposalCountry, null); // Localized
        //Convert multiple proposal types to CSV string, Jan 30 2012
        $proposalTypeArray = $this->getData('proposalType');
        foreach($proposalTypeArray['en_US'] as $i => $type) {
        	if($type == "OTHER") {
        		$otherType = $this->getData('otherProposalType');
            	if($otherType != "") {
            		$proposalTypeArray['en_US'][$i] = "Other (". $otherType['en_US'] .")";
            	}
        	}
        }
        
        $proposalType['en_US'] = implode("+", $proposalTypeArray['en_US']);
        $article->setProposalType($proposalType, null); // Localized
        
        //Convert multiple international grants to CSV string
        $article->setInternationalGrant($this->getData('internationalGrant'), null); 
        $internationalGrantNameArray = $this->getData('internationalGrantName');
        foreach($internationalGrantNameArray['en_US'] as $i => $grant) {
        	if($grant == "OTHER") {
        		$otherGrant = $this->getData('otherInternationalGrantName');
            	if($otherGrant != "") {
            		$internationalGrantNameArray['en_US'][$i] = "Other (". $otherGrant['en_US'] .")";
            	}
        	}
        }
        
        $internationalGrantName['en_US'] = implode("+", $internationalGrantNameArray['en_US']);
        $article->setInternationalGrantName($internationalGrantName, null); // Localized
        //Convert multiple secondary sponsor to CSV string
        $secondarySponsorArray = $this->getData('secondarySponsors');
        foreach($secondarySponsorArray['en_US'] as $i => $sponsor) {
        	if($sponsor == "OTHER") {
        		$otherSponsor = $this->getData('otherSecondarySponsor');
            	if($otherSponsor != "") {
            		$secondarySponsorArray['en_US'][$i] = "Other (". $otherSponsor['en_US'] .")";
            	}
        	}
        }
        
        $secondarySponsors['en_US'] = implode("+", $secondarySponsorArray['en_US']);
        $article->setSecondarySponsors($secondarySponsors, null); // Localized
        
        //Convert multiple primary sponsor to CSV string
        $primarySponsorArray = $this->getData('primarySponsor');
        foreach($primarySponsorArray['en_US'] as $i => $sponsor) {
        	if($sponsor == "OTHER") {
        		$otherSponsor = $this->getData('otherPrimarySponsor');
            	if($otherSponsor != "") {
            		$primarySponsorArray['en_US'][$i] = "Other (". $otherSponsor['en_US'] .")";
            	}
        	}
        }
        
        $primarySponsor['en_US'] = implode("+", $primarySponsorArray['en_US']);
        $article->setPrimarySponsor($primarySponsor, null); // Localized
                        
        //Convert multiple research fields to CSV
        $researchFieldArray = $this->getData('researchField');
        foreach($researchFieldArray['en_US'] as $i => $field) {
        	if($field == "OTHER") {
        		$otherField = $this->getData('otherResearchField');
            	if($otherField != "") {
            		$researchFieldArray['en_US'][$i] = "Other (". $otherField['en_US'] .")";
            	}
        	}
        }   
        
        $researchField['en_US'] = implode("+", $researchFieldArray['en_US']);
        $article->setResearchField($researchField, null);
        //$article->setOtherResearchField($this->getData('otherResearchField'), null);
        
        //Convert multiple countries to CSV
        $multiCountryArray = $this->getData('multiCountry');
        $multiCountry['en_US'] = implode(",", $multiCountryArray['en_US']);
        $article->setMultiCountry($multiCountry, null);
        
        $article->setDataCollection($this->getData('dataCollection'), null);
        $article->setTechnicalUnit($this->getData('technicalUnit'), null); // Localized
        $article->setWithHumanSubjects($this->getData('withHumanSubjects'),null); // Localized
	    $article->setSubmittedAsPi($this->getData('submittedAsPi'), null); // Localized
        $article->setConflictOfInterest($this->getData('conflictOfInterest'), null); // Localized
        $article->setReviewedByOtherErc($this->getData('reviewedByOtherErc'), null); // Localized
        $article->setOtherErcDecision($this->getData('otherErcDecision'), null); // Localized
        $article->setRtoOffice($this->getData('rtoOffice'), null);//Localized
        
        $article->setIndustryGrant($this->getData('industryGrant'), null);
        $article->setNameOfIndustry($this->getData('nameOfIndustry'), null); 
        $article->setMohGrant($this->getData('mohGrant'), null);
        $article->setGovernmentGrant($this->getData('governmentGrant'), null);
        $article->setGovernmentGrantName($this->getData('governmentGrantName'), null); 
        $article->setUniversityGrant($this->getData('universityGrant'), null); 
        $article->setSelfFunding($this->getData('selfFunding'), null); 
        $article->setOtherGrant($this->getData('otherGrant'), null); 
        $article->setSpecifyOtherGrant($this->getData('specifyOtherGrant'), null);
        
        $article->setIdentityRevealed($this->getData('identityRevealed'), null);
        $article->setUnableToConsent($this->getData('unableToConsent'), null);
        $article->setUnder18($this->getData('under18'), null);
        $article->setDependentRelationship($this->getData('dependentRelationship'), null);
        $article->setEthnicMinority($this->getData('ethnicMinority'), null);
        $article->setImpairment($this->getData('impairment'), null);
        $article->setPregnant($this->getData('pregnant'), null);
        $article->setNewTreatment($this->getData('newTreatment'), null);
        $article->setBioSamples($this->getData('bioSamples'), null);
        $article->setRadiation($this->getData('radiation'), null);
        $article->setDistress($this->getData('distress'), null);
        $article->setInducements($this->getData('inducements'), null);
        $article->setSensitiveInfo($this->getData('sensitiveInfo'), null);
        $article->setDeception($this->getData('deception'), null);
        $article->setReproTechnology($this->getData('reproTechnology'), null);
        $article->setGenetics($this->getData('genetics'), null);
        $article->setStemCell($this->getData('stemCell'), null);
        $article->setBiosafety($this->getData('biosafety'), null);
        $article->setExport($this->getData('export'), null);
        $article->setRiskLevel($this->getData('riskLevel'), null);
        $article->setListRisks($this->getData('listRisks'), null);
        $article->setHowRisksMinimized($this->getData('howRisksMinimized'), null);
        $article->setRiskApplyTo($this->getData('riskApplyTo'), null);               
        $article->setBenefitsFromTheProject($this->getData('benefitsFromTheProject'), null);
        
        $article->setMultiInstitutions($this->getData('multiInstitutions'), null);
        /***************** END OF EDIT *****************************/
        //
        // Update authors
		$authors = $this->getData('authors');
		for ($i=0, $count=count($authors); $i < $count; $i++) {
			if ($authors[$i]['authorId'] > 0) {
			// Update an existing author
				$author =& $article->getAuthor($authors[$i]['authorId']);
				$isExistingAuthor = true;
			} else {
				// Create a new author
				$author = new Author();
				$isExistingAuthor = false;
			}

			if ($author != null) {
				$author->setSubmissionId($article->getId());
				if (isset($authors[$i]['firstName'])) $author->setFirstName($authors[$i]['firstName']);
				if (isset($authors[$i]['middleName'])) $author->setMiddleName($authors[$i]['middleName']);
				if (isset($authors[$i]['lastName'])) $author->setLastName($authors[$i]['lastName']);
				if (isset($authors[$i]['affiliation'])) $author->setAffiliation($authors[$i]['affiliation'], null);
				if (isset($authors[$i]['country'])) $author->setCountry($authors[$i]['country']);
				if (isset($authors[$i]['email'])) $author->setEmail($authors[$i]['email']);
				if (isset($authors[$i]['url'])) $author->setUrl($authors[$i]['url']);
				if (array_key_exists('competingInterests', $authors[$i])) {
					$author->setCompetingInterests($authors[$i]['competingInterests'], null);
				}
				//$author->setBiography($authors[$i]['biography'], null);  //AIM, 12.12.2011
				$author->setPrimaryContact($this->getData('primaryContact') == $i ? 1 : 0);
				$author->setSequence($authors[$i]['seq']);

				if ($isExistingAuthor == false) {
					$article->addAuthor($author);
				}
			}
			unset($author);
		}

		// Remove deleted authors
		$deletedAuthors = explode(':', $this->getData('deletedAuthors'));
		for ($i=0, $count=count($deletedAuthors); $i < $count; $i++) {
			$article->removeAuthor($deletedAuthors[$i]);
		}

		parent::execute();
		// Save the article
		$articleDao->updateArticle($article);

		// Update references list if it changed.
		$citationDao =& DAORegistry::getDAO('CitationDAO');
		$rawCitationList = $article->getCitations();
		if ($previousRawCitationList != $rawCitationList) {
			$citationDao->importCitations($request, ASSOC_TYPE_ARTICLE, $article->getId(), $rawCitationList);
		}
	}

	/**
	 * Determine whether or not the current user is allowed to edit metadata.
	 * @return boolean
	 */
	function getCanEdit() {
		return $this->canEdit;
	}
}

?>
