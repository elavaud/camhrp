{**
 * userProfileForm.tpl
 *
 * Copyright (c) 2003-2011 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * User profile form under journal management.
 *
 * $Id$
 *}
{strip}
{url|assign:"currentUrl" op="people" path="all"}
{assign var="pageTitle" value="manager.people"}
{include file="common/header.tpl"}
{/strip}

{assign var="cam" value="kh_CA"}
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

{if not $userId}
{assign var="passwordRequired" value="true"}

{literal}
<script type="text/javascript">
<!--
	function setGenerateRandom(value) {
		if (value) {
			document.userForm.password.value='********';
			document.userForm.password2.value='********';
			document.userForm.password.disabled=1;
			document.userForm.password2.disabled=1;
			document.userForm.sendNotify.checked=1;
			document.userForm.sendNotify.disabled=1;
		} else {
			document.userForm.password.disabled=0;
			document.userForm.password2.disabled=0;
			document.userForm.sendNotify.disabled=0;
			document.userForm.password.value='';
			document.userForm.password2.value='';
			document.userForm.password.focus();
		}
	}

	function enablePasswordFields() {
		document.userForm.password.disabled=0;
		document.userForm.password2.disabled=0;
	}

	function generateUsername() {
		var req = makeAsyncRequest();

		if (document.userForm.lastName.value == "") {
			alert("{/literal}{translate key="manager.people.mustProvideName"}{literal}");
			return;
		}

		req.onreadystatechange = function() {
			if (req.readyState == 4) {
				document.userForm.username.value = req.responseText;
			}
		}
		sendAsyncRequest(req, '{/literal}{url op="suggestUsername" firstName="REPLACE1" lastName="REPLACE2" escape=false}{literal}'.replace('REPLACE1', escape(document.userForm.firstName.value)).replace('REPLACE2', escape(document.userForm.lastName.value)), null, 'get');
	}

// -->
</script>
{/literal}
{/if}

{if $userCreated}
<p>{translate key="manager.people.userCreatedSuccessfully"}</p>
{/if}
<h3>{if $userId}{translate key="manager.people.editProfile"}{else}{translate key="manager.people.createUser"}{/if}</h3>

<form name="userForm" method="post" action="{url op="updateUser"}" onsubmit="enablePasswordFields()">
<input type="hidden" name="source" value="{$source|escape}" />
{if $userId}
<input type="hidden" name="userId" value="{$userId|escape}" />
{/if}

{include file="common/formErrors.tpl"}

<table width="100%" class="data">
	{if count($formLocales) > 1}

		<tr valign="top" id="localesField">
	 	<td width="20%" class="label">{fieldLabel name="formLocale" key="form.formLanguage"}</td>
		<td width="80%" class="value">
			{url|assign:"userFormUrl" page="manager" op="editUser" path=$userId escape=false}
			{form_language_chooser form="userForm" url=$userFormUrl}
			<span class="instruct">{translate key="form.formLanguage.description"}</span>
		</td>
	</tr>
	
	{/if}

	<tr valign="top" id="salutationField">
		<td class="label">{fieldLabel name="salutation" key="user.salutation"}</td>
		<td class="value">
			<select name="salutation" id="salutation" class="selectMenu">
				<option value=""></option>
				<option value="Dr." {if  $salutation == "Dr." } selected="selected"{/if}>Dr.</option>
				<option value="Prof." {if  $salutation == "Prof." } selected="selected"{/if}>Prof.</option>
				<option value="Ms." {if  $salutation == "Ms." } selected="selected"{/if}>Ms.</option>
				<option value="Mr." {if  $salutation == "Mr." } selected="selected"{/if}>Mr.</option>
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
		<td class="label">{fieldLabel suppressId="true" name="gender" key="user.gender"}</td>
		<td class="value">
			<select name="gender" id="gender" size="1" class="selectMenu">
				{html_options_translate options=$genderOptions selected=$gender}
			</select>
		</td>
	</tr>
	
	{if not $userId}
	<tr valign="top" id="usernameInstructField">
		<td class="label">{fieldLabel name="username" required="true" key="user.username"}</td>
		<td class="value">
			<input type="text" name="username" id="username" value="{$username|escape}" size="20" maxlength="32" class="textField" />&nbsp;&nbsp;<input type="button" class="button" value="{translate key="common.suggest"}" onclick="generateUsername()" />
			<br />
			<span class="instruct">{translate key="user.register.usernameRestriction"}</span>
		</td>
	</tr>
	{else} 
	<tr valign="top" id="usernameField">
		<td class="label">{fieldLabel suppressId="true" name="username" key="user.username"}</td>
		<td class="value"><strong>{$username|escape}</strong></td>
	</tr>
	{/if}
	
	{if $authSourceOptions}
	<tr valign="top" id="authSourceField">
		<td class="label">{fieldLabel name="authId" key="manager.people.authSource"}</td>
		<td class="value"><select name="authId" id="authId" size="1" class="selectMenu">
			<option value=""></option>
			{html_options options=$authSourceOptions selected=$authId}
		</select></td>
	</tr>
	{/if}

	{if !$implicitAuth}
	
		<tr valign="top" id="passwordField">
			<td class="label">{fieldLabel name="password" required=$passwordRequired key="user.password"}</td>
			<td class="value">
				<input type="password" name="password" id="password" value="{$password|escape}" size="20" maxlength="32" class="textField" />
				<br />
				<span class="instruct">{translate key="user.register.passwordLengthRestriction" length=$minPasswordLength}</span>
			</td>
		</tr>
		
		<tr valign="top" id="password2Field">
			<td class="label">{fieldLabel name="password2" required=$passwordRequired key="user.register.repeatPassword"}</td>
			<td class="value"><input type="password" name="password2"  id="password2" value="{$password2|escape}" size="20" maxlength="32" class="textField" /></td>
		</tr>
		
		{if $userId}
		
		<tr valign="top" id="passwordInstructField">
			<td>&nbsp;</td>
			<td class="value">{translate key="user.register.passwordLengthRestriction" length=$minPasswordLength}<br />{translate key="user.profile.leavePasswordBlank"}</td>
		</tr>
		
		{else}
		
		<tr valign="top" id="randomPasswordField">
			<td class="label">&nbsp;</td>
			<td class="value"><input type="checkbox" onclick="setGenerateRandom(this.checked)" name="generatePassword" id="generatePassword" value="1"{if $generatePassword} checked="checked"{/if} /> <label for="generatePassword">{translate key="manager.people.createUserGeneratePassword"}</label></td>
		</tr>
		
		<tr valign="top" id="sendPasswordField">
			<td class="label">&nbsp;</td>
			<td class="value"><input type="checkbox" name="sendNotify" id="sendNotify" value="1"{if $sendNotify} checked="checked"{/if} /> <label for="sendNotify">{translate key="manager.people.createUserSendNotify"}</label></td>
		</tr>
		
		{/if}
		<tr valign="top" id="mustCahngePasswordField">
			<td class="label">&nbsp;</td>
			<td class="value"><input type="checkbox" name="mustChangePassword" id="mustChangePassword" value="1"{if $mustChangePassword} checked="checked"{/if} /> <label for="mustChangePassword">{translate key="manager.people.userMustChangePassword"}</label></td>
		</tr>
		
	{/if}{* !$implicitAuth *}

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

</table>

<p><input type="submit" value="{translate key="common.save"}" class="button defaultButton" /> {if not $userId}<input type="submit" name="createAnother" value="{translate key="manager.people.saveAndCreateAnotherUser"}" class="button" /> {/if}<input type="button" value="{translate key="common.cancel"}" class="button" onclick="{if $source == ''}history.go(-1);{else}document.location='{$source|escape:"jsparam"}';{/if}" /></p>

<p><span class="formRequired">{translate key="common.requiredField"}</span></p>

</form>

{if $generatePassword}
{literal}
	<script type="text/javascript">
		<!--
		setGenerateRandom(1);
		// -->
	</script>
{/literal}
{/if}

{include file="common/footer.tpl"}

