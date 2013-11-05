<?php

/**
* class MeetingsHandler for SectionEditor and Editor Roles (Secretary)
* page handler class for minutes-related operations
* @var unknown_type
*/
define('SECTION_EDITOR_ACCESS_EDIT', 0x00001);
define('SECTION_EDITOR_ACCESS_REVIEW', 0x00002);
// Filter section
define('FILTER_SECTION_ALL', 0);

import('classes.handler.Handler');

class ReportsHandler extends Handler {
	/**
	* Constructor
	**/
	function ReportsHandler() {
		parent::Handler();
		
		$this->addCheck(new HandlerValidatorJournal($this));
		// FIXME This is kind of evil
		$page = Request::getRequestedPage();
		if ( $page == 'sectionEditor' )
		$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_SECTION_EDITOR)));
		elseif ( $page == 'editor' )
		$this->addCheck(new HandlerValidatorRoles($this, true, null, null, array(ROLE_ID_EDITOR)));
	
	}

	/**
	* Setup common template variables.
	* @param $subclass boolean set to true if caller is below this handler in the hierarchy
	*/
	function setupTemplate() {
		parent::setupTemplate();
		Locale::requireComponents(array(LOCALE_COMPONENT_PKP_SUBMISSION, LOCALE_COMPONENT_OJS_EDITOR, LOCALE_COMPONENT_PKP_MANAGER, LOCALE_COMPONENT_OJS_AUTHOR, LOCALE_COMPONENT_OJS_MANAGER));
		$templateMgr =& TemplateManager::getManager();
		$isEditor = Validation::isEditor();
		
		if (Request::getRequestedPage() == 'editor') {
			$templateMgr->assign('helpTopicId', 'editorial.editorsRole');
		
		} else {
			$templateMgr->assign('helpTopicId', 'editorial.sectionEditorsRole');
		}
		
		$roleSymbolic = $isEditor ? 'editor' : 'sectionEditor';
		$roleKey = $isEditor ? 'user.role.coordinator' : 'user.role.sectionEditor';
		$pageHierarchy = array(array(Request::url(null, 'user'), 'navigation.user'), array(Request::url(null, $roleSymbolic), $roleKey), array(Request::url(null, $roleSymbolic, ''), 'editor.reports.reportGenerator'));
		
		$templateMgr->assign('pageHierarchy', $pageHierarchy);
	}

	
	/**
	* Added by igmallare 10/10/2011
	* Display the meeting attendance report form
	* @param $args (type)
	*/
	function meetingAttendanceReport($args, &$request){
		import ('lib.pkp.classes.who.form.MeetingAttendanceReportForm');
		parent::validate();
		$this->setupTemplate();
		$meetingAttendanceReportForm= new MeetingAttendanceReportForm($args, $request);
		$isSubmit = Request::getUserVar('generateMeetingAttendance') != null ? true : false;
		
		if ($isSubmit) {
			$meetingAttendanceReportForm->readInputData();
			if($meetingAttendanceReportForm->validate()){	
					$this->generateMeetingAttendanceReport($args);
			}else{
				if ($meetingAttendanceReportForm->isLocaleResubmit()) {
					$meetingAttendanceReportForm->readInputData();
				}
				$meetingAttendanceReportForm->display($args);
			}
		}else {
			$meetingAttendanceReportForm->display($args);
		}
	}
	
	/**
	* Added by igmallare 10/11/2011
	* Generate csv file for the meeting attendance report
	* @param $args (type)
	*/
	function generateMeetingAttendanceReport($args) {
		parent::validate();
		$this->setupTemplate();
		$ercMembers = Request::getUserVar('ercMembers');
		
		$fromDate = Request::getUserDateVar('dateFrom', 1, 1);
		if ($fromDate != null) $fromDate = date('Y-m-d H:i:s', $fromDate);
		$toDate = Request::getUserDateVar('dateTo', 32, 12, null, 23, 59, 59);
		if ($toDate != null) $toDate = date('Y-m-d H:i:s', $toDate);
		$meetingDao = DAORegistry::getDAO('MeetingDAO');
		$userDao = DAORegistry::getDAO('UserDAO');
		
		header('content-type: text/comma-separated-values');
		header('content-disposition: attachment; filename=meetingAttendanceReport-' . date('Ymd') . '.csv');
		
		$columns = array(
		'lastname' => Locale::translate('user.lastName'),
		'firstname' => Locale::translate('user.firstName'),
		'middlename' => Locale::translate('user.middleName'),
		'meeting_date' => Locale::translate('editor.reports.meetingDate'),
		'present' => Locale::translate('editor.reports.isPresent'),
		'reason_for_absence' => Locale::translate('editor.reports.reason')
		);
		$yesNoArray = array('present');
		$yesnoMessages = array( 0 => Locale::translate('common.no'), 1 => Locale::translate('common.yes'));
		$fp = fopen('php://output', 'wt');
		String::fputcsv($fp, array_values($columns));
		
		foreach ($ercMembers as $member) {
			$user = $userDao->getUser($member);
			list($meetingsIterator) =  $meetingDao->getMeetingReportByReviewerId($member, $fromDate, $toDate);
		
			$meetings = array();
			while ($row =& $meetingsIterator->next()) {
				foreach ($columns as $index => $junk) {
					if (in_array($index, $yesNoArray)) {
						$columns[$index] = $yesnoMessages[$row[$index]];
					} elseif ($index == "lastname") {
						$columns[$index] = $user->getLastName();
					} elseif ($index == "firstname") {
						$columns[$index] = $user->getFirstName();
					} elseif ($index == "middlename") {
						$columns[$index] = $user->getMiddleName();
					} else {
						$columns[$index] = $row[$index];
					}
				}
				String::fputcsv($fp, $columns);
				unset($row);
			}
		}
		fclose($fp);
	}
	
	/**
	* Added by MSB 10/11/2011
	* Generate csv file for the submission report
	* @param $args (type)
	*/
	function submissionsReport($args) {
		import ('lib.pkp.classes.who.form.SubmissionsReportForm');
		parent::validate();
		$this->setupTemplate();
		$submissionsReportForm= new SubmissionsReportForm($args);
		$isSubmit = Request::getUserVar('generateSubmissionsReport') != null ? true : false;
	
		if ($isSubmit) {
			$submissionsReportForm->readInputData();
			if($submissionsReportForm->validate()){
				$this->generateSubmissionsReport($args);
			}else{
				if ($submissionsReportForm->isLocaleResubmit()) {
					$submissionsReportForm->readInputData();
				}
				$submissionsReportForm->display($args);
			}
		}else {
			$submissionsReportForm->display($args);
		}
	}
	
	
	/**
	 * Generate csv file for the submission report
	 * @param $args (type)
	 */
	function generateSubmissionsReport($args) {
		parent::validate();
		$this->setupTemplate();
	
		$journal =& Request::getJournal();
		$journalId = $journal->getId();
		$articleDao =& DAORegistry::getDAO('ArticleDAO');
		$sectionId = $editorId = $searchField = $searchMatch = $search = $dateSearchField = $fromDate = $toDate = $rangeInfo = null;
		
		//Get user filter decision
		$decisionField = Request::getUserVar('decisions');
		$sresearch = Request::getUserVar('studentResearch');
		$adegree = Request::getUserVar('academicDegree');
		$primarySponsorField = Request::getUserVar('primarySponsors');
		$secondarySponsorField = Request::getUserVar('secondarySponsors');
		$researchFieldField = Request::getUserVar('researchFields');
		$proposalTypeField = Request::getUserVar('proposalTypes');
		$dataCollection = Request::getUserVar('dataCollection');
		$multiCountry = Request::getUserVar('multicountry');
		$countryField = Request::getUserVar('provinces');
		$startDateBefore = Request::getUserVar('startDateBefore');
		$startDateAfter = Request::getUserVar('startDateAfter');
		$endDateBefore = Request::getUserVar('endDateBefore');
		$endDateAfter = Request::getUserVar('endDateAfter');
		$submittedBefore = Request::getUserVar('submittedBefore');
		$submittedAfter = Request::getUserVar('submittedAfter');
		$approvedBefore = Request::getUserVar('approvedBefore');
		$approvedAfter = Request::getUserVar('approvedAfter');
		
		if(array_shift(array_values($countryField)) == "0"){
			$countryDAO =& DAORegistry::getDAO('ProvincesOfCambodiaDAO');
        	$countries =& $countryDAO->getProvincesOfCambodia();
        	$countryField = array_keys($countries);
		}
		$sort = Request::getUserVar('sort');
		$sort = isset($sort) ? $sort : 'id';
		$sortDirection = Request::getUserVar('sortDirection');
		$sortDirection = (isset($sortDirection) && ($sortDirection == 'ASC' || $sortDirection == 'DESC')) ? $sortDirection : 'ASC';
		
		$editorSubmissionDao =& DAORegistry::getDAO('EditorSubmissionDAO');
				
		$submissions =& $editorSubmissionDao->getEditorSubmissionsReport(
			$journalId,
			$sectionId,
			$sresearch,
			$adegree,
			$primarySponsorField,
			$secondarySponsorField,
			$researchFieldField,
			$proposalTypeField,
			$dataCollection,
			$multiCountry,
			$countryField,
			$startDateBefore,
			$startDateAfter,
			$endDateBefore,
			$endDateAfter,
			$submittedBefore,
			$submittedAfter,
			$approvedBefore,
			$approvedAfter,
			$decisionField,
			$sort,
			$sortDirection
		);
			
	
		$submissionsArray = $submissions->toArray();
	
		header('content-type: text/comma-separated-values');
		header('content-disposition: attachment; filename=submissionsReport-' . date('Ymd') . '.csv');
		
		$columns = array();
		
		if (Request::getUserVar('checkProposalId')){
			$columns = $columns + array('whoId' => Locale::translate("editor.reports.whoId"));
		}
		if (Request::getUserVar('checkDecision')){
			$columns = $columns + array('decision' => Locale::translate("editor.reports.decision"));
		}
		if (Request::getUserVar('checkDateSubmitted')){
			$columns = $columns + array('submitDate' =>  Locale::translate("editor.reports.submitDate"));
		}		
		if (Request::getUserVar('checkDateApproved')){
			$columns = $columns + array('approvedDate' =>  Locale::translate("editor.reports.approveDate"));
		}
		if (Request::getUserVar('checkName')){
			$columns = $columns + array('author' => Locale::translate("editor.reports.author"));
		}
		if (Request::getUserVar('checkAffiliation')){
			$columns = $columns + array('authorAffiliation' => Locale::translate("editor.reports.authorAffiliation"));
		}
		if (Request::getUserVar('checkEmail')){
			$columns = $columns + array('authorEmail' => Locale::translate("editor.reports.authorEmail"));
		}
		if (Request::getUserVar('checkEngScientificTitle')){
			$columns = $columns + array('engScientificTitle' => Locale::translate("editor.reports.engScientificTitle"));
		}
		if (Request::getUserVar('checkCamScientificTitle')){
			$columns = $columns + array('camScientificTitle' => Locale::translate("editor.reports.camScientificTitle"));
		}
		if (Request::getUserVar('checkStudentResearch')){
			$columns = $columns + array('studentInstitution' => Locale::translate("editor.reports.studentInstitution"));
			$columns = $columns + array('studentAcademicDegree' => Locale::translate("editor.reports.studentAcademicDegree"));
			$columns = $columns + array('studentSupervisorName' => Locale::translate("editor.reports.studentSupervisorName"));
			$columns = $columns + array('studentSupervisorAffiliation' => Locale::translate("editor.reports.studentSupervisorAffiliation"));
			$columns = $columns + array('studentSupervisorEmail' => Locale::translate("editor.reports.studentSupervisorEmail"));
		}
		if (Request::getUserVar('checkPrimarySponsor')){
			$columns = $columns + array('primarySponsor' => Locale::translate("editor.reports.primarySponsor"));
		}
		if (Request::getUserVar('checkSecondarSponsor')){
			$columns = $columns + array('secondaySponsor' => Locale::translate("editor.reports.secondarySponsor"));
		}
		if (Request::getUserVar('checkResearchFields')){
			$columns = $columns + array('researchField' => Locale::translate("editor.reports.researchField"));
		}
		if (Request::getUserVar('checkProposalTypes')){
			$columns = $columns + array('proposalType' => Locale::translate("editor.reports.proposalType"));
		}
		if (Request::getUserVar('checkDuration')){
			$columns = $columns + array('duration' => Locale::translate("editor.reports.duration"));
		}
		if (Request::getUserVar('checkArea')){
			$columns = $columns + array('geoArea' => Locale::translate("editor.reports.country"));
		}
		if (Request::getUserVar('checkDataCollection')){
			$columns = $columns + array('dataCollection' => Locale::translate("editor.reports.dataCollection"));
		}
		if (Request::getUserVar('checkBudget')){
			$columns = $columns + array('budget' => Locale::translate("editor.reports.budget"));
			$columns = $columns + array('currency' => Locale::translate("editor.reports.currency"));
		}
		if (Request::getUserVar('checkErcReview')){
			$columns = $columns + array('otherErc' => Locale::translate("editor.reports.otherErcReview"));
		}
		if (Request::getUserVar('checkIndustryGrant')){
			$columns = $columns + array('industryGrant' => Locale::translate("editor.reports.industryGrant"));
		}
		if (Request::getUserVar('checkAgencyGrant')){
			$columns = $columns + array('agencyGrant' => Locale::translate("editor.reports.agencyGrant"));
		}
		if (Request::getUserVar('checkMohGrant')){
			$columns = $columns + array('mohGrant' => Locale::translate("editor.reports.mohGrant"));
		}
		if (Request::getUserVar('checkGovernmentGrant')){
			$columns = $columns + array('governmentGrant' => Locale::translate("editor.reports.governmentGrant"));
		}	
		if (Request::getUserVar('checkUniversityGrant')){
			$columns = $columns + array('universityGrant' => Locale::translate("editor.reports.universityGrant"));
		}
		if (Request::getUserVar('checkSelfFunding')){
			$columns = $columns + array('selfFunding' => Locale::translate("editor.reports.selfFunding"));
		}	
		if (Request::getUserVar('checkOtherGrant')){
			$columns = $columns + array('otherGrant' => Locale::translate("editor.reports.otherGrant"));
		}
		if (Request::getUserVar('checkIdentityRevealed')){
			$columns = $columns + array('identityRevealed' => Locale::translate("editor.reports.identityRevealedAbb"));
		}
		if (Request::getUserVar('checkUnableToConsent')){
			$columns = $columns + array('unableToConsent' => Locale::translate("editor.reports.unableToConsentAbb"));
		}
		if (Request::getUserVar('checkUnder18')){
			$columns = $columns + array('under18' => Locale::translate("editor.reports.under18Abb"));
		}
		if (Request::getUserVar('checkDependentRelationship')){
			$columns = $columns + array('dependentRelationship' => Locale::translate("editor.reports.dependentRelationshipAbb"));
		}
		if (Request::getUserVar('checkEthnicMinority')){
			$columns = $columns + array('ethnicMinority' => Locale::translate("editor.reports.ethnicMinorityAbb"));
		}
		if (Request::getUserVar('checkImpairment')){
			$columns = $columns + array('impairment' => Locale::translate("editor.reports.impairmentAbb"));
		}
		if (Request::getUserVar('checkPregnant')){
			$columns = $columns + array('pregnant' => Locale::translate("editor.reports.pregnantAbb"));
		}
		if (Request::getUserVar('checkNewTreatment')){
			$columns = $columns + array('newTreatment' => Locale::translate("editor.reports.newTreatmentAbb"));
		}
		if (Request::getUserVar('checkBioSamples')){
			$columns = $columns + array('bioSamples' => Locale::translate("editor.reports.bioSamplesAbb"));
		}
		if (Request::getUserVar('checkRadiation')){
			$columns = $columns + array('radiation' => Locale::translate("editor.reports.radiationAbb"));
		}
		if (Request::getUserVar('checkDistress')){
			$columns = $columns + array('distress' => Locale::translate("editor.reports.distressAbb"));
		}
		if (Request::getUserVar('checkInducements')){
			$columns = $columns + array('inducements' => Locale::translate("editor.reports.inducementsAbb"));
		}
		if (Request::getUserVar('checkSensitiveInfo')){
			$columns = $columns + array('sensitiveInfo' => Locale::translate("editor.reports.sensitiveInfoAbb"));
		}
		if (Request::getUserVar('checkDeception')){
			$columns = $columns + array('deception' => Locale::translate("editor.reports.deceptionAbb"));
		}
		if (Request::getUserVar('checkReproTechnology')){
			$columns = $columns + array('reproTechnology' => Locale::translate("editor.reports.reproTechnologyAbb"));
		}
		if (Request::getUserVar('checkGenetics')){
			$columns = $columns + array('genetics' => Locale::translate("editor.reports.geneticsAbb"));
		}
		if (Request::getUserVar('checkStemCell')){
			$columns = $columns + array('stemCell' => Locale::translate("editor.reports.stemCellAbb"));
		}
		if (Request::getUserVar('checkBiosafety')){
			$columns = $columns + array('biosafety' => Locale::translate("editor.reports.biosafetyAbb"));
		}
		if (Request::getUserVar('checkRiskLevel')){
			$columns = $columns + array('riskLevel' => Locale::translate("editor.reports.riskLevelAbb"));
			$columns = $columns + array('listRisks' => Locale::translate("editor.reports.listRisksAbb"));
			$columns = $columns + array('howRisksMinimized' => Locale::translate("editor.reports.howRisksMinimizedAbb"));
		}
		if (Request::getUserVar('checkRiskApplyTo')){
			$columns = $columns + array('riskApplyTo' => Locale::translate("editor.reports.riskApplyToAbb"));
		}
		if (Request::getUserVar('checkBenefitsFromTheProject')){
			$columns = $columns + array('benefitsFromTheProject' => Locale::translate("editor.reports.benefitsFromTheProjectAbb"));
		}
		if (Request::getUserVar('checkMultiInstitutions')){
			$columns = $columns + array('multiInstitutions' => Locale::translate("editor.reports.multiInstitutionsAbb"));
		}
		if (Request::getUserVar('checkConflictOfInterest')){
			$columns = $columns + array('conflictOfInterest' => Locale::translate("editor.reports.conflictOfInterestAbb"));
		}
		
		
		//Write into the csv
		$fp = fopen('php://output', 'wt');
		String::fputcsv($fp, array(date("F j, Y", mktime(0,0,0)).' - '.$journal->getLocalizedTitle().' - '.Locale::translate('editor.reports')));
		
		$criterias = array();		
		
		if ($submittedBefore) array_push($criterias, (Locale::translate('editor.reports.submittedBefore').'"'.$submittedBefore.'" ('.Locale::translate('editor.reports.inclusive').') '));
		if ($submittedAfter) array_push($criterias, (Locale::translate('editor.reports.submittedAfter').'"'.$submittedAfter.'" ('.Locale::translate('editor.reports.inclusive').') '));
		if ($approvedBefore) array_push($criterias, (Locale::translate('editor.reports.approvedBefore').'"'.$approvedBefore.'" ('.Locale::translate('editor.reports.inclusive').') '));
		if ($approvedAfter) array_push($criterias, (Locale::translate('editor.reports.approvedBefore').'"'.$approvedAfter.'" ('.Locale::translate('editor.reports.inclusive').') '));
		if ($startDateBefore) array_push($criterias, (Locale::translate('editor.reports.startDateBefore').'"'.$startDateBefore.'" ('.Locale::translate('editor.reports.inclusive').') '));
		if ($startDateAfter) array_push($criterias, (Locale::translate('editor.reports.startDateAfter').'"'.$startDateAfter.'" ('.Locale::translate('editor.reports.inclusive').') '));
		if ($endDateBefore) array_push($criterias, (Locale::translate('editor.reports.endDateBefore').'"'.$endDateBefore.'" ('.Locale::translate('editor.reports.inculsive').') '));
		if ($endDateAfter) array_push($criterias, (Locale::translate('editor.reports.endDateAfter').'"'.$endDateAfter.'" ('.Locale::translate('editor.reports.inclusive').') '));
		
		if (!empty($decisionField)){
			$decisionCriteria = "";
			$present = false;
			foreach ($decisionField as $decision){
				if(!empty($decision)){
					$present = true;
					if ($decisionCriteria == "" || $decisionCriteria == null) $decisionCriteria = Locale::translate($decision).' ';
					else $decisionCriteria .= Locale::translate('editor.reports.or').' '.Locale::translate($decision).' ';
				}
			}
			if ($present == true) array_push($criterias, (Locale::translate('editor.reports.committeeDecision').' '.$decisionCriteria));
		}
		if ($sresearch){
			if (!$adegree){
				if ($sresearch == 'Yes') array_push($criterias, Locale::translate('editor.reports.isStudentResearch'));
				else array_push($criterias, Locale::translate('editor.reports.isNotStudentResearch'));
			} elseif ($sresearch == 'Yes') {
				$deg = '';
				if ($adegree == 'Undergraduate') $deg = Locale::translate('editor.reports.undergraduate');
				elseif ($adegree == 'Master') $deg = Locale::translate('editor.reports.master');
				elseif ($adegree == 'Post-Doc') $deg = Locale::translate('editor.reports.postDoc');
				elseif ($adegree == 'Ph.D') $deg = Locale::translate('editor.reports.phd');
				else $deg = Locale::translate('editor.reports.other');
				array_push($criterias, (Locale::translate('editor.reports.aDegree1').' '.$deg.' '.Locale::translate('editor.reports.aDegree2').' '));
			}
		}
		if (!empty($primarySponsorField)){
			$primarySponsorCriteria = "";
			$present = false;
			foreach ($primarySponsorField as $primarySponsor){
				if(!empty($primarySponsor)){
					$present = true;
					if ($primarySponsorCriteria == "" || $primarySponsorCriteria == null) $primarySponsorCriteria = $primarySponsor.' ';
					else $primarySponsorCriteria .= Locale::translate('editor.reports.or').' '.$primarySponsor.' ';
				}
			}
			if ($present == true) array_push($criterias, (Locale::translate('editor.reports.pSponsor').' '.$primarySponsorCriteria));
		}
		if (!empty($secondarySponsorField)){
			$secondarySponsorCriteria = "";
			$present = false;
			foreach ($secondarySponsorField as $secondarySponsor){
				if(!empty($secondarySponsor)){
					$present = true;
					if ($secondarySponsorCriteria == "" || $secondarySponsorCriteria == null) $secondarySponsorCriteria = $secondarySponsor.' ';
					else $secondarySponsorCriteria .= Locale::translate('editor.reports.or').' '.$secondarySponsor.' ';
				}
			}
			if ($present == true) array_push($criterias, (Locale::translate('editor.reports.sSponsor').' '.$secondarySponsorCriteria));
		}
		if (!empty($researchFieldField)){
			$researchFieldCriteria = "";
			$present = false;
			foreach ($researchFieldField as $researchField){
				if(!empty($researchField)){
					$present = true;
					if ($researchFieldCriteria == "" || $researchFieldCriteria == null) $researchFieldCriteria = $articleDao->getResearchField($researchField).' ';
					else $researchFieldCriteria .= Locale::translate('editor.reports.or').' '.$articleDao->getResearchField($researchField).' ';
				}
			}
			if ($present == true) array_push($criterias, (Locale::translate('editor.reports.rField').' '.$researchFieldCriteria));
		}
		if (!empty($proposalTypeField)){
			$proposalTypeCriteria = "";
			$present = false;
			foreach ($proposalTypeField as $proposalType){
				if(!empty($proposalType)){
					$present = true;
					if ($proposalTypeCriteria == "" || $proposalTypeCriteria == null) $proposalTypeCriteria = $articleDao->getProposalType($proposalType).' ';
					else $proposalTypeCriteria .= Locale::translate('editor.reports.or').' '.$articleDao->getProposalType($proposalType).' ';
				}
			}
			if ($present == true) array_push($criterias, (Locale::translate('editor.reports.pType').' '.$proposalTypeCriteria));
		}		
		if ($dataCollection) {
			if ($dataCollection == 'Both') array_push($criterias, Locale::translate('editor.reports.bothDataCollection'));
			else {
				$dataC = ''; 
				if ($dataCollection == "Primary") $dataC = Locale::translate('editor.reports.primaryDC');
				else $dataC = Locale::translate('editor.reports.secondaryDC');
				array_push($criterias, (Locale::translate('editor.reports.dataCollection1').' '.$dataC.' '.Locale::translate('editor.reports.dataCollection2').' '));
			}
		}
		if ($multiCountry) {
			if ($multiCountry == 'Yes') array_push($criterias, Locale::translate('editor.reports.isMultipleCountry').' ');
			else array_push($criterias, Locale::translate('editor.reports.isNotMultipleCountry').' ');
		} 					
		if (!empty($countryField)){
			$provincesOfCambodiaDAO =& DAORegistry::getDAO('ProvincesOfCambodiaDAO');
			$countryCriteria = "";
			$present = false;
			foreach ($countryField as $country){
				if(!empty($country)){
					$present = true;
					if ($countryCriteria == "" || $countryCriteria == null) $countryCriteria = $provincesOfCambodiaDAO->getProvinceOfCambodia($country).' ';
					else $countryCriteria .= Locale::translate('editor.reports.or').' '.$provincesOfCambodiaDAO->getProvinceOfCambodia($country).' ';
				}
			}
			if ($present == true) array_push($criterias, (Locale::translate('editor.reports.provinceList').' '.$countryCriteria));
		}	
		
		if (!empty($criterias)) {
			$criteriaString = '';
			$i = 0;
			foreach ($criterias as $criteria) {
				if ($i != 0) {	
					$criteriaString .= Locale::translate('editor.reports.and').' '.$criteria;
				} else {
					$criteriaString = Locale::translate('editor.reports.criterias').':'.$criteria;
				}	
				$i++;			
			}
			String::fputcsv($fp, array($criteriaString));
		} else String::fputcsv($fp, array(Locale::translate('editor.reports.noCriterias')));
		
		String::fputcsv($fp, array(''));				
		String::fputcsv($fp, array_values($columns));
	
		$eng = 'en_US';
		$cam = 'kh_CA';
		
		foreach ($submissionsArray as $submission) {
			foreach ($columns as $index => $junk) {
				if ($index == 'whoId') {
					$columns[$index] = $submission->getWhoId($eng);
				} elseif ($index == 'decision') {
					if ($submission->getEditorDecisionKey()) $columns[$index] = Locale::translate($submission->getEditorDecisionKey());
					else $columns[$index] = Locale::translate('common.none');
				} elseif ($index == 'submitDate') {
					$columns[$index] = $submission->getDateSubmitted();
				} elseif ($index == 'approvedDate') {
					if ($submission->getApprovalDate($eng)) {
						$columns[$index] = $submission->getApprovalDate($eng);
					} else $columns[$index] =  Locale::translate('editor.article.decision.decline');
				} elseif ($index == 'author') {
					$columns[$index] = $submission->getPrimaryAuthor();
				} elseif ($index == 'authorAffiliation') {
					if ($submission->getInvestigatorAffiliation()) $columns[$index] = $submission->getInvestigatorAffiliation();
					else $columns[$index] = Locale::translate('common.none');
				} elseif ($index == 'authorEmail') {
					$columns[$index] = $submission->getAuthorEmail();
				} elseif ($index == 'engScientificTitle') {
					$columns[$index] = $submission->getScientificTitle($eng);
				} elseif ($index == 'camScientificTitle') {
					$columns[$index] = $submission->getScientificTitle($cam);
				} elseif ($index == 'studentInstitution') {
					if ($submission->getStudentInitiatedResearch($eng) == 'Yes') $columns[$index] = $submission->getStudentInstitution($eng);
					else $columns[$index] = Locale::translate('common.none');
				} elseif ($index == 'studentAcademicDegree') {
					if ($submission->getStudentInitiatedResearch($eng) == 'Yes') {
						if ($submission->getAcademicDegree($eng) == "Undergraduate") $columns[$index] = Locale::translate('editor.reports.undergraduate');
						elseif ($submission->getAcademicDegree($eng) == "Master") $columns[$index] = Locale::translate('editor.reports.master');
						elseif ($submission->getAcademicDegree($eng) == "Post-Doc") $columns[$index] = Locale::translate('editor.reports.postDoc');
						elseif ($submission->getAcademicDegree($eng) == "Ph.D") $columns[$index] = Locale::translate('editor.reports.phd');
						else $columns[$index] = Locale::translate('editor.reports.other');
					} else $columns[$index] = Locale::translate('common.none');
				} elseif ($index == 'studentSupervisorName') {
					if ($submission->getStudentInitiatedResearch($eng) == 'Yes')$columns[$index] = $submission->getSupervisorFullName($eng);
					else $columns[$index] = Locale::translate('common.none');
				} elseif ($index == 'studentSupervisorAffiliation') {
					if ($submission->getStudentInitiatedResearch($eng) == 'Yes')$columns[$index] = $submission->getSupervisorAffiliation($eng);
					else $columns[$index] = Locale::translate('common.none');
				} elseif ($index == 'studentSupervisorEmail') {
					if ($submission->getStudentInitiatedResearch($eng) == 'Yes')$columns[$index] = $submission->getSupervisorEmail($eng);
					else $columns[$index] = Locale::translate('common.none');
				} elseif ($index == 'primarySponsor') {
					$columns[$index] = $submission->getPrimarySponsor($eng);
				} elseif ($index == 'secondaySponsor') {
					if ($submission->getSecondarySponsors($eng)) $columns[$index] = $submission->getSecondarySponsors($eng);
					else $columns[$index] = Locale::translate('common.none');
				} elseif ($index == 'researchField') {
					$columns[$index] = $submission->getLocalizedResearchFieldText();
				} elseif ($index == 'proposalType') {
					$columns[$index] = $submission->getLocalizedProposalTypeText();
				} elseif ($index == 'dataCollection') {
					if ($submission->getDataCollection($eng) == "Primary") $columns[$index] = Locale::translate('editor.reports.primaryDC');
					elseif ($submission->getDataCollection($eng) == "Secondary") $columns[$index] = Locale::translate('editor.reports.secondaryDC');
					else $columns[$index] = Locale::translate('editor.reports.bothDC');
				} elseif ($index == 'geoArea') {
					if ($submission->getMultiCountryResearch($eng) == 'Yes') $columns[$index] = $submission->getLocalizedMultiCountryText();
					elseif ($submission->getLocalizedProposalCountryText($eng))  $columns[$index] = $submission->getLocalizedProposalCountryText();
					else $columns[$index] = Locale::translate('common.none');
				} elseif ($index == 'duration') {
					$columns[$index] = $submission->getStartDate($eng).Locale::translate('editor.reports.to').$submission->getEndDate($eng);
				} elseif ($index == 'budget') {
					$columns[$index] = $submission->getFundsRequired($eng);
				} elseif ($index == 'currency') {
					$columns[$index] = $submission->getSelectedCurrency($eng);
				} elseif ($index == 'otherErc') {
					if ($submission->getReviewedByOtherErc($eng) == 'Yes') {
						if ($submission->getOtherErcDecision($eng) == "Under Review") $columns[$index] = Locale::translate('editor.reports.underReview');
						else $columns[$index] = Locale::translate('editor.reports.decisionAvailable');
					} else  $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'industryGrant') {
					if ($submission->getIndustryGrant($eng) == 'Yes') $columns[$index] = $submission->getNameOfIndustry($eng);
					else  $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'agencyGrant') {
					if ($submission->getInternationalGrant($eng) == 'Yes') $columns[$index] = $submission->getInternationalGrantName($eng);
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'mohGrant') {
					if ($submission->getMohGrant($eng) == "Yes")$columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'governmentGrant') {
					if ($submission->getGovernmentGrant($eng) == 'Yes') $columns[$index] = $submission->getGovernmentGrantName($eng);
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'universityGrant') {
					if ($submission->getUniversityGrant($eng) == "Yes") $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'selfFunding') {
					if ($submission->getSelfFunding($eng) == "Yes") $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'otherGrant') {
					if ($submission->getOtherGrant($eng) == 'Yes') $columns[$index] = $submission->getSpecifyOtherGrant($eng);
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'identityRevealed') {
					if ($submission->getIdentityRevealed($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'unableToConsent') {
					if ($submission->getUnableToConsent($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'under18') {
					if ($submission->getUnder18($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'dependentRelationship') {
					if ($submission->getDependentRelationship($eng) == 'Yes') Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'ethnicMinority') {
					if ($submission->getEthnicMinority($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'impairment') {
					if ($submission->getImpairment($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'pregnant') {
					if ($submission->getPregnant($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'newTreatment') {
					if ($submission->getNewTreatment($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'bioSamples') {
					if ($submission->getBioSamples($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'radiation') {
					if ($submission->getRadiation($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'distress') {
					if ($submission->getDistress($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'inducements') {
					if ($submission->getInducements($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'sensitiveInfo') {
					if ($submission->getSensitiveInfo($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'deception') {
					if ($submission->getDeception($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'reproTechnology') {
					if ($submission->getReproTechnology($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'genetics') {
					if ($submission->getGenetics($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'stemCell') {
					if ($submission->getStemCell($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'biosafety') {
					if ($submission->getBiosafety($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'riskLevel') {
					if ($submission->getRiskLevel($eng) == 'No more than minimal risk') $columns[$index] = Locale::translate('editor.reports.riskUnder');
					elseif ($submission->getRiskLevel($eng) == 'Minor increase over minimal risk') $columns[$index] = Locale::translate('editor.reports.riskMinor');
					else $columns[$index] = Locale::translate('editor.reports.riskMajor');
				} elseif ($index == 'listRisks') {
					if ($submission->getRiskLevel($eng) != 'No more than minimal risk') $columns[$index] = $submission->getListRisks($eng);
					else $columns[$index] = Locale::translate('editor.reports.riskUnder');
				} elseif ($index == 'howRisksMinimized') {
					if ($submission->getRiskLevel($eng) != 'No more than minimal risk') $columns[$index] = $submission->getHowRisksMinimized($eng);
					else $columns[$index] = Locale::translate('editor.reports.riskUnder');
				} elseif ($index == 'riskApplyTo') {
		        	$riskApplyToArray = $submission->getRiskApplyTo(null);
        			$firstRisk = "0";
        			$riskApplyToString = '';
					if ($riskApplyToArray[$eng][0] == '1') {
						if ($firstRisk == "0") $riskApplyToString = Locale::translate('editor.reports.researchTeam');
						else $riskApplyToString .= ' & '.Locale::translate('editor.reports.researchTeam');
						$firstRisk = "1";
					}
					if ($riskApplyToArray[$eng][1] == '1') {
						if ($firstRisk == "0") $riskApplyToString = Locale::translate('editor.reports.researchSubjects');
						else $riskApplyToString .= ' & '.Locale::translate('editor.reports.researchSubjects');
						$firstRisk = "1";
					}
					if ($riskApplyToArray[$eng][2] == '1') {
						if ($firstRisk == "0") $riskApplyToString = Locale::translate('editor.reports.widerCommunity');
						else $riskApplyToString .= ' & '.Locale::translate('editor.reports.widerCommunity');
						$firstRisk = "1";
					}
					if (($riskApplyToArray[$eng][0] != '1') && ($riskApplyToArray[$eng][1] != '1') && ($riskApplyToArray[$eng][2] != '1')) {
						$riskApplyToString = Locale::translate('editor.reports.nobody');
					}
					$columns[$index] = $riskApplyToString;
				} elseif ($index == 'benefitsFromTheProject') {
		        	$benefitsArray = $submission->getBenefitsFromTheProject(null);
        			$firstBenefits = "0";
        			$benefitsString = '';
					if ($benefitsArray[$eng][0] == '1') {
						if ($firstBenefits == "0") $benefitsString = Locale::translate('editor.reports.directBenefits');
						else $benefitsString .= ' & '.Locale::translate('editor.reports.directBenefits');
						$firstBenefits = "1";
					}
					if ($benefitsArray[$eng][1] == '1') {
						if ($firstBenefits == "0") $benefitsString = Locale::translate('editor.reports.participantCondition');
						else $benefitsString .= ' & '.Locale::translate('editor.reports.participantCondition');
						$firstBenefits = "1";
					}
					if ($benefitsArray[$eng][2] == '1') {
						if ($firstBenefits == "0") $benefitsString = Locale::translate('editor.reports.diseaseOrCondition');
						else $benefitsString .= ' & '.Locale::translate('editor.reports.diseaseOrCondition');
						$firstBenefits = "1";
					}
					if (($benefitsArray[$eng][0] != '1') && ($benefitsArray[$eng][1] != '1') && ($benefitsArray[$eng][2] != '1')) {
						$benefitsString = Locale::translate('editor.reports.noBenefits');
					}
					$columns[$index] = $benefitsString;
				} elseif ($index == 'multiInstitutions') {
					if ($submission->getMultiInstitutions($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					else $columns[$index] = Locale::translate('common.no');
				} elseif ($index == 'conflictOfInterest') {
					if ($submission->getConflictOfInterest($eng) == 'Yes') $columns[$index] = Locale::translate('common.yes');
					elseif ($submission->getConflictOfInterest($eng) == 'No') $columns[$index] = Locale::translate('common.no');
					else $columns[$index] = Locale::translate('common.notSure');
				}			
			
			}						
			String::fputcsv($fp, $columns);
			unset($row);
		}
	
		fclose($fp);
	}

}

?>
