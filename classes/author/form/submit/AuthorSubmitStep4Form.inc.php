<?php

/**
 * @file classes/author/form/submit/AuthorSubmitStep4Form.inc.php
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class AuthorSubmitStep4Form
 * @ingroup author_form_submit
 *
 * @brief Form for Step 4 of author article submission.
 */

// $Id$


import('classes.author.form.submit.AuthorSubmitForm');

class AuthorSubmitStep4Form extends AuthorSubmitForm {
	/**
	 * Constructor.
	 */
	function AuthorSubmitStep4Form(&$article, &$journal) {
		parent::AuthorSubmitForm($article, 4, $journal);
	}

	/**
	 * Display the form.
	 */
	function display() {
		$templateMgr =& TemplateManager::getManager();
                
                // Start Edit Raf Tan 04/30/2011
                // Add Options drop-down list for WHO journals
                $typeOptions = array(
                    "SUMMARY" => "common.submit.suppFile.who.summary",
                    //"common.submit.suppFile.who.proposal" => "common.submit.suppFile.who.proposal",
                    "INFORMED_CONSENT" => "common.submit.suppFile.who.informedConsent",
                    //"common.submit.suppFile.who.localEthicalApproval" => "common.submit.suppFile.who.localEthicalApproval",
                    "FUNDING" => "common.submit.suppFile.who.funding",
                    "CV" => "common.submit.suppFile.who.cv",
                    "QUESTIONNAIRE" => "common.submit.suppFile.who.questionnaire",
                    // Deleted common.submit.suppFile.who.local option as supplementary file - 9Dec2011 - spf
                    // "common.submit.suppFile.who.local" => "common.submit.suppFile.who.local",
                    //"common.submit.suppFile.who.ethicalClearance" => "common.submit.suppFile.who.ethicalClearance",
                    "PROOF_OF_REGISTRATION" => "common.submit.suppFile.who.proofOfRegistration",
                    "ERC_DECISION" => "common.submit.suppFile.who.otherErcDecision",
                    //"common.submit.suppFile.who.review" => "common.submit.suppFile.who.review",
                    "OTHER" => "common.other"
		);
		//$typeOptionsValues = $typeOptionsOutput;
		//array_push($typeOptionsOutput, 'common.other');
		//array_push($typeOptionsValues, '');

		$templateMgr->assign('typeOptions', $typeOptions);
		//$templateMgr->assign('typeOptionsValues', $typeOptionsValues);
                // End Edit Raf Tan 04/30/2011

		// Get supplementary files for this article
		$suppFileDao =& DAORegistry::getDAO('SuppFileDAO');
		$templateMgr->assign_by_ref('suppFiles', $suppFileDao->getSuppFilesByArticle($this->articleId));

		parent::display();
	}

	/**
	 * Save changes to article.
	 */
	function execute() {
		$articleDao =& DAORegistry::getDAO('ArticleDAO');

		// Update article
		$article =& $this->article;
		if ($article->getSubmissionProgress() <= $this->step) {
			$article->stampStatusModified();
			$article->setSubmissionProgress($this->step + 1);
		}
		$articleDao->updateArticle($article);

		return $this->articleId;
	}
}

?>
