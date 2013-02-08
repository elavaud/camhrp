{**
 * profile.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * User profile form.
 *
 * $Id$
 *}
{strip}
{assign var="pageTitle" value="user.profile.editProfile"}
{url|assign:"url" op="profile"}
{include file="common/header.tpl"}
{/strip}

{assign var="viet" value="vi_VN"}
{assign var="eng" value="en_US"}

{literal}
<script type="text/javascript">
	$(document).ready(function(){
   		//Start code for multiple reviewing interests
        $('#addAnotherInterest').click(
        	function(){
           		var reviewingInterestHtml = '<tr valign="top" class="reviewingInterestSupp">' + $('#firstReviewingInterest').html() + '</tr>';
            	$('#firstReviewingInterest').after(reviewingInterestHtml);
            	$('#firstReviewingInterest').next().find('select').attr('selectedIndex', 0);
            	$('.reviewingInterestSupp').find('.removeReviewingInterest').show();
            	$('.reviewingInterestSupp').find('.reviewingInterestTitle').hide();
            	$('.reviewingInterestSupp').find('.noReviewingInterestTitle').show();
            	$('#firstReviewingInterest').find('.removeReviewingInterest').hide();
            	$('#firstReviewingInterest').find('.reviewingInterestTitle').show();
            	$('#firstReviewingInterest').find('.noReviewingInterestTitle').hide();
            	return false;
        	}
        );

        $('.removeReviewingInterest').live(
        	'click', function(){
        		$(this).closest('tr').remove();
            	return false;
        	}
        );
    	//End code for multiple reviewing interests
	});
</script>
{/literal}

<form name="profile" method="post" action="{url op="saveProfile"}" enctype="multipart/form-data">

{include file="common/formErrors.tpl"}

<table class="data" width="100%">
{if count($formLocales) > 1}
	<tr valign="top" id="localesField">
		<td width="20%" class="label">{fieldLabel name="formLocale" required="true" key="common.language"}</td>
		<td width="80%" class="value">
			{url|assign:"userProfileUrl" page="user" op="profile" escape=false}
			{form_language_chooser form="profile" url=$userProfileUrl}
			<span class="instruct">{translate key="form.formLanguage.description"}</span>
		</td>
	</tr>
{/if}
<tr valign="top" id="usernameField">
	<td width="20%" class="label">{fieldLabel suppressId="true" name="username" key="user.username"}</td>
	<td width="80%" class="value">{$username|escape}</td>
</tr>

<tr valign="top" id="salutationField">
	<td class="label">{fieldLabel name="salutation" key="user.salutation"}</td>
	<td class="value">
		<select name="salutation" id="salutation" class="selectMenu">
			<option value=""></option>
			<option value="Dr." {if  $salutation == "Dr." } selected="selected"{/if}>{translate key="user.salutation.dr"}</option>
			<option value="Prof." {if  $salutation == "Prof." } selected="selected"{/if}>{translate key="user.salutation.prof"}</option>
			<option value="Ms." {if  $salutation == "Ms." } selected="selected"{/if}>{translate key="user.salutation.ms"}</option>
			<option value="Mr." {if  $salutation == "Mr." } selected="selected"{/if}>{translate key="user.salutation.mr"}</option>
		</select>	
	</td>
</tr>

<tr valign="top" id="firstNameField">
	<td class="label">{fieldLabel name="firstName" required="true" key="user.firstName"}</td>
	<td class="value"><input type="text" name="firstName" id="firstName" value="{$firstName|escape}" size="20" maxlength="40" class="textField" /></td>
</tr>

<tr valign="top" id="middleNameField">
	<td class="label">{fieldLabel name="middleName" key="user.middleName"}</td>
	<td class="value"><input type="text" name="middleName" id="middleName" value="{$middleName|escape}" size="20" maxlength="40" class="textField" /></td>
</tr>

<tr valign="top" id="lastNameField">
	<td class="label">{fieldLabel name="lastName" required="true" key="user.lastName"}</td>
	<td class="value"><input type="text" name="lastName" id="lastName" value="{$lastName|escape}" size="20" maxlength="90" class="textField" /></td>
</tr>

<tr valign="top" id="genderField">
	<td class="label">{fieldLabel name="gender" key="user.gender"}</td>
	<td class="value">
		<select name="gender" id="gender" size="1" class="selectMenu">
			{html_options_translate options=$genderOptions selected=$gender}
		</select>
	</td>
</tr>

<tr valign="top" id="affiliationField">
	<td class="label">{fieldLabel name="affiliation" required="true" key="user.affiliation"}</td>
	<td class="value">
		<textarea name="affiliation[{$formLocale|escape}]" id="affiliation" rows="5" cols="40" class="textArea">{$affiliation[$formLocale]|escape}</textarea><br/>
		<span class="instruct">{translate key="user.affiliation.description"}</span>
	</td>
</tr>

<tr valign="top" id="bioField">
	<td class="label">{fieldLabel name="biography" key="user.biography"}<br />{translate key="user.biography.description"}</td>
	<td class="value"><textarea name="biography[{$formLocale|escape}]" id="biography" rows="5" cols="40" class="textArea">{$biography[$formLocale]|escape}</textarea></td>
</tr>

<tr valign="top" id="emailField">
	<td class="label">{fieldLabel name="email" required="true" key="user.email"}</td>
	<td class="value"><input type="text" name="email" id="email" value="{$email|escape}" size="30" maxlength="90" class="textField" /></td>
</tr>

<tr valign="top" id="phoneField">
	<td class="label">{fieldLabel name="phone" required="true" key="user.phone"}</td>
	<td class="value"><input type="text" name="phone" id="phone" value="{$phone|escape}" size="15" maxlength="24" class="textField" /></td>
</tr>

<tr valign="top" id="phoneInstructField">
	<td class="label">&nbsp;</td>
	<td class="value"><i>{translate key="user.phoneInstruct"}</i></td>
</tr>

<tr valign="top" id="mailingAddressField">
	<td class="label">{fieldLabel name="mailingAddress" required="true" key="common.mailingAddress"}</td>
	<td class="value"><textarea name="mailingAddress" id="mailingAddress" rows="3" cols="40" class="textArea">{$mailingAddress|escape}</textarea></td>
</tr>

<tr valign="top" id="mailingAddressInstructField">
	<td class="label">&nbsp;</td>
	<td class="value"><i>{translate key="common.mailingAddressInstruct"}</i></td>
</tr>

<tr valign="top" id="residenceField">
	<td class="label">{fieldLabel name="country" required="true" key="common.country"}</td>
	<td class="value">
		<select name="country" id="country" class="selectMenu">
			<option value=""></option>
			{html_options options=$countries selected=$country}
		</select>
	</td>
</tr>

		<tr valign="top" id="reviewingInterestInstructField">
			<td colspan="2"><i><br/>{translate key="common.reviewingInterestsInstruct"}</i></td>
		</tr>
		{foreach from=$reviewingInterest[$eng] key=i item=interest}
    		<tr valign="top" {if $i == 0} id="firstReviewingInterest" {else} id="reviewingInterestField" {/if}>
    			<td width="20%" class="reviewingInterestTitle">{if $i == 0}{translate key="common.reviewingInterests"}:{else}&nbsp;{/if}</td>
    	    	<td width="20%" class="noReviewingInterestTitle" style="display:none;">&nbsp;</td>
    	    	<td width="80%" class="value">
    	    		<select name="reviewingInterest[{$eng|escape}][]" class="selectMenu">
    	        		<option value=""></option>
    	            	{foreach from=$reviewingInterests key=if item=rInterest}
    	            		{assign var="isSelected" value=false}
    	            		{foreach from $reviewingInterest[$eng] key=if item=selectedInterests}
    	            			{if $reviewingInterest[$eng][$i] == $rInterest.code}
    	            				{assign var="isSelected" value=true}
    	            			{/if}
    	            		{/foreach}
    	            		<option value="{$rInterest.code}" {if $isSelected==true}selected="selected"{/if}>{$rInterest.name}</option>
    	            	{/foreach}
    	        	</select>
    	        	<a href="" class="removeReviewingInterest" {if $i == 0}style="display:none"{/if}>{translate key="common.remove"}</a>
		    	</td>
    		</tr>
		{/foreach}                  
    	<tr id="addAnotherInterest">
    		<td width="20%">&nbsp;</td>
    	    <td><a href="#" id="addAnotherInterest">{translate key="common.addReviewingInterest"}</a></td>
    	</tr>

{*
<tr valign="top" id="profileImageField">
	<td class="label">
		{fieldLabel name="profileImage" key="user.profile.form.profileImage"}
	</td>
	<td class="value">
		<input type="file" id="profileImage" name="profileImage" class="uploadField" /> <input type="submit" name="uploadProfileImage" value="{translate key="common.upload"}" class="button" />
		{if $profileImage}
			{translate key="common.fileName"}: {$profileImage.name|escape} {$profileImage.dateUploaded|date_format:$datetimeFormatShort} <input type="submit" name="deleteProfileImage" value="{translate key="common.delete"}" class="button" />
			<br />
			<img src="{$sitePublicFilesDir}/{$profileImage.uploadName|escape:"url"}" width="{$profileImage.width|escape}" height="{$profileImage.height|escape}" style="border: 0;" alt="{translate key="user.profile.form.profileImage"}" />
		{/if}
	</td>
</tr>

{if count($availableLocales) > 1}
<tr valign="top" id="workingLanguagesField">
	<td class="label">{translate key="user.workingLanguages"}</td>
	<td>{foreach from=$availableLocales key=localeKey item=localeName}
		<input type="checkbox" name="userLocales[]" id="userLocales-{$localeKey|escape}" value="{$localeKey|escape}"{if in_array($localeKey, $userLocales)} checked="checked"{/if} /> <label for="userLocales-{$localeKey|escape}">{$localeName|escape}</label><br />
	{/foreach}</td>
</tr>
{/if}
*}

{if $displayOpenAccessNotification}
	{assign var=notFirstJournal value=0}
	{foreach from=$journals name=journalOpenAccessNotifications key=thisJournalId item=thisJournal}
		{assign var=thisJournalId value=$thisJournal->getJournalId()}
		{assign var=publishingMode value=$thisJournal->getSetting('publishingMode')}
		{assign var=enableOpenAccessNotification value=$thisJournal->getSetting('enableOpenAccessNotification')}
		{assign var=notificationEnabled value=$user->getSetting('openAccessNotification', $thisJournalId)}
		{if !$notFirstJournal}
			{assign var=notFirstJournal value=1}
			<tr valign="top">
				<td class="label">{translate key="user.profile.form.openAccessNotifications"}</td>
				<td class="value">
		{/if}

		{if $publishingMode == $smarty.const.PUBLISHING_MODE_SUBSCRIPTION && $enableOpenAccessNotification}
			<input type="checkbox" name="openAccessNotify[]" {if $notificationEnabled}checked="checked" {/if}id="openAccessNotify-{$thisJournalId|escape}" value="{$thisJournalId|escape}" /> <label for="openAccessNotify-{$thisJournalId|escape}">{$thisJournal->getLocalizedTitle()|escape}</label><br/>
		{/if}

		{if $smarty.foreach.journalOpenAccessNotifications.last}
				</td>
			</tr>
		{/if}
	{/foreach}
{/if}

</table>
<p><input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> <input type="button" value="{translate key="common.cancel"}" class="button" onclick="document.location.href='{url page="user"}'" /></p>
</form>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>

{include file="common/footer.tpl"}

